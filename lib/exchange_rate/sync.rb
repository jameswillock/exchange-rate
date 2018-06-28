module ExchangeRate
  module Sync
    def self.call(date = nil)
      !!rates(date).map { |rate| store.set_rate(rate) }
    end

    private

    def self.store
      ExchangeRate.configuration.store
    end

    def self.provider
      ExchangeRate.configuration.provider
    end

    def self.rates(date)
      provider.rates(date).map { |rate| ExchangeRate::Rate.new(rate) }
    end
  end
end
