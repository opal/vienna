require 'spec_helper'
require 'vienna/observable'

class ObservableSpec
  include Vienna::Observable

  attr_accessor :foo, :bar, :baz, :non_boolean
  attr_writer :loaded

  def baz=(b)
    @baz = b + 10
  end

  def bar=(b)
    @bar = b
    "#bar"
  end

  def loaded?
    "boolean_#@loaded"
  end

  def non_boolean?
    :should_not_be_read
  end
end

describe Vienna::Observable do
  subject { ObservableSpec.new }

  describe "#replace_writer_for" do
    it "still calls the original method using super" do
      subject.replace_writer_for(:foo)
      subject.baz = 100
      subject.baz.should eq(110)
    end

    it "returns the value from the original method" do
      subject.replace_writer_for(:bar)
      (subject.bar = 32).should eq("#bar")
    end

    it "does not add a setter unless an existing attribute= method exists" do
      subject.replace_writer_for(:bob)
      subject.should_not respond_to(:bob=)
    end

    it "the new writer calls attribute_did_change with attribute name" do
      subject.replace_writer_for(:foo)
      def subject.attribute_did_change(attribute); @_called = attribute; end

      subject.instance_variable_get(:@_called).should be_nil
      subject.foo = 100
      subject.instance_variable_get(:@_called).should eq(:foo)
    end
  end

  describe "#add_observer" do
    it "handlers can be added to observe specific attributes" do
      count = 0
      subject.add_observer(:foo) { count += 1 }

      subject.foo = 100
      count.should eq(1)

      subject.foo = 150
      count.should eq(2)
    end

    it "allows more than one handler to be added for an attribute" do
      result = []
      subject.add_observer(:foo) { result << :first }
      subject.add_observer(:foo) { result << :second }

      subject.foo = 42
      result.should eq([:first, :second])

      subject.foo = 3.142
      result.should eq([:first, :second, :first, :second])
    end
  end

  describe "#attribute_did_change" do
    it "does not break for an object with no observers" do
      subject.attribute_did_change(:foo_bar)
    end

    it "does not break when given an attriubte with no observers (but another observable exists)" do
      subject.add_observer(:foo) {}
      subject.attribute_did_change(:bar)
    end

    it "passes new value to each handler" do
      result = nil
      subject.add_observer(:foo) { |val| result = val }

      subject.foo = 42
      result.should eq(42)

      subject.foo = 3.142
      result.should eq(3.142)
    end

    it "tries to get new value for boolean accessors" do
      result = nil
      subject.add_observer(:loaded) { |val| result = val }

      subject.loaded = :foobar
      result.should eq("boolean_foobar")
    end

    it "tries to read normal accessor before boolean accessor" do
      result = nil
      subject.add_observer(:non_boolean) { |val| result = val }

      subject.non_boolean = :foo
      result.should eq(:foo)
    end
  end

  describe "#remove_observer" do
    it "has no effect when no observers setup for attribute" do
      subject.remove_observer(:foo, proc {})
    end

    it "has no effect if the handler doesnt exist for attribute" do
      p = proc {}
      subject.add_observer(:foo) {}
      subject.remove_observer(:foo, p)
    end

    it "removes an existing handler for given attribute" do
      count = 0
      handler = proc { count += 1 }
      subject.add_observer(:foo, &handler)

      subject.foo = 42
      count.should eq(1)

      subject.remove_observer(:foo, handler)
      subject.foo = 49
      count.should eq(1)
    end
  end
end
