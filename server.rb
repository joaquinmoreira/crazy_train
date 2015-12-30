require 'rack'
require_relative 'application'

Rack::Handler::WEBrick.run Application.start
