require 'csv'

module Spree
  class ProductImportService
    attr_reader :product_import_id, :file, :config
    attr_accessor :errors

    def initialize(product_import_id, file, config = {})
      @product_import_id = product_import_id
      @file = file
      @config = config
    end

    def call
      @product_import = ProductImport.find(product_import_id)

      products = create_products!

      { status: :success, products: products }
    rescue ImportError => e
      { status: :failed, errors: [e.message] }
    end

    def create_products!
      data_rows.map(&method(:create_product))
    rescue StandardError => e # TODO: specify error types
      raise ImportError.new(e)
    end

    def data_rows
      # TODO: prepare handling without headers
      if config[:headers]
        CSV.read(file, config)
      else
        # TODO: handle input mapping without headers
        # {link to jira task}
        # field_labels = rows[0]
        # data_rows = rows[1..-1]
        # label_input(product_info)
        []
      end
    end

    def create_product(values)
      return unless valid_row?(values)

      ActiveRecord::Base.transaction do
        shipping_category = Spree::ShippingCategory.find_or_create_by(
          name: values['category']
        )

        product_params = {
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

        product = Spree::Product.create(product_params)
        # create_taxonomies_for(product)
        product
      end
    end

    def create_taxonomies_for(product)
      category_taxonomy = Spree::Taxonomy.find_or_create_by(name: 'Categories')
      category_taxon = Spree::Taxon.find_or_create_by(
        taxonomy_id: category_taxonomy.id,
        name: values['category']
      )

      product.taxons << category_taxon

      product.variants << variant
      product.save
    end

    def valid_row?(values)
      required_fields = ['name', 'price', 'category']

      required_fields.all? { |field_name| values[field_name].present? }
    end

    class ImportError < StandardError; end
  end
end
