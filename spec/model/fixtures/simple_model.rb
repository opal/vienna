class SimpleModelSpec < Vienna::Model
  property :foo
  property :bar
  property :baz

  property :woosh, :kapow
end

class SimpleModelSpec2 < Vienna::Model
  primary_key :foo
end