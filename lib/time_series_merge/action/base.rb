module TimeSeriesMerge
  module Action
    class Base
      class ActionNotImplementedError < RuntimeError; end

      COLUMN_SEPARATOR = ':'.freeze

      TRUNCATE_SIZE = 0

      INPUT_FILES_ENCODING = 'ascii'.freeze
      LINE_COUNT_PER_FILE = 10_000

      COL_DATE_NAME = :date
      COL_X_VALUE_NAME = :x_value

      # this constant need to keep the file fields/values mutually placed
      FILE_COLS = [COL_DATE_NAME, COL_X_VALUE_NAME].freeze

      attr_writer :opts

      def call
        raise ActionNotImplementedError, 'Call should be implemented'
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
        StructLine.new(*line.split(COLUMN_SEPARATOR))
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