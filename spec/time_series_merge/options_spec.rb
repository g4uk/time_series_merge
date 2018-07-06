require 'spec_helper'

describe TimeSeriesMerge::Options do
  let(:source) { '/source' }
  let(:destination) { '/destination_file' }
  let(:file_extension) { 'doc' }

  subject { TimeSeriesMerge::Options.new(source: source, destination: destination, file_extension: file_extension) }

  it 'source should return source' do
    expect(subject.source).to eq(source)
  end

  it 'destination should return destination' do
    expect(subject.destination).to eq(destination)
  end

  it 'file_extension should return file_extension' do
    expect(subject.send(:extension)).to eq(file_extension)
  end

  it 'sources should return source with extension mask' do
    expect(subject.sources).to eq("#{source}/*.#{file_extension}")
  end
end