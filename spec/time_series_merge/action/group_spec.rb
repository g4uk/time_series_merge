require 'spec_helper'

describe TimeSeriesMerge::Action::Group do
  include_context 'shared context'

  let(:line_date) { '2018-07-06' }
  let(:line_count) { 12 }
  let(:line2_date) { '2018-07-03' }
  let(:line2_count) { 1 }

  let(:line) { "#{line_date}:#{line_count}" }
  let(:line2) { "#{line2_date}:#{line2_count}" }

  it 'inherited from Base' do
    expect(subject).to be_a_kind_of(TimeSeriesMerge::Action::Base)
  end

  it 'has a grouped file extension' do
    expect(subject.class::GROUPED_FILE_EXTENSION).not_to be nil
  end

  context 'line' do
    let(:date) { line.split(subject.class::COLUMN_SEPARATOR).first }
    let(:x_value) { line.split(subject.class::COLUMN_SEPARATOR).second }
    let(:hash) { { subject.class::COL_DATE_NAME => date, subject.class::COL_X_VALUE_NAME => x_value } }

    it 'join to line' do
      expect(subject.send(:join_to_line, hash)).to eq(line)
    end
  end

  context 'run' do
    let(:input_file_name) { 'input_file_name' }
    let(:grouped_file_name) { "#{input_file_name}.grouped" }

    let(:grouped_file) { file.new([]) }
    let(:iteration_count_for_line) { 10 }
    let(:iteration_count_for_line2) { 5 }

    let(:input_file) do
      f = file.new([])

      iteration_count_for_line.times { f.puts(line) }
      iteration_count_for_line2.times { f.puts(line2) }

      f
    end

    before(:each) do
      allow(File).to receive(:open) { |input, &block| input_file.push_records_to_block(&block) }
      allow(File).to receive(:open).with(grouped_file_name, File::APPEND).and_return(grouped_file)
      allow(File).to receive(:delete).with(input_file_name).and_return(nil)
      allow(File).to receive(:rename).with(grouped_file_name, input_file_name).and_return(nil)

      subject.opts = opts.new(input_file_name, nil)
    end

    it 'return nil' do
      expect(subject.run).to eq(nil)
    end

    it 'group records count equal 2' do
      subject.run
      expect(grouped_file.records.size).to eq(2)
    end

    it 'group records are including correct sum for line' do
      subject.run
      expect(grouped_file.records).to include("#{line_date}:#{line_count * iteration_count_for_line}")
    end

    it 'group records are including correct sum for line2' do
      subject.run
      expect(grouped_file.records).to include("#{line2_date}:#{line2_count * iteration_count_for_line2}")
    end
  end
end