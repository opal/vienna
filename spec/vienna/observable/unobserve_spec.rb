describe "Observable#unobserve" do
  before do
    @obj = Class.new do
      include Vienna::Observable

      attr_accessor :foo, :bar, :baz
      attr_reader :observers
    end.new
  end

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