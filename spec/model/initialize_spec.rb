describe "Model#initialize" do
  before do
    @a = SimpleModelSpec.new
    @b = SimpleModelSpec.new foo: 3.142
    @c = SimpleModelSpec.new foo: "hello", bar: "world", baz: 42
  end

  it "should have all nil values for attributes when passed no attrs" do
    @a[:foo].should be_nil
    @a[:bar].should be_nil
    @a[:baz].should be_nil
  end

  it "should set given attribute values" do
    @b[:foo].should == 3.142
    @b[:bar].should be_nil
    @b[:baz].should be_nil
  end

  it "should set all attributes when all attrs given" do
    @c[:foo].should == "hello"
    @c[:bar].should == "world"
    @c[:baz].should == 42
  end
end