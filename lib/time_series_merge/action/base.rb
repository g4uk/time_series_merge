module TimeSeriesMerge
  module Action
    class Base
      COLUMN_SEPARATOR = ':'.freeze

      TRUNCATE_SIZE = 0.freeze

      INPUT_FILES_ENCODING = 'ascii'.freeze
      LINE_COUNT_PER_FILE = 10000.freeze

      COL_DATE_NAME = :date.freeze
      COL_X_VALUE_NAME = :x_value.freeze

      # this constant need to keep the file fields/values mutually placed
      FILE_COLS = [COL_DATE_NAME, COL_X_VALUE_NAME]

      attr_writer :opts

      def call
        raise NotImplementedError.new("::call")
      end

      protected

      StructLine = Struct.new(*FILE_COLS) do
        def date_to_timestamp
          DateTime.parse(public_send(COL_DATE_NAME)).to_f
        end

        def x_value_to_int
          public_send(COL_X_VALUE_NAME).to_i
        end

        def to_hash
          Hash[FILE_COLS.zip [public_send(COL_DATE_NAME), public_send(COL_X_VALUE_NAME)]]
        end
      end

      def struct_line(line)
        StructLine.new(*line.split( COLUMN_SEPARATOR ))
      end

      def structed_line

      end

      def destination
        @opts.destination
      end

      def source_files
        @opts.sources
      end
    end
  end
end