# Vienna: Client side MVC framework for Opal

[![Build Status](https://travis-ci.org/opal/vienna.png?branch=master)](https://travis-ci.org/opal/vienna)

Until a better README is out (shame on us) you can take a look at 
the [Opal implementation](https://github.com/opal/opal-todos) 
of [TodoMVC](http://todomvc.com).

## Model

Client side models.

```ruby
class Book < Vienna::Model
  attributes :title, :author
end

book = Book.new(title: 'My awesome book', author: 'Bob')
book.title = 'Bob: A story of awesome'
```

### Attributes

Attributes can be defined on subclasses using `attributes`. This simply defines
a getter/setter method using `attr_accessor`. You can override either method as
expected:

```ruby
class Book < Vienna::Model
  attributes :title, :release_date

  # If date is a string, then we need to parse it
  def release_date=(date)
    date = Date.parse(date) if String === date
    @release_date = date
  end
end

book = Book.new(:release_date => '2013-1-10')
book.release_date
# => #<Date: 2013-1-10>
```

## Router

`Vienna::Router` is a simple router that watches for hashchange events.

```ruby
router = Vienna::Router.new

router.route("/users") do
  puts "need to show all users"
end

router.route("/users/:id") do |params|
  puts "need to show user: #{ params[:id] }"
end


# visit "example.com/#/users"
# visit "example.com/#/users/3"
# visit "example.com/#/users/5"

# => "need to show all users"
# => need to show user: 3
# => need to show user: 5
```

#### Todo

* Support older browsers which do not support onhashchange.
* Support not-hash style routes with HTML5 routing.

## License

MIT

