module BaseAttributeSpec
  class SomeType < Vienna::BaseAttribute; end
  class OtherTypeAttribute < Vienna::BaseAttribute; end
end

describe Vienna::BaseAttribute do
	describe ".inherited" do
	  it "registers the class by its name on the base by removing 'Attribute' suffix" do
      Vienna::BaseAttribute[:some_type].should == BaseAttributeSpec::SomeType
      Vienna::BaseAttribute[:other_type].should == BaseAttributeSpec::OtherTypeAttribute
    end
    
    it "does not register a subclass that has no name" do
      Class.new(Vienna::BaseAttribute) # an error will be raised if this doesnt work
    end
	end
end