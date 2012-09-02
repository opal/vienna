describe Vienna::RunLoop do
  before do
    @runloop = Vienna::RunLoop
    @runloop.finish
  end

  it "flushes the queue when #finish is called" do
    count = 0

    @runloop.perform { count += 1 }
    count.should == 0

    @runloop.finish
    count.should == 1

    @runloop.finish
    count.should == 1
  end

  it "flushes items from queue even added after flushing begins" do
    count = 0
    handler = proc do
      count += 1
      @runloop.perform(&handler) if count < 3
    end

    @runloop.perform(&handler)
    count.should == 0

    @runloop.finish
    count.should == 3

    @runloop.finish
    count.should == 3
  end

  it "runs items in the correct order when flushing" do
    out = []

    @runloop.perform do
      out << 'foo'
      @runloop.perform { out << 'bar' }
    end

    @runloop.perform do
      out << 'baz'
      @runloop.perform { out << 'woosh' }
      @runloop.perform { out << 'kapow' }
    end

    @runloop.perform { out << 'yay' }

    out.should == []

    @runloop.finish
    out.should == ['foo', 'baz', 'yay', 'bar', 'woosh', 'kapow']
  end
end