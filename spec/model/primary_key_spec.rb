describe "Model.primary_key" do
  before do
    @normal = Class.new(Vienna::Model)
    @custom = Class.new(Vienna::Model) { primary_key :isbn }
  end

  it "should return the primary_key when given no argument" do
    @normal.primary_key.should == :id
    @custom.primary_key.should == :isbn
  end
end