module TimeSeriesMerge
  module Action
    class Group < Base
      GROUPED_FILE_EXTENSION = 'grouped'.freeze

      def initialize
        @to_insert_value = Hash[FILE_COLS.zip [nil, 0]]
      end

      # this group method is working correctly only after sorting!
      def run
        grouped_file_name = "#{destination}.#{GROUPED_FILE_EXTENSION}"
        grouped_file = File.open(grouped_file_name, File::APPEND)

        File.open(destination) do |destination|
          destination.each do |line|
            structed_line = struct_line(line)

            if @to_insert_value[COL_DATE_NAME].nil?
              @to_insert_value = structed_line.to_hash
              next
            end

            if structed_line.date_to_timestamp == DateTime.parse(@to_insert_value[COL_DATE_NAME]).to_f
              @to_insert_value[COL_X_VALUE_NAME] = @to_insert_value[COL_X_VALUE_NAME].to_i + structed_line.x_value_to_int
            else
              grouped_file.puts(join_to_line( @to_insert_value))
              @to_insert_value = structed_line.to_hash
            end
          end
        end

        # puts last part of grouped records
        grouped_file.puts(join_to_line(@to_insert_value))

        File.delete(destination)
        File.rename(grouped_file_name, destination)

        nil
      end

      private

      def join_to_line(split_line)
        "#{split_line[COL_DATE_NAME]}#{COLUMN_SEPARATOR}#{split_line[COL_X_VALUE_NAME]}"
      end
    end
  end
end