require_relative '../route'

class Foo < Route
  def index
    {some: 'hi', json: query['asd']}
  end

  def bar
    Response.build('<p>Hola</p>', content_type: :html)
  end

  def test
    not_found
  end

  def people
    {id: @id}
  end
end
