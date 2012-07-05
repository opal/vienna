describe "Model.primary_key" do
  it "should return the primary_key when given no argument" do
    ModelPrimaryKeySpecs::ModelA.primary_key.should == :id
    ModelPrimaryKeySpecs::ModelB.primary_key.should == :isbn
  end
end