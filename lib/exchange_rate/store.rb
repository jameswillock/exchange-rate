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
      rate_on_date = redis.get("#{date}.#{currency}")

      if rate_on_date
        rate(date, currency, rate_on_date.to_f)
      else
        # Obvious optimisation: this is only ever going to get slower –
        # could be easily sidestepped with SQL, but the list will only 
        # grow by 260 keys a year presently
        dates = redis.keys("*.#{currency}").map { |key| Date.parse(key[0..9]) }.sort

        # Raise if provided date is earlier than any record, or there are none
        if (dates.first && dates.first > date) || dates.empty?
          raise(ExchangeRate::NoRateError, "No rate found for #{currency}")
        else
          recent = redis.get("#{dates.last}.#{currency}")
          rate(dates.last, currency, recent.to_f)
        end
      end
    end

    private

    attr_reader :redis_config
    
    def rate(date, currency, rate)
      ExchangeRate::Rate.new(date: date, currency: currency, rate: rate)
    end

    def redis
      @redis ||= Redis.new(redis_config)
    end
  end
end
