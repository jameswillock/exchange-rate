module ExchangeRate
  module Store
    def self.redis
      ExchangeRate.configuration.redis
    end

    def self.provider
      ExchangeRate.configuration.provider
    end

    def self.set_from_provider(date = nil)
      provider.rates(date).map do |provider_rate|
        ExchangeRate::Rate.new(
          date: provider_rate[:date],
          currency: provider_rate[:currency],
          rate: provider_rate[:rate]
        ).tap { |rate| set_rate(rate) }
      end
    end

    def self.set_rate(rate)
      redis.set("#{rate.date}.#{rate.currency}", rate.rate)
    end

    def self.get_rate(date, currency)
      rate = redis.get("#{date}.#{currency}") 
      
      raise ExchangeRate::NoRateError, "No rate found for #{currency} at #{date}" unless rate

      Rate.new(date: date, currency: currency, rate: rate.to_f)
    end
  end
end
