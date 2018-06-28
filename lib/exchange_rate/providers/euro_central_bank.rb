require "open-uri"
require "rexml/document"

module ExchangeRate
  module Providers
    class EuroCentralBank < BaseProvider
      DOCUMENT_URI = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml".freeze

      def rates(date = nil)
        nodes_for(date).flat_map do |node|
          node.map do |rate|
            if node[:time] && rate[:currency] && rate[:rate]
              rate(node[:time], rate[:currency], rate[:rate])
            else
              raise(ParseError, "Unexpected third party format")
            end
          end
        end
      end

      private

      def rate(date, currency, rate)
        { date: Date.parse(date), currency: currency, rate: rate.to_f }
      end

      def nodes_for(date)
        return dates.children if date.nil?
        elements = dates.elements["Cube[@time='#{date}']"]
        elements ? [elements] : raise(NoRateError, "No rates for #{date} available")
      end

      def dates
        document.elements["gesmes:Envelope/Cube"] || raise(FormatError, "Unexpected third party format")
      end

      def document
        REXML::Document.new(request_body, ignore_whitespace_nodes: :all)
      rescue REXML::ParseException => exception
        raise ParseError, exception.to_s
      end

      def request_body
        open(DOCUMENT_URI).read
      rescue OpenURI::HTTPError => exception
        raise ThirdPartyRequestError, exception.to_s
      end
    end
  end
end
