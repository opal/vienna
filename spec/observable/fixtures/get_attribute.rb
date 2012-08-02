class ObservableGetAttributeSpec
  attr_reader :foo

  def initialize(foo, bar, baz, buz)
    @foo = foo
    @bar = bar
    @baz = baz
    @buz = buz
  end

  def bar
    @bar
  end

  def baz
    @baz
  end

  def baz?
    'should not return this one'
  end

  def buz?
    @buz
  end
end