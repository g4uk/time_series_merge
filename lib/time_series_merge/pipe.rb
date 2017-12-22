module TimeSeriesMerge
  class Pipe
    def initialize(destination_file)
      @destination_file = destination_file
      @actions = []
    end

    def add(action)
      action.destination_file = @destination_file
      @actions << action
      self
    end

    def call
      @actions.map { |action| action.call! }
    end
  end
end