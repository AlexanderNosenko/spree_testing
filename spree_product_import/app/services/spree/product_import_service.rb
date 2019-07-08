require 'csv'

module Spree
  class ProductImportService
    attr_reader :product_import_id, :file

    def initialize(product_import_id, file)
      @product_import_id = product_import_id
      @file = file
    end

    def call
      @product_import = ProductImport.find(product_import_id)

      # TODO: extract
      rows = CSV.read(file, col_sep: ';', headers: true)

      # TODO prepare handling withoout headers
      # field_labels = rows[0]
      # data_rows = rows[1..-1]

      products = rows.map(&method(:create_product))
      byebug
      { status: :success, products: products }
    end

    def create_product(product_info)
      values = if product_info.is_a? CSV::Row
                 product_info
               else
                 # TODO: make input mapping method
                 label_input(product_info)
               end
      return unless valid_row?(values)

      ActiveRecord::Base.transaction do
        # category_taxonomy = Spree::Taxonomy.find_or_create_by(name: 'Categories')
        # category_taxon = Spree::Taxon.find_or_create_by(
        #   taxonomy_id: category_taxonomy.id,
        #   name: values['category'],
        #   )

        shipping_category = Spree::ShippingCategory.find_or_create_by(name: values['category'])

        params = {
          name: values['name'],
          description: values['description'],
          available_on: values['availability_date'],
          slug: values['slug'],
          meta_title: '',
          meta_description: '',
          meta_keywords: '',
          price: values['price'],
          # tax_category_id: ''
          shipping_category_id: shipping_category.id,
        }

        product = Spree::Product.create(params)

        # product.taxons << category_taxon

        # variant = Spree::Variant.create(
        #   cost_price: values['price'],
        #   is_master: true
        # )

        # Spree::StockItem.create(
        #   variant_id: variant.id,
        #   count_on_hand: values['stock_total']
        # )

        # product.variants << variant
        product.save

        product
      end
    end

    def valid_row?(values)
      values['name'].present? && values['price'].present?
    end
  end
end
