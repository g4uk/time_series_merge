module TimeSeriesMerge
  module Action
    class Merge < Base
      INPUT_FILES_ENCODING = 'ascii'.freeze

      def initialize(files)
        @files = files
      end

      def call!
        File.truncate( destination_file, 0 ) if File.exist?( destination_file )
        File.open( destination_file, 'a' ) do |d|
          @files.each do |f|
            File.open(f, "r:#{INPUT_FILES_ENCODING}") do |file|
              file.each { |line| d.puts(line) }
            end
          end
        end

        nil
      end
    end
  end
end