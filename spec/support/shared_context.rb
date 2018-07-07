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
    end
  end
end