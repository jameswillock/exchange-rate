require 'redis'

module ExchangeRate
  class Store
    def initialize(redis_config = {})
      @redis_config = redis_config
    end

    def set_rate(rate)
      if redis.set("#{rate.date}.#{rate.currency}", rate.rate) == "OK"
        true
      else
        raise ExchangeRate::DataStoreError, "Failed to save rate"
      end
    end

    def get_rate(date, currency)
      # Obvious optimisation: this is only ever going to get slower –
      # could be easily sidestepped with SQL, but the list will only 
      # grow by 260 keys a year presently
      date = redis.keys("*.#{currency}").map { |key| Date.parse(key[0..9]) }.sort.last

      raise(
        ExchangeRate::NoRateError, "No rate found for #{currency}"
      ) unless date

      ExchangeRate::Rate.new(
        date: date,
        currency: currency,
        rate: redis.get("#{date}.#{currency}").to_f
      )
    end

    private

    attr_reader :redis_config

    def redis
      @redis ||= Redis.new(redis_config)
    end
  end
end
