RSpec.describe ExchangeRate::Sync do
  subject(:sync) { described_class }

  let(:date) { Date.today }
  let(:rates) do
    [
      { date: date, currency: "USD", rate: 0.101 },
      { date: date, currency: "GBP", rate: 0.123 },
      { date: date, currency: "JPY", rate: 0.999 }
    ]
  end

  describe ".call" do
    context "when rates are available" do
      before do
        allow(ExchangeRate.configuration.provider).to receive(:rates).and_return(rates)
        sync.call
      end

      it "should persist the rates" do
        expect(
          ExchangeRate.configuration.store.get_rate(date, "USD").rate
        ).to be(0.101)

        expect(
          ExchangeRate.configuration.store.get_rate(date, "GBP").rate
        ).to be(0.123)

        expect(
          ExchangeRate.configuration.store.get_rate(date, "JPY").rate
        ).to be(0.999)
      end
    end
  end
end
