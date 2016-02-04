class Request
  attr_reader :url, :method, :post_data

  def initialize(url, method, post_data = nil)
    @url = url
    @method = method
    @parsed_uri = URI.parse(url)
  end

  def self.from_rack_env(rack_env)
    new(rack_env['REQUEST_URI'], rack_env['REQUEST_METHOD'], rack_env['rack.input'].gets)
  end

  def method_missing(method_name, *args, &block)
    @parsed_uri.send(method_name, *args, &block)
  end

  def path_segments
    # Since path starts with a '/' the first element is nil so its dropped
    path.split('/').drop(1)
  end
end
