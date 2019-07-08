module Spree
  class ProductImport < Base
    attr_accessor :ship_processing

    include Paperclip::Glue

    has_attached_file :data_file
    validates_attachment :data_file, presence: true, content_type: { content_type: ["text/plain", "text/csv"] }

    validates :status, presence: true

    enum status: {
      uploaded: 0,
      processing: 1,
      complete: 2,
      failed: 3,
    }

    after_commit :start_processing, on: :create, unless: -> { ship_processing }
    def start_processing
      job_id = Spree::ProductImportJob.perform_later(id)
      update(job_id: job_id)
    end

    def process_data_file
      service = Spree::ProductImportService.new(self)
      service_result = service.call

      service_result[:status] == :success
    end

  end
end
