require 'spec_helper'
require 'vienna/observable'

class ObservableSpec
  include Vienna::Observable

  attr_accessor :foo, :bar, :baz

  def baz=(b)
    @baz = b + 10
  end

  def bar=(b)
    @bar = b
    "#bar"
  end
end

describe Vienna::Observable do

  let(:object) { ObservableSpec.new }

  describe "#replace_writer_for" do
    it "still calls the original method using super" do
      object.replace_writer_for(:foo)
      object.baz = 100
      object.baz.should eq(110)
    end

    it "returns the value from the original method" do
      object.replace_writer_for(:bar)
      (object.bar = 32).should eq("#bar")
    end

    it "does not add a setter unless an existing attribute= method exists" do
      object.replace_writer_for(:bob)
      object.should_not respond_to(:bob=)
    end

    it "the new writer calls attribute_did_change with attribute name" do
      object.replace_writer_for(:foo)
      def object.attribute_did_change(attribute); @_called = attribute; end

      object.instance_variable_get(:@_called).should be_nil
      object.foo = 100
      object.instance_variable_get(:@_called).should eq(:foo)
    end
  end

  describe "#add_observer" do
    it "handlers can be added to observe specific attributes" do
      count = 0
      object.add_observer(:foo) { count += 1 }

      object.foo = 100
      count.should eq(1)

      object.foo = 150
      count.should eq(2)
    end

    it "allows more than one handler to be added for an attribute" do
      result = []
      object.add_observer(:foo) { result << :first }
      object.add_observer(:foo) { result << :second }

      object.foo = 42
      result.should eq([:first, :second])

      object.foo = 3.142
      result.should eq([:first, :second, :first, :second])
    end
  end

  describe "#attribute_did_change" do
    it "does not break for an object with no observers" do
      object.attribute_did_change(:foo_bar)
    end

    it "does not break when given an attriubte with no observers (but another observable exists)" do
      object.add_observer(:foo) {}
      object.attribute_did_change(:bar)
    end

    it "passes new value to each handler" do
      result = nil
      object.add_observer(:foo) { |val| result = val }

      object.foo = 42
      result.should eq(42)

      object.foo = 3.142
      result.should eq(3.142)
    end
  end

  describe "#remove_observer" do
    it "has no effect when no observers setup for attribute" do
      object.remove_observer(:foo, proc {})
    end

    it "has no effect if the handler doesnt exist for attribute" do
      p = proc {}
      object.add_observer(:foo) {}
      object.remove_observer(:foo, p)
    end

    it "removes an existing handler for given attribute" do
      count = 0
      handler = proc { count += 1 }
      object.add_observer(:foo, &handler)

      object.foo = 42
      count.should eq(1)

      object.remove_observer(:foo, handler)
      object.foo = 49
      count.should eq(1)
    end
  end
end
