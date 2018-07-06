require 'time_series'

module TimeSeriesMerge
  @logger = nil

  class << self
    attr_writer :logger

    def logger
      def self.logger
        @logger
      end
      @logger = ::Logger.new(STDOUT)
    end

    def load_tasks
      load 'tasks/time_series.rake'
    end
  end
end