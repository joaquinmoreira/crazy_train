require_relative 'utils/content_type'
require_relative 'utils/status_code'

class Response
  attr_reader :content, :status_code, :content_type
  DEFAULT_STATUS_CODE = Utils::StatusCode::OK

  private

  def initialize(content, options = {})
    @content = content
    @status_code = Utils::StatusCode.from_symbol(options.delete(:status_code)) || DEFAULT_STATUS_CODE
    @content_type = options.delete(:content_type)
  end

  class << self
    def build(content, options = {})
      ResponseBuilder.build(content, options)
    end

    # Generates helper methods for status codes
    # Ej: not_found, forbidden, precondition_failed
    Utils::StatusCode.symbols_map.each do |symbol, code|
      define_method(symbol) do |content = nil|
        build(content || symbol, status_code: code)
      end
    end
  end

  public

  def to_rack
    [
      @status_code,
      { 'Content-Type' => @content_type },
      [@content.to_s]
    ]
  end
end

class ResponseBuilder
  DEFAULT_STRUCTURED_CONTENT_TYPE = Utils::ContentType::JSON
  DEFAULT_PLAIN_CONTENT_TYPE = Utils::ContentType::PLAIN

  def self.build(content, options = {})
    new(content, options).build
  end

  def build
    content = build_content
    content_type = build_content_type
    options = (options || {}).merge(content_type: content_type)

    Response.new(content, options)
  end

  private

  def initialize(content, options)
    @content = content
    @options = options
  end

  def build_content
    @content.class == Response ? @content.content : @content
  end

  def build_content_type
    case @content
    when Response then @content.content_type
    when Hash, Array then DEFAULT_STRUCTURED_CONTENT_TYPE
    when String, Symbol then DEFAULT_PLAIN_CONTENT_TYPE
    else raise Utils::ContentType::Unknown.new(@content.class)
    end
  end
end
