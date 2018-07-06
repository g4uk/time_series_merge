require 'spec_helper'

describe TimeSeriesMerge::Action::Group do
  it 'inherited from Base' do
    expect(subject).to be_a_kind_of(TimeSeriesMerge::Action::Base)
  end

  it 'has a grouped file extension' do
    expect(subject.class::GROUPED_FILE_EXTENSION).not_to be nil
  end
end