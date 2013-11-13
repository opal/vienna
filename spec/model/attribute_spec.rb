require "spec_helper"

class ModelAttributeSpec < Vienna::Model
  attribute :first_name
end

describe Vienna::Model do
  describe ".attribute" do

    let(:model) { ModelAttributeSpec.new }

    it "should create a reader method for attribute" do
      model.should respond_to(:first_name)
    end

    it "should create a writer method for attribute" do
      model.should respond_to(:first_name=)
    end

    describe "writer" do
      it "sets value on model" do
        model.first_name = "Tommy"
        model.first_name.should eq("Tommy")
      end
    end
  end
end
