module TimeSeriesMerge
  module PathUtils
    class PathUtilsNotImplementedError < RuntimeError; end

    SPLIT_PATTERN = '/'.freeze
    DEFAULT_FILE_EXTENSION = 'txt'.freeze

    def normalize(path)
      path.to_s.split(SPLIT_PATTERN).compact.join(SPLIT_PATTERN)
    end

    def full_path(path)
      "#{path}#{SPLIT_PATTERN}*.#{extension || DEFAULT_FILE_EXTENSION}"
    end

    def extension
      raise PathUtilsNotImplementedError, 'Extension should be implemented'
    end
  end
end