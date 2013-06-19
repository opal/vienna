require "spec_helper"

class ModelInitializeSpec < Vienna::Model
  attributes :foo, :bar, :baz
end

describe Vienna::Model do
  describe "#initialize" do
    it "should have all nil values for attributes when passed no attrs" do
      model = ModelInitializeSpec.new

      model.foo.should be_nil
      model.bar.should be_nil
      model.baz.should be_nil
    end

    it "should set a given value for a given attributes" do
      model = ModelInitializeSpec.new foo: 3.142

      model.foo.should eq(3.142)
      model.bar.should be_nil
      model.baz.should be_nil
    end

    it "should be able to set many attributes" do
      model = ModelInitializeSpec.new foo: 'hello', bar: 'world', baz: 42

      model.foo.should eq('hello')
      model.bar.should eq('world')
      model.baz.should eq(42)
    end

    it "creates @attributes as an empty hash" do
      model = ModelInitializeSpec.new
      model.instance_variable_get(:@attributes).should eq({})
    end

    it "marks the model as being a new record" do
      ModelInitializeSpec.new.new_record?.should be_true
    end

    it "marks the model as not being loaded" do
      ModelInitializeSpec.new.loaded?.should be_false
    end
  end
end
