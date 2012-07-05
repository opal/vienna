describe "Model.inherited" do
  it "should setup the @primary_key variable" do
    InheritedSpec::ModelA.instance_variable_get(:@primary_key).should == :id
  end
end