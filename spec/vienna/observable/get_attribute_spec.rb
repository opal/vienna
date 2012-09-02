describe "Observable#get_attribute" do
  before do
    @obj = Class.new do
      attr_accessor :foo, :bar
      attr_reader :first_name

      def initialize
        @foo = 'adam'
        @bar = 42
        @baz = 3.142
        @buz = 'omg'
      end

      def bar
        @bar
      end

      def baz
        @baz
      end

      def baz?
        'should not return this one'
      end

      def buz?
        @buz
      end
    end.new
  end

  it "should return attribute values for simple keys" do
    @obj.get_attribute(:foo).should == 'adam'
    @obj.get_attribute(:bar).should == 42
  end

  it "should check for boolean (foo?) accessors after normal getters" do
    @obj.get_attribute(:baz).should == 3.142
    @obj.get_attribute(:buz).should == 'omg'
  end

  it "should return nil for unknown attributes" do
    @obj.get_attribute(:fullname).should be_nil
    @obj.get_attribute(:pingpong).should be_nil
  end
end