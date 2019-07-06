module Spree
  class ProductImportJob < ActiveJob::Base
    def perform(product_import_id)
      product_import = ProductImport.find(product_import_id)
      product_import.processing!

      if product_import.process_data_file
        product_import.complete!
      else
        product_import.failed!
      end
    end
  end
end
