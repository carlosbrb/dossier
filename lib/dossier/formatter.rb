module Dossier
  module Formatter
    extend self
    extend ActiveSupport::Inflector
    extend ActionView::Helpers::NumberHelper

    def number_to_currency_from_cents(value)
      number_to_currency(value /= 100.0)
    end

    def non_localized_number_to_currency(value)
      "$#{non_localized_number_with_delimiter(value, 2)}"
    end

    def non_localized_number_with_delimiter(value, precision = nil)
      whole, fraction = value.to_s.split('.')
      fraction = "%.#{precision}d" % ("0.#{fraction}".to_f.round(precision) * 10**precision).to_i if precision
      [whole.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,"), fraction].compact.join('.')
    end

    def url_formatter
      @url_formatter ||= UrlFormatter.new
    end

    def report_name(report)
      titleize("#{report.report_name.split('/').last} Report")
    end

    delegate :url_for, :link_to, :url_helpers, to: :url_formatter

    class UrlFormatter
      include ActionView::Helpers::UrlHelper

      def _routes
        Rails.application.routes
      end

      # No controller in current context, must be specified when generating routes
      def controller
      end

      def url_helpers
        _routes.url_helpers
      end
    end
  end
end
