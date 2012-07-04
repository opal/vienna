describe "Model.property" do
  before do
    @model = SimpleModelSpec.new
  end

  it "should create a getter and setter method for property" do
    @model.respond_to?(:foo).should be_true
    @model.respond_to?(:foo=).should be_true
  end

  it "should use the defined setter to set the attribute" do
    @model.foo = 'Hello'
    @model[:foo].should == 'Hello'

    @model.foo = 'World'
    @model[:foo].should == 'World'
  end
end