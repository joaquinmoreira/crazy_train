class Request
  attr_reader :method, :path, :query_string

  DEFAULT_INDEX_ACTION = :index

  def initialize(method, path, query_string = nil)
    @method = method
    @path = path
    @query_string = query_string
  end

  def self.from_rack_env(rack_env)
    new(
      rack_env['REQUEST_METHOD'],
      rack_env['PATH_INFO'],
      rack_env['QUERY_STRING']
    )
  end

  # TODO: Improve split
  def path_sections
    path.split('/').drop(1)
  end

  # TODO: Refactor move path related code to its own class
  def primary_path
    path_sections.first
  end

  def path_action
    path_sections[1] || DEFAULT_INDEX_ACTION
  end

  # TODO: Include all scenarios.
  # Currently an heuristic working for single worded file names only
  def target_class
    primary_path.capitalize
  end
end
