require_relative '../route'

class Foo
  def index
    {some: 'hi', json: 'world!'}
  end

  def bar
    Response.build('<html><head><title>Title</title></head><body>hola</body></html>',
      content_type: :html)
  end

  def test
    not_found
  end
end
