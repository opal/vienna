# Vienna: Client side MVC framework for Opal

## Model

Models include the `Vienna::Model` model.

```ruby
class Book
  include Vienna::Model

  field :title
  field :author
end
```

## Fields

Each attribute that a model has should be defined as a field. Fields are
assumed, by default, to be strings, but a custom type can be passed to
define the type of field.

```ruby
class Person
  include Vienna::Model

  field :name
  field :age, type: String
  field :eye_color, type: String
end
```

Here the `:name` field will have the default `String` type. Specifying
the type will allow the internals to automatically handling encoding
and decoding of json data when sending and receiving data from the
server.

### Accessing fields

The second reason to define fields are that getter and setter methods
can be automatically created for the defined fields.

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
