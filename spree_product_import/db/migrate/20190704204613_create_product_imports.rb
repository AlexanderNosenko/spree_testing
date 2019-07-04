class CreateProductImports < SpreeExtension::Migration[5.1]
  def change
    create_table :spree_product_imports do |t|
      t.string :data_file_file_name, null: false
      t.string :data_file_content_type, null: false
      t.integer :data_file_file_size, null: false
      t.datetime :data_file_updated_at, null: false
      t.integer :status, default: 0, null: false, index: true
      t.string :job_id, index: true

      t.timestamps
    end
  end
end
