class BindingSpec
  include Vienna::Observable

  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

describe Vienna::Binding do
  before do
    @source  = BindingSpec.new 'adam'
    @target  = BindingSpec.new 'ben'
    @binding = Vienna::Binding.new(@source, :name, @target, :name)
  end

  it "gets the initial value for the binding" do
    @binding.value.should == 'adam'
  end

  it "syncs the binding value to the target object" do
    @target.name.should == 'adam'
  end

  it "syncs value changes from source to target" do
    @source.name = 'timmy'
    @target.name.should == 'timmy'
    @binding.value.should == 'timmy'
  end

  it "syncs value changes from target back to source" do
    @target.name = 'charles'
    @source.name.should == 'charles'
    @binding.value.should == 'charles'
  end
end