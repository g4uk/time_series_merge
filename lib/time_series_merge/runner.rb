module TimeSeriesMerge
  class Runner
    def initialize(opts)
      @opts = Options.new(opts)
      # @todo Add validations of opts
    end

    def run
      Pipe.new(@opts).
        add(Action::Merge.new).
        add(Action::Sort.new).
        add(Action::Group.new).
        run
    end
  end
end