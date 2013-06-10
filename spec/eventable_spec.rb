require 'spec_helper'

class EventableSpec
  include Vienna::Eventable

  def events
    @eventable
  end
end

describe Vienna::Eventable do

  let(:obj) { EventableSpec.new }

  describe "#on" do
    it "should register event handlers for given name" do
      handler = Proc.new {}
      obj.on(:foo, &handler)
      obj.events[:foo].should == [handler]
    end

    it "returns the given handler" do
      handler = Proc.new {}
      obj.on(:foo, &handler).should eq(handler)
    end
  end

  describe "#off" do
    it "has no affect if no handlers defined at all" do
      obj.off(:bar, proc {})
      obj.on(:foo) { raise "err" }
      obj.off(:bar, proc {})
    end

    it "removes the handler for the event" do
      called = false
      handler = obj.on(:foo) { called = true }

      obj.off(:foo, handler)
      obj.trigger(:foo)
      called.should be_false
    end
  end

  describe "#trigger" do
    it "should call handler" do
      called = false

      obj.on(:foo) { called = true }
      called.should == false

      obj.trigger(:foo)
      called.should == true
    end

    it "should pass all arguments to handler" do
      args = nil
      obj.on(:foo) { |*a| args = a }

      obj.trigger(:foo)
      args.should == []

      obj.trigger(:foo, 1)
      args.should == [1]

      obj.trigger(:foo, 1, 2, 3)
      args.should == [1, 2, 3]
    end

    it "should allow multiple different events to be registered" do
      result = []
      obj.on(:foo) { result << :foo }
      obj.on(:bar) { result << :bar }

      obj.trigger(:foo)
      result.should == [:foo]

      obj.trigger(:bar)
      result.should == [:foo, :bar]
    end

    it "should allow multiple handlers for an event" do
      count = 0

      obj.on(:foo) { count += 1 }
      obj.on(:foo) { count += 1 }
      obj.on(:foo) { count += 1 }
      obj.on(:foo) { count += 1 }
      obj.trigger(:foo)

      count.should == 4
    end
  end
end
