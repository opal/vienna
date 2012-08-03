describe "Eventable#on" do
  before do
    @obj = EventableSpec.new
  end

  it "should register event handlers for given name" do
    handler = Proc.new {}
    @obj.on(:foo, &handler)
    @obj.events[:foo].should == [handler]
  end
end