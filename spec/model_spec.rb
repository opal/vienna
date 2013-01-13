require "spec_helper"

class ViennaModelSpecs < Vienna::Model
  string :first_name
  string :last_name
end

describe Vienna::Model do
  describe "[]" do
    before do
      @obj = ViennaModelSpecs.new(last_name: 'Beynon')
    end

    it "returns nil for an unset attribute" do
      @obj[:first_name].should be_nil
    end

    it "returns the value for a set attribute" do
      @obj[:last_name].should eq('Beynon')
    end

    it "returns nil for an attribute not known by class" do
      @obj[:some_random_attr].should be_nil
    end
  end

  describe "[]=" do
    before do
      @obj = ViennaModelSpecs.new(last_name: 'Bond')
    end

    it "sets the attribute and value on internal @attributes hash" do
      @obj[:first_name] = 'Jim'
      @obj.instance_variable_get(:@attributes)[:first_name].should eq('Jim')
    end
  end
end
