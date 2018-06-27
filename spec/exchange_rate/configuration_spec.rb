RSpec.describe ExchangeRate::Configuration do
  subject(:config) { described_class.new }

  describe "#provider" do
    context "when no override presented" do
      it "defaults to Euro Central Bank" do
        expect(config.provider).to be_instance_of(ExchangeRate::Providers::EuroCentralBank)
      end
    end

    context "when overriden" do
      before do
        stub_const 'ExchangeRate::Providers::Example', Class.new
        config.register_provider(:example, ExchangeRate::Providers::Example)
        config.provider = :example
      end

      it "returns the new provider" do
        expect(config.provider).to be_instance_of(ExchangeRate::Providers::Example)
      end
    end
  end

  describe "#providers" do
    it "includes Euro Central Bank" do
      expect(config.providers).to include(ecb: ExchangeRate::Providers::EuroCentralBank)
    end
  end

  describe "#register_provider" do
    before do
      stub_const 'ExchangeRate::Providers::Example', Class.new
      config.register_provider(:example, ExchangeRate::Providers::Example)
    end
    
    it "adds the provider" do
      expect(config.providers).to include(
        ecb: ExchangeRate::Providers::EuroCentralBank,
        example: ExchangeRate::Providers::Example 
      )
    end
  end

  describe "#redis_configuration" do
    context "when configuration is provided" do
      before do
        config.redis_host = "some-random-host"
        config.redis_port = 1234
        config.redis_db = 1
      end

      it "preserves the configuration" do
        expect(config.redis_configuration).to match(
          host: "some-random-host", port: 1234, db: 1
        )
      end
    end
    
    context "when configuration is not provided" do
      it "returns an empty configuration" do
        expect(config.redis_configuration).to be_empty
      end
    end
  end

  describe "#redis_host" do
    let(:host) { "some-random-host" }

    it "is settable" do
      config.redis_host = host
      expect(config.redis_host).to eq(host)
    end
  end
  
  describe "#redis_port" do
    let(:port) { 1234 }

    it "is settable" do
      config.redis_port = port
      expect(config.redis_port).to eq(port)
    end
  end

  describe "#redis_port" do
    let(:db) { 1 }

    it "is settable" do
      config.redis_db = db
      expect(config.redis_db).to eq(db)
    end
  end
end
