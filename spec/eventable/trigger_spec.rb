describe "Eventable#trigger" do
  before do
    @obj = EventableSpec.new
  end

  it "should call handler" do
    called = false

    @obj.on(:foo) { called = true }
    called.should == false

    @obj.trigger(:foo)
    called.should == true
  end

  it "should pass all arguments to handler" do
    args = nil
    @obj.on(:foo) { |*a| args = a }

    @obj.trigger(:foo)
    args.should == []

    @obj.trigger(:foo, 1)
    args.should == [1]

    @obj.trigger(:foo, 1, 2, 3)
    args.should == [1, 2, 3]
  end

  it "should allow multiple different events to be registered" do
    result = []
    @obj.on(:foo) { result << :foo }
    @obj.on(:bar) { result << :bar }

    @obj.trigger(:foo)
    result.should == [:foo]

    @obj.trigger(:bar)
    result.should == [:foo, :bar]
  end

  it "should allow multiple handlers for an event" do
    count = 0

    @obj.on(:foo) { count += 1 }
    @obj.on(:foo) { count += 1 }
    @obj.on(:foo) { count += 1 }
    @obj.on(:foo) { count += 1 }
    @obj.trigger(:foo)

    count.should == 4
  end
end