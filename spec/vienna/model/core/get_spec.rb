describe "Vienna::Core.get" do
  before do
    @cls = Class.new do
      include Vienna::Model

      attribute :name
    end

    @cls.add(id: 1, name: 'Foo')
    @cls.add(id: 7, name: 'Bar')
  end

  it "returns the registered model with the given id" do
    @cls.get(1).name.should == 'Foo'
    @cls.get(7).name.should == 'Bar'
  end

  it "returns nil when no record exists with given primary key" do
    @cls.get(2).should == nil
  end
end

describe "Vienna::Core.get!" do
  before do
    @cls = Class.new do
      include Vienna::Model
      attribute :name
    end

    @cls.add(id: 1, name: 'Foo')
    @cls.add(id: 7, name: 'Bar')
  end

  it "returns the model with the given primary key" do
    @cls.get!(1).name.should == 'Foo'
    @cls.get!(7).name.should == 'Bar'
  end

  it "raises an error if the given record is not found" do
    lambda {
      @cls.get!(42)
    }.should raise_error(Exception)
  end
end