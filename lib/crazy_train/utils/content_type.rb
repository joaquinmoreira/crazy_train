module Utils
  module ContentType
    JSON = 'application/json'
    HTML = 'text/html'
    PLAIN = 'text/plain'
    XML = 'application/xml'

    module_function

    def from_symbol(symbol)
      const_get(symbol.upcase)
    end

    class Unknown < StandardError; end
  end
end
