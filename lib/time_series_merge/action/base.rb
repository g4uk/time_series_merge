module TimeSeriesMerge
  module Action
    class Base
      COLUMN_SEPARATOR = ':'.freeze

      attr_accessor :destination_file

      def call!
        raise NotImplementedError.new("You must implement call! method.")
      end

      protected

      def split_line(line)
        Hash[[:date, :x_value].zip line.split( COLUMN_SEPARATOR )]
      end

      def join_split_line(split_line)
        "#{split_line[:date]}#{COLUMN_SEPARATOR}#{split_line[:x_value]}"
      end
    end
  end
end