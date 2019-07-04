module Spree
  module Admin
    module ProductImportHelper
      def status_color(product_import)
        case product_import.status
        when :complete
          'green'
        when :failed
          'red'
        else
          'grey'
        end
      end
    end
  end
end
