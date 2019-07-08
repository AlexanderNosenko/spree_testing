describe Spree::ProductImportService do
  stub_paperclip(Spree::ProductImportService)
  IMPORT_FILE_ENTRIES_NO = 1

  describe '#call' do

    let(:product_import) { create(:product_import) }
    let(:product_import_file) do
      file = File.open("#{Dir.pwd}/spec/services/spree/product_import_sample.csv")

      {
        file: file,
        valid_entrires_no: 3
      }
    end

    context 'without all valid entries' do
      it 'should create all valid products from data_file' do
        products_no_before = Spree::Product.count

        service = described_class.new(product_import.id, product_import_file[:file])
        service_response = service.call

        expect(service_response[:status]).to eq :success
        expect(Spree::Product.count).to eq products_no_before + product_import_file[:valid_entrires_no]
      end
    end

    context 'with invalid entries' do
      it 'should save errors after processing'
    end
  end
end
