RSpec.describe ExchangeRate::Store do
  subject(:store) { described_class.new }

  describe "mocked Redis behaviour" do
    it "should use in-memory Redis instance" do
      expect(store.send(:redis)).to be_an_instance_of(MockRedis)
    end
  end

  describe ".set_rate" do
    let(:rate) do
      ExchangeRate::Rate.new(date: Date.today, currency: "GBP", rate: 0.1)
    end

    context "when successful" do
      it "returns true" do
        expect(store.set_rate(rate)).to be(true)
      end
  
      it "sets a composite key" do
        store.set_rate(rate)
  
        expect(
          store.get_rate(rate.date, rate.currency)
        ).to eq(rate)
      end
    end

    context "when unsuccessful" do
      before do
        allow(ExchangeRate.configuration.store.redis).to receive(:set).and_return("ERROR")
      end

      it "raises an exception" do
        expect { store.set_rate(rate) }.to raise_error(ExchangeRate::DataStoreError)
      end
    end
  end

  describe ".get_rate" do
    let(:rate) do
      ExchangeRate::Rate.new(date: Date.today, currency: "TBK", rate: 0.1)
    end

    context "when key has been set" do
      subject { store.get_rate(rate.date, rate.currency) }

      before { store.set_rate(rate) }
  
      it "marshalls a new Rate" do
        expect(subject).to be_an_instance_of(ExchangeRate::Rate)
      end
  
      it "returns a Rate with the correct date" do
        expect(subject.date).to eq(Date.today)
      end
  
      it "returns a Rate with the correct currency" do
        expect(subject.currency).to eq("TBK")
      end
  
      it "returns a Rate with the correct rate" do
        expect(subject.rate).to eq(0.1)
      end
    end

    context "when key is unset" do
      subject { store.get_rate(rate.date, rate.currency) }

      context "when no rate is available" do
        it "should raise an exception" do
          expect { subject }.to raise_error(ExchangeRate::NoRateError)
        end
      end

      context "when an earlier rate is available" do
        let(:previous_rate) do
          ExchangeRate::Rate.new(date: Date.today - 5, currency: "TBK", rate: 0.25)
        end

        context "when a previous rate is available" do
          before { store.set_rate(previous_rate) }

          it "should return the most recent date" do
            expect(subject.date).to eq(previous_rate.date)
          end

          it "should return the most recent rate" do
            expect(subject.rate).to eq(previous_rate.rate)
          end
        end
      end
    end
  end
end
