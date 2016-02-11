# crazy_train

![image](http://cdn.meme.am/instances/500x/60254699.jpg)

Ruby web micro framework with simplicity and zero configuration as its foundations!

It's now in an early stage and it's not recommended to be used in a production environment.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'crazy_train', github: 'joaquinrulin/crazy-train'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crazy_train

## Usage

Create a folder named routes:

``` $ mkdir routes ```

Create a route file like inside routes folder: 

```ruby
# routes/foo.rb

require 'crazy_train'

class Foo < Route
  def index
    {some: 'hi', json: query['asd']}
  end

  def bar
    Response.build('<p>Hi</p>', content_type: :html)
  end

  def test
    not_found
  end

  def people
    {id: @id}
  end
end

```

Start the crazy server:

``` 
$ crazy 
```

Hit your browser on: `http://localhost:8080/foo?asd=world` 

## To be done
1. Specs.
2. Logic for default route at `/`.
3. Wrapper for rack logger to implement simple logging.
4. Easy way to configure port and other basic server features.
5. Performance tests and benchmark with other similar ruby frameworks.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/crazy_train/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
