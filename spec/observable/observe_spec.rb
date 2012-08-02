describe "Observable#observe" do
  before do
    @obj = ObservableObserveSpec.new
  end

  it "should allow handlers to be registered to observe given attribute changes" do
    count = 0
    @obj.observe(:foo) do |val|
      count += 1
    end

    @obj.foo = 100
    count.should == 1

    @obj.foo = 200
    count.should == 2
  end

  it "should allow more than one handler per attribute name" do
    out = []
    @obj.observe(:foo) { out << :first }
    @obj.observe(:foo) { out << :second }

    @obj.foo = 42
    out.should == [:first, :second]

    @obj.foo = 3.142
    out.should == [:first, :second, :first, :second]
  end

  it "should pass the updated attribute value to the handler" do
    val = nil
    @obj.observe(:foo) { |h| h.should == val }
    @obj.foo = (val = 42)
    @obj.foo = (val = 3.142)
  end

  it "should allow many handlers for different attributes" do
    out = []
    @obj.observe(:foo) { out << :foo }
    @obj.observe(:bar) { out << :bar }

    @obj.foo = 200
    out.should == [:foo]

    @obj.bar = 300
    out.should == [:foo, :bar]

    @obj.bar = 400
    out.should == [:foo, :bar, :bar]
  end

  it "should pass the new and old values of attribute to handlers" do
    @obj.foo = 200
    result   = []

    @obj.observe(:foo) { |new, old| result << [new, old] }

    @obj.foo = 500
    result.should == [[500, 200]]

    @obj.foo = 6284
    result.should == [[500, 200], [6284, 500]]
  end
end