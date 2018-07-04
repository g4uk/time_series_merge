module TimeSeriesMerge
  class Pipe
    def initialize(opts)
      @actions = []
      @opts = opts
    end

    def add(action)
      action.opts = @opts
      @actions << action
      self
    end

    def run
      @actions.map do |action|
        TimeSeriesMerge.logger.info("Starting #{action}")
        action.run
      end
    end
  end
end