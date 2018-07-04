module TimeSeriesMerge
  class Options
    include PathUtils

    DEFAULT_FILE_EXTENSION = 'txt'.freeze

    attr_writer :source, :destination, :file_extension

    def initialize(opts)
      opts.map {|name, value| self.public_send("#{name}=", value) }
    end

    # path to source files folder
    def source
      normalize(@source)
    end

    # full path to source files
    def sources
      full_path(normalize(@source))
    end

    # path to destination file
    def destination
      @destination.to_s
    end

    private

    def extension
      @file_extension || DEFAULT_FILE_EXTENSION
    end
  end
end