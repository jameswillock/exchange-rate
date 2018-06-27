require 'dry-types'
require 'dry-struct'

module ExchangeRate
  module Types
    include Dry::Types.module

    Currency = Strict::String.constrained(format: /[A-Z]/, max_size: 3, min_size: 3)
  end

  class Rate < Dry::Struct
    attribute :date, Types::Strict::Date
    attribute :currency, Types::Currency
    attribute :rate, Types::Strict::Float
  end
end