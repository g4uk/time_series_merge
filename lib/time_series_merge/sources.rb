module TimeSeriesMerge
  class Sources
    MAX_FILES_COUNT_TO_READ = 100

    def initialize(sources)
      @sources = sources
    end

    def list
      Dir.glob( @sources ).first( MAX_FILES_COUNT_TO_READ )
    end
  end
end