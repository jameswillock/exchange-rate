require "simplecov"

# $LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "webmock/rspec"
require "exchange_rate"
require "mock_redis"

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.before do
    ExchangeRate.configure do |config|
      config.redis = MockRedis.new
    end
  end
end
