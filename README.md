# Vienna: Client side MVC framework for Opal

Until a better README is out (shame on us) you can take a look at 
the [Opal implementation](https://github.com/opal/opal-todos) 
of [TodoMVC](http://todomvc.com).

## Model

```ruby
class Book < Vienna::Model
  string :title
  string :author
end
```
