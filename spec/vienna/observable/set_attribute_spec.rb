describe "Observable#set_attribute" do
  before do
    @obj = ObservableSetAttributeSpec.new
  end

  it "should use the setter for the given attribute" do
    @obj.set_attribute(:foo, 42)
    @obj.foo.should == 42

    @obj.set_attribute(:foo, 3.142)
    @obj.foo.should == 3.142
  end

  it "should just return nil when setting an attribute with no setter method" do
    @obj.set_attribute(:bar, 'this should not be set')
    @obj.bar.should == nil
  end
end