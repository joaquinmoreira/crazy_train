class Response
  attr_reader :content, :status_code, :content_type, :options
  DEFAULT_STATUS_CODE = 200
  DEFAULT_CONTENT_TYPE = 'text'

  def initialize(content, options = {})
    @content = content
    @status_code = options[:status_code] || DEFAULT_STATUS_CODE
    @content_type = options[:content_type] || DEFAULT_CONTENT_TYPE
    @options = options
  end

  def to_rack
    [
      @status_code,
      { 'Content-Type' => @content_type },
      [@content.to_s]
    ]
  end

  Rack::Utils::SYMBOL_TO_STATUS_CODE.each do |symbol, code|
    define_singleton_method(symbol) do |content = nil|
      new(content || symbol, code: code)
    end
  end
end
