module TimeSeriesMerge
  module Action
    class Sort < Base
      SORTED_FILE_EXTENSION = 'sorted'.freeze

      def initialize
        @files_to_sort = []
        @files_to_merge = []
        @file_counter = 0
      end

      def call
        make_splits

        while true
          break if @files_to_sort.empty? && @files_to_merge.size == 1
          unless @files_to_sort.empty?
            sort_split(@files_to_sort.shift)
            next
          end
          unless @files_to_merge.size < 2
            merge_splits(@files_to_merge.shift, @files_to_merge.shift, next_filename)
            next
          end
          sleep
        end

        final_name = "#{destination}.#{SORTED_FILE_EXTENSION}"

        File.rename(@files_to_merge.first, final_name)
        File.delete(destination)
        File.rename(final_name, destination)

        nil
      end

      def next_filename
        return "#{destination}.#{(@file_counter += 1)}"
      end

      def make_splits
        line_counter = 0
        output_filename = next_filename

        infile = File.open( destination )
        outfile = File.open(output_filename, File::WRONLY)

        while (line = infile.gets)
          if line_counter >= LINE_COUNT_PER_FILE
            outfile.close
            @files_to_sort << output_filename
            output_filename = next_filename
            outfile = File.open(output_filename, File::WRONLY)
            line_counter = 0
          end
          outfile.print( line )
          line_counter += 1
        end

        infile.close
        outfile.close

        @files_to_sort << output_filename
      end

      def sort_split(filename)
        sorted_filename = next_filename
        sort_file_data!(filename, sorted_filename)
        @files_to_merge << sorted_filename
      end

      def merge_splits(filename_a, filename_b, output_filename)
        merge!(filename_a, filename_b, output_filename)
        @files_to_merge << output_filename

        File.delete(filename_a)
        File.delete(filename_b)
      end

      def sort_file_data!(input_filename, sorted_filename)
        lines = []
        infile = File.open( input_filename )

        while (line = infile.gets)
          lines << Hash[[:sort_column_value, :line].zip [struct_line(line).date_to_timestamp, line]]
        end

        infile.close
        lines.sort!{ |a, b| a[:sort_column_value] <=> b[:sort_column_value] }

        outfile = File.open(sorted_filename, File::WRONLY)
        lines.each{ |line_item| outfile.print line_item[:line] }

        outfile.close
      end

      def merge!(filename_a, filename_b, output_filename)
        outfile = File.open(output_filename, File::WRONLY)

        file_a = File.open(filename_a)
        file_b = File.open(filename_b)

        file_a_line, file_a_cols = get_line(file_a)
        file_b_line, file_b_cols = get_line(file_b)

        while !file_a_line.nil? && !file_b_line.nil?
          if file_a_cols.date_to_timestamp < file_b_cols.date_to_timestamp
            outfile.print file_a_line
            file_a_line, file_a_cols = get_line(file_a)
          else
            outfile.print file_b_line
            file_b_line, file_b_cols = get_line(file_b)
          end
        end

        while file_a_line.present?
          outfile.print file_a_line
          file_a_line, file_a_cols = get_line(file_a, false)
        end

        while file_b_line.present?
          outfile.print file_b_line
          file_b_line, file_b_cols = get_line(file_b, false)
        end

        file_a.close
        file_b.close

        outfile.close
      end

      def get_line(stream, parse_cols = true)
        line = stream.gets

        return [nil, nil] if line.nil?
        return [line, nil] unless parse_cols

        [line, struct_line(line.chomp)]
      end
    end
  end
end