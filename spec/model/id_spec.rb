describe "Model#id" do
  it "should return the id attribute or nil if not set" do
    SimpleModelSpec.new.id.should == nil
    SimpleModelSpec.new(id: 42).id.should == 42
  end

  it "should return the attribute set by a custom primary_key" do
    SimpleModelSpec2.new.id.should == nil
    SimpleModelSpec2.new(foo: 200).id.should == 200
  end
end