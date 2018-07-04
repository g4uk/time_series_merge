module TimeSeriesMerge
  module PathUtils
    SPLIT_PATTERN = '/'.freeze

    def normalize(path)
      path.to_s.split(SPLIT_PATTERN).compact.join(SPLIT_PATTERN)
    end

    def full_path(path)
      "#{path}#{SPLIT_PATTERN}*.#{extension}"
    end

    def extension
      raise NotImplementedError.new("::extension")
    end
  end
end