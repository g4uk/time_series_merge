require 'spec_helper'

describe TimeSeriesMerge::Source do
  let(:file_list) { %w[file1 file2] }
  let(:path) { '/' }
  subject { TimeSeriesMerge::Source.new(path) }

  it 'has a read file limit' do
    expect(subject.class::MAX_FILES_COUNT_TO_READ).not_to be nil
  end

  it 'should return a list of files within the specified directory' do
    allow(Dir).to receive(:glob).with(path).and_return(file_list)
    expect(subject.list).to eq(file_list)
  end
end