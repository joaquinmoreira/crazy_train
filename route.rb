require_relative 'utils/status_code'
require_relative 'response'

module Route

  Utils::StatusCode.symbols_map.each do |symbol, code|
    define_method(symbol) do |content = nil|
      Response.send(symbol, content)
    end
  end
end
