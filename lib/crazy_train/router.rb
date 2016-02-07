require_relative 'response'

module Router
  BASE_ROUTES_FOLDER = './routes'
  DEFAULT_INDEX_ACTION = :index

  module_function

  def dispatch(request)
    route = lookup(request)
    response = route.send(action(request))

    Response.build(response)

  rescue NotFound, NoMethodError
    Response.not_found
  end

  # TODO: Hide this method from outside the module
  def lookup(request)
    primary_path = request.path_segments.first
    target_class = primary_path.capitalize

    file_path = File.join(BASE_ROUTES_FOLDER, "#{primary_path}.rb")
    raise NotFound.new(request) unless File.exists?(file_path)

    require file_path
    Object.const_get(target_class).new(request)

  rescue LoadError
    raise NotFound.new(request) unless File.exists?(file_path)
  end

  def action(request)
    request.path_segments[1] || DEFAULT_INDEX_ACTION
  end

  class NotFound < StandardError; end
end
