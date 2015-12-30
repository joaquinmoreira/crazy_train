require_relative 'response'

class Route

  Rack::Utils::SYMBOL_TO_STATUS_CODE.each do |symbol, code|
    define_method(symbol) do |content = nil|
      Response.send(symbol, content)
    end
  end
end
