require "open-uri"
require "rexml/document"

module ExchangeRate
  module Providers
    class EuroCentralBank < BaseProvider
      DOCUMENT_URI = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml".freeze

      def rates(date = nil)
        if date
          dates.elements["Cube[@time='#{date}']"].map do |rate|
            raise FormatError, "Unexpected third party format" unless rate["currency"] && rate["rate"]
            rate(date, rate["currency"], rate["rate"].to_f)
          end
        else
          dates.elements.flat_map do |date|
            date.elements.map do |rate|
              raise FormatError, "Unexpected third party format" unless rate["currency"] && rate["rate"] && date["time"]
              rate(Date.parse(date["time"]), rate["currency"], rate["rate"].to_f)
            end
          end
        end
      end

      private

      def rate(date, currency, rate)
        { date: date, currency: currency, rate: rate }
      end

      def dates
        @dates ||= document.elements["gesmes:Envelope/Cube"] || raise(FormatError, "Unexpected third party format")
      end

      def document
        @document ||= REXML::Document.new(request_body, ignore_whitespace_nodes: :all)
      rescue REXML::ParseException => exception
        raise ParseError, exception.to_s
      end

      def request_body
        @request_body ||= open(DOCUMENT_URI).read
      rescue OpenURI::HTTPError => exception
        raise ThirdPartyRequestError, exception.to_s
      end
    end
  end
end
