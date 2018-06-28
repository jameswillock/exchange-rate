module ExchangeRate
  class Configuration
    attr_accessor :redis_host, :redis_port, :redis_db
    attr_reader :providers

    def initialize
      @providers = { ecb: ExchangeRate::Providers::EuroCentralBank }
    end

    def register_provider(sym, klass)
      @providers[sym] = klass
    end

    def provider
      @provider ||= providers[:ecb].new
    end

    def provider=(sym)
      @provider = @providers[sym].new
    end

    def redis_config
      { host: redis_host, port: redis_port, db: redis_db }.compact
    end

    def store
      @store ||= ExchangeRate::Store.new(redis_config)
    end
  end
end
