describe "Observable#get_attribute" do
  before do
    @obj = ObservableGetAttributeSpec.new 'adam', 42, 3.142, 'omg'
  end

  it "should return attribute values for simple keys" do
    @obj.get_attribute(:foo).should == 'adam'
    @obj.get_attribute(:bar).should == 42
  end

  it "should check for boolean (foo?) accessors after normal getters" do
    @obj.get_attribute(:baz).should == 3.142
    @obj.get_attribute(:buz).should == 'omg'
  end

  it "should return nil for unknown attributes" do
    @obj.get_attribute(:fullname).should be_nil
    @obj.get_attribute(:pingpong).should be_nil
  end
end