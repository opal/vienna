# Vienna: Client side MVC framework for Opal

## Model

```ruby
class Book < Vienna::Model
  # defined properties have getter/setter methods created
  property :title, :author
end

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