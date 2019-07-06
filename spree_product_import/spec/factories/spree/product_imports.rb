FactoryGirl.define do
  factory :product_import, class: Spree::ProductImport do
    data_file_file_name { 'file.csv' }
    data_file_content_type { 'text/csv' }
    data_file_file_size { 10000 }
    data_file_updated_at { 0.days.ago }
  end
end


