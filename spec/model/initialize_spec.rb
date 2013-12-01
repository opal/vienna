require "spec_helper"

describe Vienna::Model do
  describe "#initialize" do
    it "should have all nil values for attributes when passed no attrs" do
      model = User.new

      expect(model.foo).to be_nil
      expect(model.bar).to be_nil
      expect(model.baz).to be_nil
    end

    it "should set a given value for a given attributes" do
      model = User.new foo: 3.142

      expect(model.foo).to eq(3.142)
      expect(model.bar).to be_nil
      expect(model.baz).to be_nil
    end

    it "should be able to set many attributes" do
      model = User.new foo: 'hello', bar: 'world', baz: 42

      expect(model.foo).to eq('hello')
      expect(model.bar).to eq('world')
      expect(model.baz).to eq(42)
    end

    it "creates @attributes as an empty hash" do
      model = User.new
      model.instance_variable_get(:@attributes).should eq({})
    end

    it "marks the model as being a new record" do
      expect(User.new).to be_new_record
    end

    it "marks the model as not being loaded" do
      expect(User.new).to_not be_loaded
    end
  end
end
