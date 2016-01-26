require_relative 'utils/content_type'
require_relative 'utils/status_code'
require_relative 'rack/response'

class Response
  attr_reader :content, :status_code, :content_type, :options

  private

  def initialize(content, options = {})
    @content = content
    @status_code = options.delete(:status_code)
    @content_type = options.delete(:content_type)
    @options = options

    @rack_response = Rack::Response.build(self)
  end

  class << self
    def build(content, options = {})
      return content if content.is_a?(Response)
      ResponseBuilder.build(content, options)
    end

    # Generates factory methods for status codes
    # Ej: not_found, forbidden, precondition_failed
    Utils::StatusCode.symbols_map.each do |symbol, code|
      define_method(symbol) do |content = nil|
        build(content || symbol, status_code: code)
      end
    end
  end

  public

  def to_rack
    @rack_response.output
  end
end

class ResponseBuilder
  DEFAULT_STRUCTURED_CONTENT_TYPE = Utils::ContentType::JSON
  DEFAULT_PLAIN_CONTENT_TYPE = Utils::ContentType::PLAIN
  DEFAULT_STATUS_CODE = Utils::StatusCode::OK

  def self.build(content, options = {})
    new(content, options).build
  end

  def build
    content_type = build_content_type
    content = build_content(content_type)
    status_code = build_status_code

    options = (options || {}).merge!(
      content_type: content_type,
      status_code: status_code
    )

    Response.new(content, options)
  end

  private

  def initialize(content, options)
    @content = content
    @options = options
  end

  def build_content_type
    content_type = @options[:content_type]
    return Utils::ContentType.from_symbol(content_type) if content_type

    case @content
    when Response then @content.content_type
    when Hash, Array then DEFAULT_STRUCTURED_CONTENT_TYPE
    when String, Symbol then DEFAULT_PLAIN_CONTENT_TYPE
    else raise Utils::ContentType::Unknown.new(@content.class)
    end
  end

  # TODO: Integrate other content_types
  def build_content(content_type)
    @content.class == Response ? @content.content : @content
    if content_type == Utils::ContentType::JSON
      require 'json'
      @content.to_json
    else
      @content
    end
  end

  def build_status_code
    return DEFAULT_STATUS_CODE unless @options[:status_code]
    return Utils::StatusCode.from_symbol(@options[:status_code])
  end
end
