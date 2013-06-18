require "spec_helper"

class ModelAttributeSpec < Vienna::Model
  attribute :first_name
end

describe Vienna::Model do
  describe ".attribute" do

    let(:model) { ModelAttributeSpec.new }

    it "should create a reader method for attribute" do
      model.respond_to?(:first_name).should be_true
    end

    it "should create a writer method for attribute" do
      model.respond_to?(:first_name=).should be_true
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
