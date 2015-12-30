module Router
  BASE_ROUTES_FOLDER = 'routes'
  # TODO: Map content_types in an util module
  DEFAULT_STRUCTURED_CONTENT_TYPE = :json

  module_function

  def dispatch(request)
    target_class = lookup(request)
    response = target_class.new.send(request.path_action)

    require_relative 'response'
    adapt_response(response)

  rescue NotFound
    Response.not_found
  end

  # TODO: Make this method not exposed
  # TODO: Map content_types in an util module
  def adapt_response(response)
    case response
    when Response then response
    when Hash, Array then Response.new(response, content_type: DEFAULT_STRUCTURED_CONTENT_TYPE)
    else Response.new(response)
    end
  end

  # TODO: Research ways to load code
  # https://practicingruby.com/articles/ways-to-load-code
  def lookup(request)
    file_path = File.join(BASE_ROUTES_FOLDER, "#{request.primary_path}.rb")
    raise NotFound.new(request) unless File.exists?(file_path)

    require_relative file_path
    Object.const_get(request.target_class)

  rescue LoadError
    raise NotFound.new(request) unless File.exists?(file_path)
  end

  class NotFound < StandardError; end
end
