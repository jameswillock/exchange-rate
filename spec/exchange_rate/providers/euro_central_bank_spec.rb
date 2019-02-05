RSpec.describe ExchangeRate::Providers::EuroCentralBank do
  let(:date) { Date.today }

  subject(:provider) { described_class.new }

  let(:valid_xml) do
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <gesmes:Envelope xmlns:gesmes="http://www.gesmes.org/xml/2002-08-01" xmlns="http://www.ecb.int/vocabulary/2002-08-01/eurofxref">
    <gesmes:subject>Reference rates</gesmes:subject>
    <gesmes:Sender>
      <gesmes:name>European Central Bank</gesmes:name>
    </gesmes:Sender>
    <Cube>
      <Cube time="#{date}">
        <Cube currency="USD" rate="1.1616"/>
        <Cube currency="JPY" rate="128.08"/>
        <Cube currency="BGN" rate="1.9558"/>
      </Cube>
      <Cube time="#{date - 1}">
        <Cube currency="USD" rate="0.1616"/>
        <Cube currency="JPY" rate="328.08"/>
        <Cube currency="BGN" rate="6.9558"/>
      </Cube>
    </Cube>
    </gesmes:Envelope>
    XML
  end

  describe "#rates" do
    context "when a date is provided" do
      context "when HTTP request is unsuccessful" do
        before do
          stub_request(
            :get, ExchangeRate::Providers::EuroCentralBank::DOCUMENT_URI
          ).to_return(status: 500)
        end

        it "raises an exception" do
          expect { provider.rates(date) }.to raise_error(ExchangeRate::ThirdPartyRequestError)
        end
      end

      context "when XML payload is malformed" do
        let(:malformed_payload) do
          <<-XML
          <?xml version="1.0" encoding="UTF-8"?>
          <gesmes:Envelope xmlns:gesmes="http://www.gesmes.org/xml/2002-08-01" xmlns="http://www.ecb.int/vocabulary/2002-08-01/eurofxref">
          <gesmes:subject>Reference rates</gesmes:subject>
          <gesmes:Sender>
            <gesmes:name>European Central Bank</gesmes:name>
          </gesmes:Sender>
          <Rates>
          </Rates>
          </gesmes:Envelope>
          XML
        end

        before do
          stub_request(
            :get, ExchangeRate::Providers::EuroCentralBank::DOCUMENT_URI
          ).to_return(status: 200, body: malformed_payload)
        end

        it "raises an exception" do
          expect { provider.rates(date) }.to raise_error(ExchangeRate::FormatError)
        end
      end

      context "when HTTP request is successful" do
        before do
          stub_request(
            :get, ExchangeRate::Providers::EuroCentralBank::DOCUMENT_URI
          ).to_return(status: 200, body: valid_xml)
        end

        it "returns a collection of rates" do
          expect(provider.rates(date)).to eq([
            { date: date, currency: "USD", rate: 1.1616 },
            { date: date, currency: "JPY", rate: 128.08 },
            { date: date, currency: "BGN", rate: 1.9558 }
          ])
        end
      end

      context "when a date is not provided" do
        context "when HTTP request is unsuccessful" do
          before do
            stub_request(
              :get, ExchangeRate::Providers::EuroCentralBank::DOCUMENT_URI
            ).to_return(status: 500)
          end

          it "raises an exception" do
            expect { provider.rates }.to raise_error(ExchangeRate::ThirdPartyRequestError)
          end
        end

        context "when HTTP request is successful" do
          before do
            stub_request(
              :get, ExchangeRate::Providers::EuroCentralBank::DOCUMENT_URI
            ).to_return(status: 200, body: valid_xml)
          end

          it "returns a collection of rates" do
            expect(provider.rates).to eq([
              { date: date, currency: "USD", rate: 1.1616 },
              { date: date, currency: "JPY", rate: 128.08 },
              { date: date, currency: "BGN", rate: 1.9558 },
              { date: date - 1, currency: "USD", rate: 0.1616 },
              { date: date - 1, currency: "JPY", rate: 328.08 },
              { date: date - 1, currency: "BGN", rate: 6.9558 }
            ])
          end
        end
      end
    end
  end
end
