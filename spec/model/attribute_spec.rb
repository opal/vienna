require "spec_helper"

class ModelAttributeSpec < Vienna::Model
  attribute :first_name
end

describe Vienna::Model do
  describe ".attribute" do

    let(:model) { ModelAttributeSpec.new }
    let(:attributes) { model.instance_variable_get(:@attributes) }

    it "should create a reader method for attribute" do
      model.respond_to?(:first_name).should be_true
    end

    it "should create a writer method for attribute" do
      model.respond_to?(:first_name=).should be_true
    end

    describe "writer" do
      it "sets value on internal @attributes hash" do
        model.first_name = "Tommy"
        attributes[:first_name].should eq("Tommy")
      end
    end

    describe "reader" do
      it "retrieves the value from internal @attributes hash" do
        attributes[:first_name] = "Bob"
        model.first_name.should eq("Bob")
        attributes[:first_name] = "Bill"
        model.first_name.should eq("Bill")
      end
    end

    it "should fire a change_<attr_name> event when calling writer" do
      called = false
      model.on(:change_first_name) { called = true }

      model.first_name = "Adam"
      called.should be_true
    end

    it "should pass the model instance and new value to event" do
      args = nil
      model.on(:change_first_name) { |*a| args = a }

      model.first_name = "Tim"
      args.should eq([model, "Tim"])
    end
  end
end
