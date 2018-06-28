require "simplecov"
require "webmock/rspec"
require "mock_redis"
require "pry"
require "exchange_rate"

# Ensure we don't call out to third parties
WebMock.disable_net_connect!

RSpec.configure do |config|
  mock_redis = MockRedis.new

  config.before do
    # ExchangeRate.configure do |config|
    #   No need to configure here
    # end

    # Ensure we don't use local Redis instance in test
    allow_any_instance_of(
      ExchangeRate::Store
    ).to receive(:redis).and_return(mock_redis)
  end

  # Flush Redis around each
  config.after(:each) { mock_redis.flushdb }
end
