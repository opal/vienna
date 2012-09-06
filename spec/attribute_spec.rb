module BaseAttributeSpec
  class SomeType < Vienna::Attribute
  end

  class OtherTypeAttribute < Vienna::Attribute
  end
end

describe Vienna::Attribute do
  describe ".inherited" do
    it "registers the class by its name on the base by removing 'Attribute' suffix" do
      Vienna::Attribute[:some_type].should == BaseAttributeSpec::SomeType
      Vienna::Attribute[:other_type].should == BaseAttributeSpec::OtherTypeAttribute
    end
    
    it "does not register a subclass that has no name" do
      Class.new(Vienna::Attribute) # an error will be raised if this doesnt work
    end
  end
  
  describe "#initialize" do
    before do
      @name  = Vienna::Attribute.new 'name'
      @age   = Vienna::Attribute.new 'age', :numeric
      @color = Vienna::Attribute.new 'color', :string
    end
  
    it "stores the given type class" do
      @name.type.should == :string
      @age.type.should == :numeric
      @color.type.should == :string
    end
  end
end