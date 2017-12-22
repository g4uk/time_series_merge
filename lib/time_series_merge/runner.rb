module TimeSeriesMerge
  class Runner
    FILE_EXTENSION = 'txt'
    MAX_FILES_COUNT_TO_READ = 100

    def initialize(opts)
      @path = normalize_path(opts[:path])
      @destination_file = opts[:dest].to_s
    end

    def run
      files = Dir.glob( get_full_path ).first( MAX_FILES_COUNT_TO_READ )
      if files.blank?
        puts "Couldn't find any files in #{get_full_path}"
        exit 1
      end

      Pipe.new( @destination_file )
        .add( Action::Merge.new( files ) )
        .add( Action::Sort.new )
        .add( Action::Group.new )
        .call

      exit 0
    end

    private

    def normalize_path(path)
      path.to_s.split('/').compact.join('/')
    end

    def get_full_path
      "#{@path}/*.#{FILE_EXTENSION}"
    end
  end
end