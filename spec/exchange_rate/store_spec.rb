RSpec.describe ExchangeRate::Store do
  subject(:store) { described_class }

  describe ".redis" do
    it "returns a Mock Redis connection for tests" do
      expect(store.redis).to be_an_instance_of(MockRedis)
    end
  end

  describe ".set_rate" do
    let(:rate) do
      ExchangeRate::Rate.new(date: Date.today, currency: "GBP", rate: 0.1)
    end

    it "returns an OK code" do
      expect(store.set_rate(rate)).to eq("OK")
    end

    it "sets a composite key" do
      store.set_rate(rate)
      key = ExchangeRate::Store.redis.get("#{rate.date}.#{rate.currency}")
      expect(key).to eq(rate.rate.to_s)
    end
  end

  describe ".get_rate" do
    let(:rate) { store.get_rate(Date.today, "GBP") }

    context "when key has been set" do
      before { ExchangeRate::Store.redis.set("#{Date.today}.GBP", "0.1") }
  
      it "marshalls a new Rate" do
        expect(rate).to be_an_instance_of(ExchangeRate::Rate)
      end
  
      it "returns a Rate with the correct date" do
        expect(rate.date).to eq(Date.today)
      end
  
      it "returns a Rate with the correct currency" do
        expect(rate.currency).to eq("GBP")
      end
  
      it "returns a Rate with the correct rate" do
        expect(rate.rate).to eq(0.1)
      end
    end

    context "when key is unset" do
      it "raises an error" do
        expect { store.get_rate(Date.today, "GBP") }.to raise_error(ExchangeRate::NoRateError)
      end
    end
  end
end