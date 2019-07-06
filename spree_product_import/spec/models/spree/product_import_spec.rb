describe Spree::ProductImport do
  stub_paperclip(Spree::ProductImport)

  describe '#create' do

    before(:each) do
      allow(Spree::ProductImportJob).to receive(:perform_later).and_return('job_id')
    end

    it 'should create a record with :uploaded status' do
      product_import = described_class.create

      expect(product_import.status).to eq('uploaded')
    end

    it 'should start processing after create' do
      product_import = described_class.create(attributes_for(:product_import))

      expect(Spree::ProductImportJob).to have_received(:perform_later).with(product_import.id)
    end
  end
end


