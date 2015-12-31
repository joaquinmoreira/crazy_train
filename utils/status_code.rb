module Utils
  module StatusCode
    module_function

    def symbols_map
      Rack::Utils::SYMBOL_TO_STATUS_CODE
    end

    def from_symbol(symbol)
      Rack::Utils::SYMBOL_TO_STATUS_CODE[symbol]
    end

    Utils::StatusCode.symbols_map.each do |symbol, code|
      const_set(symbol.upcase, code)
    end
  end
end
