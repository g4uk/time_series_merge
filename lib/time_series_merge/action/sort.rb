module TimeSeriesMerge
  module Action
    class Sort < Base
      LINE_COUNT_PER_FILE = 10000.freeze

      def initialize
        @files_to_sort = []
        @files_to_merge = []
        @file_counter = 0
      end

      def call!
        make_splits

        while true
          break if @files_to_sort.empty? and @files_to_merge.size == 1
          unless @files_to_sort.empty?
            sort_split( @files_to_sort.shift )
            next
          end
          unless @files_to_merge.size < 2
            merge_splits( @files_to_merge.shift, @files_to_merge.shift, next_filename )
            next
          end
          sleep
        end

        final_name = "#{destination_file}.sorted"

        File.rename( @files_to_merge.first, final_name )
        File.delete( destination_file )
        File.rename( final_name, destination_file )

        nil
      end

      def next_filename
        return "#{destination_file}.#{(@file_counter += 1)}"
      end

      def make_splits
        line_counter = 0
        infile = File.open( destination_file )
        output_filename = next_filename
        outfile = File.open( output_filename, "w" )

        while (line = infile.gets)
          if line_counter >= LINE_COUNT_PER_FILE
            outfile.close
            @files_to_sort << output_filename
            output_filename = next_filename
            outfile = File.open( output_filename, "w" )
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
        sort_file_data!( filename, sorted_filename )
        @files_to_merge << sorted_filename
      end

      def merge_splits(filename_a, filename_b, output_filename)
        merge!(filename_a, filename_b, output_filename)
        File.delete( filename_a )
        File.delete( filename_b )
        @files_to_merge << output_filename
      end

      def aggregate_file_data!(input_filename, sorted_filename)
        lines = []
        infile = File.open( input_filename )

        while (line = infile.gets)
          col_date = split_line( line )[:date]
          col_x_value = split_line( line )[:x_value].to_i
          lines << Hash[[:date, :x_value].zip [col_date, col_x_value]]
        end

        infile.close
        lines = lines.each_with_object(Hash.new(0)) { |x, hash| hash[x[:date]] += x[:x_value] }

        outfile = File.open( sorted_filename, "w" )
        lines.each{ |line_item| outfile.puts line_item.join(COLUMN_SEPARATOR) }

        outfile.close
      end

      def sort_file_data!(input_filename, sorted_filename)
        lines = []
        infile = File.open( input_filename )

        while (line = infile.gets)
          col = split_line( line )[:date]
          lines << Hash[[:sort_column_value, :line].zip [col, line]]
        end

        infile.close
        lines.sort!{ |a, b| DateTime.parse( a[:sort_column_value] ).to_f <=> DateTime.parse( b[:sort_column_value] ).to_f }

        outfile = File.open( sorted_filename, "w" )
        lines.each{ |line_item| outfile.print line_item[:line] }

        outfile.close
      end

      def merge!(filename_a, filename_b, output_filename)
        outfile = File.open( output_filename, "w" )

        file_a = File.open( filename_a )
        file_b = File.open( filename_b )

        file_a_line, file_a_col = get_line( file_a )
        file_b_line, file_b_col = get_line( file_b )

        while !file_a_line.nil? and !file_b_line.nil?
          if DateTime.parse(file_a_col).to_f < DateTime.parse(file_b_col).to_f
            outfile.print file_a_line
            file_a_line, file_a_col = get_line( file_a )
          else
            outfile.print file_b_line
            file_b_line, file_b_col = get_line( file_b )
          end
        end

        while file_a_line.present?
          outfile.print file_a_line
          file_a_line, file_a_col = get_line( file_a, false )
        end

        while file_b_line.present?
          outfile.print file_b_line
          file_b_line, file_b_col = get_line( file_b, false )
        end

        file_a.close
        file_b.close

        outfile.close
      end

      def get_line(stream, parse_cols = true)
        line = stream.gets

        return [nil, nil] if line.nil?
        return [line, nil] unless parse_cols

        cols = split_line( line.chomp )

        return [line, cols[:date]]
      end
    end
  end
end