describe "Model#id" do
  before do
    @cls = Class.new Vienna::Model

    @cls2 = Class.new(Vienna::Model) do
      primary_key :foo
    end 
  end

  it "should return the id attribute or nil if not set" do
    @cls.new.id.should == nil
    @cls.new(id: 42).id.should == 42
  end

  it "should return the attribute set by a custom primary_key" do
    @cls2.new.id.should == nil
    @cls2.new(foo: 200).id.should == 200
  end
end
