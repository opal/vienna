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

## Views

`Vienna::View` is a simple wrapper class around a dom element representing a
view of some model (or models). A view's `element` is dynamically created when
first accessed. `View.element` can be used to specify a dom selector to find
the view in the dom.

Assuming the given html:

```html
<body>
  <div id="foo">
    <span>Hi</span>
  </div>
</body>
```

We can create our view like so:

```ruby
class MyView < Vienna::View
  element '#foo'
end

MyView.new.element
# => #<Element: [<div id="foo">]>
```

A real, existing, element can also be passed into the class method:

```ruby
class MyView < Vienna::View
  # Instances of this view will have the document as an element
  element Document
end
```

Views can have parents. If a child view is created, then the dom selector is
only searched inside the parents element.

### Rendering views

Views have a placeholder `render` method, that doesnt do anything by default.
This is the place to put rendering logic.

```ruby
class MyView < Vienna::View
  def render
    element.html = 'Welcome to my rubyicious page'
  end
end

view = MyView.new
view.render

view.element
# => '<div>Welcome to my rubyicious page</div>'
```

### Customizing elements

You can also override `create_element` if you wish to have any custom element
creation behaviour.

For example, a subview that is created from a parent element

```ruby
class NavigationView < Vienna::View
  def initialize(parent, selector)
    @parent, @selector = parent, selector
  end

  def create_element
    @parent.find(@selector)
  end
end
```

Assuming we have the html:

```html
<div id="header">
  <img id="logo" src="logo.png" />
  <ul class="navigation">
    <li>Homepage</li>
  </ul>
</div>
```

We can use the navigation view like this:

```ruby
@header = Element.find '#header'
nav_view = NavigationView.new @header, '.navigation'

nav_view.element
# => [<ul class="navigation">]
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

