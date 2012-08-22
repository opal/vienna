describe "Field#initialize" do
  before do
    @name  = Vienna::Field.new 'name'
    @age   = Vienna::Field.new 'age', type: Numeric
    @color = Vienna::Field.new 'color', type: String
  end

  it "stores the given type class" do
    @name.type.should == String
    @age.type.should == Numeric
    @color.type.should == String
  end
end
