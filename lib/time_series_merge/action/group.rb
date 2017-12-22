module TimeSeriesMerge
  module Action
    class Group < Base
      def initialize
        @to_insert_value = { date: nil, x_value: 0 }
      end
      
      def call!
        grouped_file_name = "#{destination_file}.grouped"
        grouped_file = File.open( grouped_file_name, "a" )

        File.open(destination_file) do |d|
          d.each do |line|
            split_line = split_line(line)
            if @to_insert_value[:date].nil?
              @to_insert_value = split_line
              next
            end

            if DateTime.parse( split_line[:date] ).to_f == DateTime.parse( @to_insert_value[:date] ).to_f
              @to_insert_value[:x_value] = @to_insert_value[:x_value].to_i + split_line[:x_value].to_i
            else
              grouped_file.puts( join_split_line( @to_insert_value ) )
              @to_insert_value = split_line
            end
          end
        end

        grouped_file.puts( join_split_line( @to_insert_value ) )

        File.delete( destination_file )
        File.rename( grouped_file_name, destination_file )

        nil
      end
    end
  end
end