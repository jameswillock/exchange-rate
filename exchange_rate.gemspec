Gem::Specification.new do |spec|
  spec.name           = "exchange-rate"
  spec.version        = "0.0.1"
  spec.date           = "2018-06-27"
  spec.summary        = "Currency conversion library"
  spec.authors        = ["James Willock"]
  spec.email          = "james.willock@gmail.com"
  spec.files          = Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.homepage       = "https://github.com/niceguyjames"
  spec.license        = "MIT"
  spec.require_paths  = ["lib"]

  spec.add_runtime_dependency "dry-struct", "~> 0.5.0"
  spec.add_runtime_dependency "redis", "~> 4.0.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "mock_redis"
end
