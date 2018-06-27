module ExchangeRate
  module Providers
    class BaseProvider
      def rates(date = nil)
        raise NotImplementedError
      end
    end
  end
end
