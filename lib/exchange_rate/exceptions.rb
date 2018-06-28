module ExchangeRate
  class ThirdPartyRequestError < StandardError; end
  class ParseError < StandardError; end
  class FormatError < StandardError; end
  class NoRateError < StandardError; end
  class DataStoreError < StandardError; end
end
