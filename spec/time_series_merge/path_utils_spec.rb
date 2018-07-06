require 'spec_helper'

describe TimeSeriesMerge::PathUtils do
  subject { class Test; include TimeSeriesMerge::PathUtils; end; Test.new }
  let(:path) { '/test/test' }

  context 'constants' do
    it 'has a default split pattern' do
      expect(subject.class::SPLIT_PATTERN).not_to be nil
    end

    it 'has a default file extension' do
      expect(subject.class::DEFAULT_FILE_EXTENSION).not_to be nil
    end
  end

  it 'normalize is remove last split pattern' do
    expect(subject.normalize("#{path}/")).to eq(path)
  end

  it 'full_path should raise exception' do
    expect { subject.full_path("#{path}/") }.to raise_error(TimeSeriesMerge::PathUtils::PathUtilsNotImplementedError)
  end

  it 'extension raise error' do
    expect{ subject.extension }.to raise_error(TimeSeriesMerge::PathUtils::PathUtilsNotImplementedError)
  end

  it 'full_path should return mask to get .csv files' do
    subject.instance_eval do
      def extension
        'csv'
      end
    end

    expect(subject.full_path("#{path}")).to eq("#{path}/*.csv")
  end
end