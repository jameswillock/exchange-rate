Gem::Specification.new do |spec|
  spec.name           = "exchange-rate"
  spec.version        = "0.0.1"
  spec.date           = "2018-06-28"
  spec.summary        = "Currency conversion library"
  spec.authors        = ["James Willock"]
  spec.email          = "james.willock@gmail.com"
  spec.files          = Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.homepage       = "https://github.com/niceguyjames"
  spec.license        = "MIT"
  spec.require_paths  = ["lib"]

  spec.add_runtime_dependency "dry-struct", "~> 0.5"
  spec.add_runtime_dependency "redis", "~> 4.0"
  spec.add_runtime_dependency "dotenv", "~> 2.5"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "webmock", "~> 3.4"
  spec.add_development_dependency "mock_redis", "~> 0.18"
end
