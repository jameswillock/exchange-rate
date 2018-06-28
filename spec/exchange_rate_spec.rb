RSpec.describe ExchangeRate do
  subject(:exchange_rate) { described_class }
  let(:date) { Date.today }
  let(:usd_rate) { ExchangeRate::Rate.new(date: date, currency: "USD", rate: 0.87) }
  let(:gbp_rate) { ExchangeRate::Rate.new(date: date, currency: "GBP", rate: 1.112) }

  describe ".configuration" do
    it "returns a configuration" do
      expect(exchange_rate.configuration).to be_an_instance_of(
        ExchangeRate::Configuration
      )
    end
  end

  describe ".configure" do
    it "yields to a block" do
      expect { |b| exchange_rate.configure(&b) }.to yield_control
    end
  end

  describe ".at" do
    context "when rates have been set" do
      before do
        ExchangeRate.configuration.store.set_rate(usd_rate)
        ExchangeRate.configuration.store.set_rate(gbp_rate)
      end

      it "should return the exchange rate of the two currencies" do
        expect(
          exchange_rate.at(date, usd_rate.currency, gbp_rate.currency)
        ).to be(1.27816091954023)
      end
    end

    context "when rates are missing" do
      it "should raise an exception" do
        expect {
          exchange_rate.at(date, usd_rate.currency, gbp_rate.currency)
        }.to raise_error(ExchangeRate::NoRateError)
      end
    end
  end
end
