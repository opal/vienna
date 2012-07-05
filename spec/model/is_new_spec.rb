describe "Model#new?" do
  before do
    @a = SimpleModelSpec.new id: 0
    @b = SimpleModelSpec.new id: 1
    @c = SimpleModelSpec.new
    @d = SimpleModelSpec.new id: nil
  end

  it "should return false if the model has an id" do
    @a.new?.should be_false
    @b.new?.should be_false
  end

  it "should return true when not given an id" do
    @c.new?.should be_true
  end

  it "should return true if given a `nil` id" do
    @d.new?.should be_true
  end

  it "should use the attribute identified by the primary_key" do
    SimpleModelSpec2.new(foo: 10).new?.should be_false
  end
end