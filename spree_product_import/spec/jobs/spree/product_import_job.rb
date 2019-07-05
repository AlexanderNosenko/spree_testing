require 'product_import_job'

describe Spree::ProductImportJob do
  let :product_import {
    product_import_double = double(id: 1)
    allow(product_import_double).to receive(:process_data_file) { sleep 3 }
    product_import_double
  }

  subject { described_class.new(product_import.id) }

  before(:each) do
    allow(ProductImport).to receive(:find).and_return(product_import)
    subject.perform
  end

  describe '#perform' do
    it 'should set status to :processing' do
      expect(product_import).to have_received(:processing!)
    end

    context 'after success' do
      it 'should set status to :complete' do
        allow(product_import).to receive(:process_data_file) { true }

        expect(product_import).to have_received(:completed!)
      end
    end

    context 'after error' do
      it 'should set status to :failed' do
        allow(product_import).to receive(:process_data_file) { false }

        expect(product_import).to have_received(:failed!)
      end
    end
  end
end
