describe "Attributes.attribute" do
  before do
    @cls = Class.new do
      include Vienna::Model
      attribute :foo
      attribute :woosh
      attribute :kapow
    end

    @model = @cls.new
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

  it "should create getter/setters for each argument" do
    @model.woosh = 42
    @model.kapow = 3.142

    @model[:woosh].should == 42
    @model[:kapow].should == 3.142
  end
end