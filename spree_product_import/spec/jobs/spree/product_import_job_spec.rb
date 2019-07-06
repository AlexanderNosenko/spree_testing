describe Spree::ProductImportJob do
  let(:product_import) {
    instance_double(
      'Spree::ProductImport',
      id: 1, processing!: true,
      complete!: true,
      failed!: true,
      process_data_file: nil
    )
  }

  before(:each) do
    allow(Spree::ProductImport).to receive(:find).and_return(product_import)
  end

  describe '#perform' do
    it 'should set status to :processing' do
      subject.perform(product_import.id)
      expect(product_import).to have_received(:processing!)
    end

    context 'after success' do
      it 'should set status to :complete' do
        allow(product_import).to receive(:process_data_file).and_return(true)
        subject.perform(product_import.id)

        expect(product_import).to have_received(:complete!)
      end
    end

    context 'after error' do
      it 'should set status to :failed' do
        allow(product_import).to receive(:process_data_file).and_return(false)

        subject.perform(product_import.id)
        expect(product_import).to have_received(:failed!)
      end
    end
  end
end
