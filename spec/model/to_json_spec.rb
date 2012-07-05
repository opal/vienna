describe "Model#to_json" do
  it "should return the json representation of the current attributes" do
    SimpleModelSpec.new.to_json.should == "{}"
  end
end