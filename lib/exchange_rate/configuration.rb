require "redis"

module ExchangeRate
  class Configuration
    attr_accessor :redis_host, :redis_port, :redis_db
    attr_writer :redis
    attr_reader :providers

    def initialize
      @providers = { ecb: ExchangeRate::Providers::EuroCentralBank }
    end

    def register_provider(sym, klass)
      @providers.merge!("#{sym}".to_sym => klass)
    end

    def provider
      @provider ||= providers[:ecb].new
    end

    def provider=(sym)
      @provider = @providers[sym].new
    end

    def redis
      @redis ||= Redis.new(redis_configuration)
    end

    def redis_configuration
      { host: redis_host, port: redis_port, db: redis_db }.compact
    end
  end
end
