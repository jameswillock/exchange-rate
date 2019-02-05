RSpec.describe ExchangeRate::Rate do
  describe "#initialize" do
    valid_data = { date: Date.today, currency: "GBP", rate: 0.1 }

    context "when provided valid data" do
      it "does not raise an exception" do
        expect { described_class.new(valid_data) }.not_to raise_error
      end
    end

    context "when provided an invalid date" do
      it "raises an exception" do
        expect { described_class.new(valid_data.merge(date: 'invalid')) }.to raise_error(Dry::Struct::Error)
      end
    end

    context "when provided an invalid rate" do
      it "raises an exception" do
        expect { described_class.new(valid_data.merge(rate: 1)) }.to raise_error(Dry::Struct::Error)
      end
    end

    context "when provided an invalid currency" do
      it "raises an exception" do
        expect { described_class.new(valid_data.merge(currency: 'EURO')) }.to raise_error(Dry::Struct::Error)
      end
    end
  end
end
