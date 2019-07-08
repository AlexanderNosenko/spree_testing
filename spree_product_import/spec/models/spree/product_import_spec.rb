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

  describe '#process_data_file' do
    it 'should return true when service succeeds' do
      service_double = double(call: { status: :success })
      allow(Spree::ProductImportService).to receive(:new).and_return(service_double)

      expect(create(:product_import).process_data_file).to eq(true)
    end
  end
end


