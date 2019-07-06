describe Spree::ProductImportService do
  describe '#call' do
    context 'without all valid entries' do
      it 'should create all valid products from data_file'
    end

    context 'with invalid entries' do
      it 'should save errors after processing'
    end
  end
end
