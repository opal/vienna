require 'spec_helper'

class AccessingAttributesSpec < Vienna::Model
  attributes :first_name, :last_name

  def last_name=(name)
    raise "Cannot set last_name"
  end
end

describe Vienna::Model do

  let(:model) { AccessingAttributesSpec.new }
  let(:attributes) { model.instance_variable_get :@attributes }

  describe "#[]" do
    it "retrieves attributes from @attributes directly" do
      model[:first_name].should be_nil
      model.first_name = "Adam"
      model[:first_name].should eq("Adam")
    end

    it "returns nil (hash default) when accessing unknown attribute" do
      model[:foo].should be_nil
      attributes[:foo] = 100
      model[:foo].should eq(100)
    end
  end

  describe "#[]=" do
    it "sets attributes on @attributes directly" do
      model[:first_name] = "Adam"
      attributes[:first_name].should eq("Adam")
    end

    it "does not use designated writer method" do
      model[:last_name] = "Beynon"
      attributes[:last_name].should eq("Beynon")
    end
  end
end
