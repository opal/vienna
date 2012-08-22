class BindingSpec
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

describe "Binding.new" do
  before do
    @source  = BindingSpec.new 'adam'
    @target  = BindingSpec.new 'ben'
    @binding = Vienna::Binding.new(@source, :name, @target, :name)
  end

  it "should get the initial value for the binding" do
    @binding.value.should == 'adam'
  end

  it "should sync the binding value to the target object" do
    @target.name.should == 'adam'
  end

  it "should sync value changes from source to target" do
    @source.name = 'timmy'
    @target.name.should == 'timmy'
    @binding.value.should == 'timmy'
  end

  it "should sync value changes from target back to source" do
    @target.name = 'charles'
    @source.name.should == 'charles'
    @binding.value.should == 'charles'
  end
end