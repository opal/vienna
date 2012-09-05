# Vienna: Client side MVC framework for Opal

## Model

Models include the `Vienna::Model` model.

```ruby
class Book
  include Vienna::Model

  attribute :title
  attribute :author
end
```

## Attributes

Each attribute that a model has should be defined as an attribute.
Attributes are assumed, by default, to be strings, but a custom
type can be passed to define the type of attribute.

```ruby
class Person
  include Vienna::Model

  attribute :name
  attribute :age, :numeric
  attribute :eye_color, :string
end
```

Here the `:name` attribute will have the default `String` type. Specifying
the type will allow the internals to automatically handling encoding
and decoding of json data when sending and receiving data from the
server.

### Accessing attributes

The second reason to define attributes are that getter and setter methods
can be automatically created for the defined attributes.

Using the previous example, the name can be accessed by:

```ruby
person.name
person[:name]
```

And set using:

```ruby
person.name = 'Adam'
person[:name] = 'Adam'
```

## Creating Models

```ruby
# create instance
book = Book.new title: 'First Book', author: 'Adam'

# use created setter
book.title = 'Amended title'

# getter
book.title    # => 'Amended title'

# no id, so it must be new
book.new?     # => true

# for sending over http/ajax
book.to_json  # => '{"title": "Amended title", "author": "Adam"}'
```