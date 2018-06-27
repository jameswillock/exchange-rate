require "exchange_rate/exceptions"
require "exchange_rate/configuration"
require "exchange_rate/rate"
require "exchange_rate/store"
require "exchange_rate/providers/base_provider"
require "exchange_rate/providers/euro_central_bank"

module ExchangeRate
  def self.at(date, currency, counter_currency)
    ExchangeRate::Store.get_rate(date, counter_currency).rate / ExchangeRate::Store.get_rate(date, currency).rate
  end

  def self.configuration
    @configuration
  end

  def self.configure
    @configuration ||= ExchangeRate::Configuration.new
    yield(@configuration)
  end
end
