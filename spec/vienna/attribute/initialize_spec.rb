describe "BaseAttribute#initialize" do
  before do
    @name  = Vienna::BaseAttribute.new 'name'
    @age   = Vienna::BaseAttribute.new 'age', :numeric
    @color = Vienna::BaseAttribute.new 'color', :string
  end

  it "stores the given type class" do
    @name.type.should == :string
    @age.type.should == :numeric
    @color.type.should == :string
  end
end
