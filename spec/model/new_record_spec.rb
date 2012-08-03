describe "Model#new_record?" do
  before do
    @a = SimpleModelSpec.new id: 0
    @b = SimpleModelSpec.new id: 1
    @c = SimpleModelSpec.new
    @d = SimpleModelSpec.new id: nil
  end

  it "should return false if the model has an id" do
    @a.new_record?.should be_false
    @b.new_record?.should be_false
  end

  it "should return true when not given an id" do
    @c.new_record?.should be_true
  end

  it "should return true if given a `nil` id" do
    @d.new_record?.should be_true
  end

  it "should use the attribute identified by the primary_key" do
    SimpleModelSpec2.new(foo: 10).new_record?.should be_false
  end
end