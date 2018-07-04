module TimeSeriesMerge
  class Runner
    def initialize(opts)
      @opts = Options.new(opts)
      # @todo Add validations of opts
    end

    def run
      pipe = Pipe.new(@opts)
      pipe.add(Action::Merge.new)
      pipe.add(Action::Sort.new)
      pipe.add(Action::Group.new)
      pipe.run
    end
  end
end