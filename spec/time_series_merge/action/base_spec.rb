require 'spec_helper'

describe TimeSeriesMerge::Action::Base do
  context 'constants' do
    let(:constants) do
      [subject.class::COLUMN_SEPARATOR, subject.class::TRUNCATE_SIZE, subject.class::INPUT_FILES_ENCODING,
       subject.class::LINE_COUNT_PER_FILE, subject.class::COL_DATE_NAME, subject.class::COL_X_VALUE_NAME,
       subject.class::FILE_COLS]
    end

    constants.each do |constant|
      it "has a #{constant}" do
        expect(constant).not_to be nil
      end
    end
  end

  context 'struct_line' do
    let(:line) { '2018-07-06:12' }

    it 'is a Struct instance' do
      expect(subject.send(:struct_line, line)).to be_a_kind_of(Struct)
    end

    context 'exclusive methods' do
      let(:date_to_timestamp) { DateTime.parse(line.split(subject.class::COLUMN_SEPARATOR).first).to_f }
      let(:date) { line.split(subject.class::COLUMN_SEPARATOR).first }
      let(:x_value_to_int) { line.split(subject.class::COLUMN_SEPARATOR).second }
      let(:hash) { { subject.class::COL_DATE_NAME => date, subject.class::COL_X_VALUE_NAME => x_value_to_int } }

      it 'date_to_timestamp is respond to' do
        expect(subject.send(:struct_line, line)).to respond_to(:date_to_timestamp)
      end

      it 'date_to_timestamp return float timestamp' do
        expect(subject.send(:struct_line, line).date_to_timestamp).to eq(date_to_timestamp)
      end

      it 'x_value_to_int is respond to' do
        expect(subject.send(:struct_line, line)).to respond_to(:x_value_to_int)
      end

      it 'x_value_to_int return float timestamp' do
        expect(subject.send(:struct_line, line).x_value_to_int).to eq(x_value_to_int.to_i)
      end

      it 'to_hash is respond to' do
        expect(subject.send(:struct_line, line)).to respond_to(:to_hash)
      end

      it 'to_hash return float timestamp' do
        expect(subject.send(:struct_line, line).to_hash).to eq(hash)
      end
    end

    context 'opts' do
      let(:opts) { Struct.new(:destination, :sources) }
      let(:destination_value) { 'destination' }
      let(:sources_value) { 'sources' }

      it 'destination is correct' do
        subject.opts = opts.new(destination_value, nil)
        expect(subject.send(:destination)).to eq(destination_value)
      end

      it 'sources is correct' do
        subject.opts = opts.new(nil, sources_value)
        expect(subject.send(:source_files)).to eq(sources_value)
      end
    end

    it 'call raise exception' do
      expect{ subject.call }.to raise_error(TimeSeriesMerge::Action::Base::ActionNotImplementedError)
    end
  end
end