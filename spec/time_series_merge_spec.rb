require 'spec_helper'

describe TimeSeriesMerge do
  context 'logger' do
    it 'is respond to' do
      should respond_to?(:logger)
    end

    it 'is existing of writer' do
      should respond_to?(:logger=)
    end

    it 'is a Logger instance' do
      expect(TimeSeriesMerge.logger).to be_a_kind_of(Logger)
    end

    it 'custom class instance' do
      class CustomLogger; end
      time_series_merge_clone = TimeSeriesMerge.clone
      time_series_merge_clone.logger = CustomLogger.new
      expect(time_series_merge_clone.logger).to be_a_kind_of(CustomLogger)
    end
  end

  it 'has a version number' do
    expect(subject::VERSION).not_to be nil
  end
end