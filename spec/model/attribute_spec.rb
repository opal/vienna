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
  end
end
