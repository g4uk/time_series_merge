require 'spec_helper'

describe TimeSeriesMerge::Pipe do
  let(:opts) { TimeSeriesMerge::Options.new({}) }
  let(:action) do
    Struct.new(:opts) do
      def run
        opts
      end
    end
  end
  subject { TimeSeriesMerge::Pipe.new(opts) }

  it 'run is running added action' do
    allow(TimeSeriesMerge.logger).to receive(:info).and_return(nil)

    subject.add(action.new)
    expect(subject.run.first).to be_a_kind_of(TimeSeriesMerge::Options)
  end
end