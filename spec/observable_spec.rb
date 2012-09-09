class ObservableSpec
  attr_accessor :foo, :bar
  attr_reader :first_name, :baz

  def initialize
    @foo = 'adam'
    @bar = 42
    @baz = 3.142
    @buz = 'omg'
  end

  def baz?
    'should not return this one'
  end

  def buz?
    @buz
  end
end

describe Vienna::Observable do
  before do
    @obj = ObservableSpec.new
  end

  describe "#get_attribute" do
    it "returns attribute values for simple keys" do
      @obj.get_attribute(:foo).should == 'adam'
      @obj.get_attribute(:bar).should == 42
    end

    it "checks for boolean (foo?) accessors after normal getters" do
      @obj.get_attribute(:baz).should == 3.142
      @obj.get_attribute(:buz).should == 'omg'
    end

    it "returns nil for unknown attributes" do
      @obj.get_attribute(:fullname).should be_nil
      @obj.get_attribute(:pingpong).should be_nil
    end
  end
  
  describe "#set_attribute" do
    it "uses the setter for the given attribute" do
      @obj.set_attribute(:foo, 42)
      @obj.foo.should == 42

      @obj.set_attribute(:foo, 3.142)
      @obj.foo.should == 3.142
    end

    it "returns nil when setting an attribute with no setter method" do
      @obj.set_attribute(:baz, 'this should not be set')
      @obj.baz.should == 3.142
    end
  end
  
  describe "#observe" do
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

    it "should not create a setter method if one did not already exist" do
      @obj.respond_to?(:first_name=).should be_false
      @obj.observe(:first_name) { nil }
      @obj.respond_to?(:first_name=).should be_false
    end

    it "should return the passed in block" do
      proc = proc {}
      @obj.observe(:foo, &proc).should == proc
    end
  end
  
  describe "#observe with a path" do
    before do
      @foo = ObservableSpec.new
      @bar = ObservableSpec.new
      
      def @foo.observers; @observers; end
      def @bar.observers; @observers; end

      @foo.bar = @bar
      @bar.bar = 42
    end

    it "should create observer on receiver object and each intermediate object" do
      @foo.observe('bar.bar') {}
      @foo.observers[:bar].size.should == 1
      @bar.observers[:bar].size.should == 1
    end

    it "should call the handler when last attr path changes" do
      out = nil
      @foo.observe('bar.bar') { |val| out = val }

      @bar.bar = 42
      out.should == 42

      @bar.bar = 3.142
      out.should == 3.142
    end

    it "should return the passed in block" do
      proc = proc {}
      @foo.observe('bar.bar', &proc).should == proc
    end
  end
  
  describe "#unobserve" do
    it "should have no action if observer not setup for attr" do
      proc = proc {}
      @obj.unobserve :foo, proc
    end

    it "should have no action if the handler doesnt exist for the observed attr" do
      proc = proc {}
      @obj.observe :foo do; puts "other" end
      @obj.unobserve(:foo, proc)
    end

    it "should remove the handler for the given attribute" do
      count = 0
      proc  = proc { count += 1}
      @obj.observe(:foo, &proc)

      @obj.foo = 42
      count.should == 1

      @obj.unobserve(:foo, proc)
      @obj.foo = 42
      count.should == 1
    end
  end
end