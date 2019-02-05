require "dotenv/load"
require "exchange_rate/exceptions"
require "exchange_rate/configuration"
require "exchange_rate/rate"
require "exchange_rate/store"
require "exchange_rate/providers/base_provider"
require "exchange_rate/providers/euro_central_bank"
require "exchange_rate/sync"

module ExchangeRate
  def self.at(date, currency, counter_currency)
    rate_for(date, counter_currency) / rate_for(date, currency)
  end

  def self.configuration
    @configuration ||= ExchangeRate::Configuration.new
  end

  def self.configure
    @configuration ||= ExchangeRate::Configuration.new
    yield(@configuration)
  end

  private

  def self.rate_for(date, currency)
    configuration.store.get_rate(date, currency).rate
  end
end
