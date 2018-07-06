module TimeSeriesMerge
  module Action
    class Merge < Base
      def run
        File.truncate(destination, TRUNCATE_SIZE) if File.exist?(destination)
        File.open(destination, File::APPEND) do |destination|
          files.each do |f|
            File.open(f, "#{File::RDONLY}:#{INPUT_FILES_ENCODING}") do |file|
              file.each { |line| destination.puts(line) }
            end
          end
        end
      end

      private

      def files
        TimeSeriesMerge::Source.new(source_files).list
      end
    end
  end
end