require 'byebug'

module Router
  BASE_ROUTES_FOLDER = 'routes'

  module_function

  def dispatch(request)
    target_class = lookup(request)
    response = target_class.send(request.path_action)

    require_relative 'response'
    Response.build(response)

  rescue NotFound, NoMethodError
    Response.not_found
  end

  # TODO: Research ways to load code
  # https://practicingruby.com/articles/ways-to-load-code

  # TODO: Hide this method from outside the module
  def lookup(request)
    file_path = File.join(BASE_ROUTES_FOLDER, "#{request.primary_path}.rb")
    raise NotFound.new(request) unless File.exists?(file_path)

    require_relative file_path
    route = Object.const_get(request.target_class).new

    require_relative 'route'
    route.extend(Route)

  rescue LoadError
    raise NotFound.new(request) unless File.exists?(file_path)
  end

  class NotFound < StandardError; end
end
