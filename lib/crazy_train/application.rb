require 'rack'
require_relative 'request'
require_relative 'response'
require_relative 'router'

class Application
  def self.start
    Rack::Handler::WEBrick.run(Proc.new do |rack_env|
        request = Request.from_rack_env(rack_env)
        response = Router.dispatch(request)
        response.to_rack
    end)
  end
end
