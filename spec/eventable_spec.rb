require 'spec_helper'

class EventableSpec
  include Vienna::Eventable

  def events
    @eventable
  end
end

describe Vienna::Eventable do
  subject { EventableSpec.new }

  describe "#on" do
    it "should register event handlers for given name" do
      handler = Proc.new {}
      subject.on(:foo, &handler)

      expect(subject.events[:foo]).to eq([handler])
    end

    it "returns the given handler" do
      handler = Proc.new {}
      expect(subject.on(:foo, &handler)).to eq(handler)
    end
  end

  describe "#off" do
    it "has no affect if no handlers defined at all" do
      subject.off(:bar, proc {})
      subject.on(:foo) { raise "err" }
      subject.off(:bar, proc {})
    end

    it "removes the handler for the event" do
      called = false
      handler = subject.on(:foo) { called = true }

      subject.off(:foo, handler)
      subject.trigger(:foo)
      expect(called).to be_falsy
    end
  end

  describe "#trigger" do
    it "should call handler" do
      called = false

      subject.on(:foo) { called = true }
      called.should == false

      subject.trigger(:foo)
      called.should == true
    end

    it "should pass all arguments to handler" do
      args = nil
      subject.on(:foo) { |*a| args = a }

      subject.trigger(:foo)
      args.should == []

      subject.trigger(:foo, 1)
      args.should == [1]

      subject.trigger(:foo, 1, 2, 3)
      args.should == [1, 2, 3]
    end

    it "should allow multiple different events to be registered" do
      result = []
      subject.on(:foo) { result << :foo }
      subject.on(:bar) { result << :bar }

      subject.trigger(:foo)
      result.should == [:foo]

      subject.trigger(:bar)
      result.should == [:foo, :bar]
    end

    it "should allow multiple handlers for an event" do
      count = 0

      subject.on(:foo) { count += 1 }
      subject.on(:foo) { count += 1 }
      subject.on(:foo) { count += 1 }
      subject.on(:foo) { count += 1 }
      subject.trigger(:foo)

      count.should == 4
    end
  end
end
