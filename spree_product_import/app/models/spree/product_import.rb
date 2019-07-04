module Spree
  class ProductImport < Base
    has_attached_file :data_file
    validates_attachment :data_file, presence: true, content_type: { content_type: ["text/plain", "text/csv"] }

    validates :status, presence: true

    enum status: {
      uploaded: 0,
      processing: 1,
      complete: 2,
      failed: 3,
    }

    after_commit :start_processing, on: :create

    def start_processing

    end
  end
end
