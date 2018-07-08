RSpec.shared_context 'shared context', shared_context: :metadata do
  let(:file) do
    Struct.new(:records) do
      def puts(record)
        records << record
      end

      def push_records_to_block
        return unless block_given?
        yield records
      end

      def push_self_to_block
        return unless block_given?
        yield self
      end

      def gets
        records.shift
      end

      def close
        nil
      end

      alias_method :print, :puts
    end
  end

  let(:line1_date) { '2018-07-06' }
  let(:line1_count) { 12 }
  let(:line2_date) { '2018-07-03' }
  let(:line2_count) { 1 }

  let(:file1) { 'file1' }
  let(:file2) { 'file2' }

  let(:file_list) { [file1, file2] }

  let(:line1) { "#{line1_date}:#{line1_count}" }
  let(:line2) { "#{line2_date}:#{line2_count}" }

  let(:file_lines) { { file1 => line1, file2 => line2 } }

  let(:opts) { Struct.new(:destination, :sources) }

  def input_file(name, iteration_count = 1)
    f = file.new([])
    iteration_count.times{ f.puts(file_lines[name]) }
    f
  end
end