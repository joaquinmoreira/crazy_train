require_relative 'utils/status_code'
require_relative 'response'
require 'uri'

class Route
  attr_reader :query, :post, :request, :id

  def initialize(request)
    @request = request
    @query = Rack::Utils.parse_query(request.query)
    @post = request.post_data
    @id = extract_id
  end

  Utils::StatusCode.symbols_map.each do |symbol, code|
    define_method(symbol) do |content = nil|
      Response.send(symbol, content)
    end
  end

  private

  # Extract an id from urls finishing with and integer id
  # E.g. URL '/people/1234' => path_segments: ['people', 1234] => id = 1234
  def extract_id
    @request.path_segments.last.scan(/^\d+$/).first
  end
end
