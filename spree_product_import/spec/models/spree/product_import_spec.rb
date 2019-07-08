describe Spree::ProductImport do
  stub_paperclip(Spree::ProductImport)

  before(:each) do
    allow(Spree::ProductImportJob).to receive(:perform_later).and_return('job_id')
  end

  describe '#create' do
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
      service_class_double = class_double('Spree::ProductImportService')
                               .as_stubbed_const(transfer_nested_constants: true)
      service_double = double(call: { status: :success })
      allow(service_class_double).to receive(:new).and_return(service_double)

      file_double = double
      allow_any_instance_of(Spree::ProductImport).to receive(:local_data_file).and_return(file_double)
      product_import = create(:product_import)

      result = product_import.process_data_file

      expect(result).to eq(true)
      expect(service_class_double).to have_received(:new).with(product_import, file_double, instance_of(Hash))
      expect(service_double).to have_received(:call)
    end
  end
end


