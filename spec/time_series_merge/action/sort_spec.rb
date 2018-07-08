require 'spec_helper'

describe TimeSeriesMerge::Action::Sort do
  include_context 'shared context'

  let(:iteration_count_for_line) { 10 }
  let(:iteration_count_for_line2) { 5 }
  let(:iteration_count_for_split) { 10_001 }

  let(:input_filename) { 'input_filename' }
  let(:output_filename) { 'output_filename' }

  let(:file_list) { [file1, file2] }

  let(:destination_file_name) { 'destination_file_name' }

  let(:next_filename1) { "#{destination_file_name}.1" }
  let(:next_filename2) { "#{destination_file_name}.2" }
  let(:next_filename3) { "#{destination_file_name}.3" }

  let(:split_file1) { file.new([]) }
  let(:split_file2) { file.new([]) }

  let(:infile) do
    f = file.new([])
    iteration_count_for_line.times { f.puts(line1) }
    iteration_count_for_line2.times { f.puts(line2) }
    f
  end
  let(:outfile) { file.new([]) }

  context 'run' do
    let(:sorted_filename) { "#{destination_file_name}.#{subject.class::SORTED_FILE_EXTENSION}" }

    before(:each) do
      allow(subject).to receive(:make_split).and_return(nil)
      allow(subject).to receive(:sort_split).with(sorted_filename).and_return(nil)
      allow(subject).to receive(:merge_split).and_return(nil)

      allow(File).to receive(:delete).with(destination_file_name).and_return(nil)
      allow(File).to receive(:rename).with(sorted_filename, destination_file_name).and_return(nil)
      allow(File).to receive(:rename).with(next_filename3, sorted_filename).and_return(nil)

      subject.opts = opts.new(destination_file_name, nil)
      subject.instance_variable_set(:@files_to_merge, [next_filename2, next_filename1, next_filename3])
      subject.instance_variable_set(:@files_to_sort, [sorted_filename])
      subject.run
    end

    it 'make_split invoke' do
      expect(subject).to have_received(:make_split).ordered
    end

    it 'sort_split invoke' do
      expect(subject).to have_received(:sort_split).ordered
    end

    it 'merge_split invoke' do
      expect(subject).to have_received(:merge_split).ordered
    end
  end

  it 'name extension makes equal 1' do
    subject.opts = opts.new(destination_file_name, nil)
    expect(subject.next_filename).to eq("#{destination_file_name}.1")
  end

  context 'make_split' do
    let(:big_infile) do
      f = file.new([])
      iteration_count_for_split.times { f.puts(line1) }
      f
    end

    let(:split_file1) { file.new([]) }
    let(:split_file2) { file.new([]) }

    context 'infile has not split by limit' do
      before(:each) do
        allow(File).to receive(:open).with(destination_file_name).and_return(infile)
        allow(File).to receive(:open).with(next_filename1, File::WRONLY).and_return(split_file1)

        subject.opts = opts.new(destination_file_name, nil)
        subject.make_split
      end

      it 'add records to new next_filename1' do
        expect(split_file1.records).to include(*infile.records)
      end

      it 'not add records to next_filename2' do
        expect(split_file2.records.size).to eq(0)
      end

      it '@files_to_sort add next_filename1' do
        expect(subject.instance_variable_get(:@files_to_sort)).to include(next_filename1)
      end
    end

    context 'infile has split by limit 10001 records' do
      before(:each) do
        allow(File).to receive(:open).with(destination_file_name).and_return(big_infile)
        allow(File).to receive(:open).with(next_filename1, File::WRONLY).and_return(split_file1)
        allow(File).to receive(:open).with(next_filename2, File::WRONLY).and_return(split_file2)

        subject.opts = opts.new(destination_file_name, nil)
        subject.make_split
      end

      it 'first file has 10000 records' do
        expect(split_file1.records.size).to eq(10_000)
      end

      it 'second file has 1 record' do
        expect(split_file2.records.size).to eq(1)
      end

      it '@files_to_sort add next_filename1' do
        expect(subject.instance_variable_get(:@files_to_sort)).to include(next_filename1)
      end

      it '@files_to_sort add next_filename2' do
        expect(subject.instance_variable_get(:@files_to_sort)).to include(next_filename2)
      end
    end
  end

  context 'sort_split' do
    let(:next_filename) { "#{destination_file_name}.1" }
    let(:sorted_records) { [*[*[line2] * iteration_count_for_line2], *[*[line1] * iteration_count_for_line]] }

    before(:each) do
      allow(File).to receive(:open).with(input_filename).and_return(infile)
      allow(File).to receive(:open).with(next_filename, File::WRONLY).and_return(outfile)

      subject.opts = opts.new(destination_file_name, nil)
      subject.sort_split(input_filename)
    end

    it 'new file include old file' do
      expect(outfile.records).to include(*infile.records)
    end

    it 'new file is sorted' do
      expect(outfile.records).to eq(sorted_records)
    end

    it '@files_to_merge add filename' do
      expect(subject.instance_variable_get(:@files_to_merge)).to include(next_filename)
    end
  end

  context 'merge_split' do
    before(:each) do
      allow(File).to receive(:open).with(output_filename, File::WRONLY).and_return(outfile)
      allow(File).to receive(:open).with(/#{file_list.split('|')}/) { |file_name| input_file(file_name, 5) }
      allow(File).to receive(:delete).with(/#{file_list.split('|')}/).and_return(nil)

      subject.merge_split(file1, file2, output_filename)
    end

    it 'outfile length equal 10' do
      expect(outfile.records.size).to eq(10)
    end

    it 'outfile is ordered' do
      expect([outfile.records.first, outfile.records.last]).to eq([line2, line1])
    end

    it '@files_to_merge add filename' do
      expect(subject.instance_variable_get(:@files_to_merge)).to include(output_filename)
    end
  end

  context 'get_line' do
    let(:stream) do
      f = file.new([])
      f.puts(line1)
      f
    end
    let(:struct_line) { subject.send(:struct_line, line1) }

    it 'return [nil, nil]' do
      expect(subject.get_line(file.new([]))).to eq([nil, nil])
    end

    it 'return [line, nil]' do
      expect(subject.get_line(stream, false)).to eq([line1, nil])
    end

    it 'return [line, struct]' do
      expect(subject.get_line(stream)).to eq([line1, struct_line])
    end
  end
end