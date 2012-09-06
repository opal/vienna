module ModelSpecs
  class User < Vienna::Model
    attribute :foo
    attribute :bar
    attribute :baz
  end
  
  class Page < Vienna::Model
    primary_key :title
  end
end

describe Vienna::Model do
  describe '.add' do
    before do
      ModelSpecs::User.add(foo: 'Adam Beynon', id: 1)
      ModelSpecs::User.add(foo: 'Freddy', id: 2)
    end
    
    it "makes the model findable through the model id map" do
      ModelSpecs::User.id_map[1].foo.should == 'Adam Beynon'
      ModelSpecs::User.id_map[2].foo.should == 'Freddy'
    end
    
    it "adds many models if an array of models is passed in" do
      ModelSpecs::User.add(
        {foo: 'Foo', id: 51},
        {foo: 'Bar', id: 52},
        {foo: 'Baz', id: 53}
      )
    
      ModelSpecs::User.id_map[51].foo.should == 'Foo'
    end
  end

  describe '.attribute' do
    before do
      @model = ModelSpecs::User.new
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

  describe '.get' do
    before do
      ModelSpecs::User.add(id: 1, foo: 'Woosh')
      ModelSpecs::User.add(id: 2, foo: 'Kapow')
    end

    it 'returns the model instance with the given id' do
      ModelSpecs::User.get(1).foo.should == 'Woosh'
      ModelSpecs::User.get(2).foo.should == 'Kapow'
    end

    it 'returns nil when no record found with matching id' do
      ModelSpecs::User.get(3).should be_nil
    end
  end

  describe '.get!' do
    before do
      ModelSpecs::User.add(id: 1, foo: 'Woosh')
      ModelSpecs::User.add(id: 2, foo: 'Kapow')
    end
    
    it "returns the model with the given primary key" do
      ModelSpecs::User.get!(1).foo.should == 'Woosh'
      ModelSpecs::User.get!(2).foo.should == 'Kapow'
    end
    
    it "raises an error if the given record is not found" do
      lambda {
        ModelSpecs::User.get!(42)
      }.should raise_error(Exception)
    end
  end
  
  describe '.inherited' do
    it 'creates the attributes hash' do
      ModelSpecs::User.attributes.should be_kind_of(Hash)
    end
  end
  
  describe '.primary_key' do
    it 'returns the set primary_key when given no arguments' do
      ModelSpecs::User.primary_key.should == :id
      ModelSpecs::Page.primary_key.should == :title
    end
  end
  
  describe '#id' do    
    it "returns the id attribute or nil if not set" do
      ModelSpecs::User.new.id.should == nil
      ModelSpecs::User.new(id: 42).id.should == 42
    end
    
    it "returns the attribute set by a custom primary_key" do
      ModelSpecs::Page.new.id.should == nil
      ModelSpecs::Page.new(title: 200).id.should == 200
    end
  end

  describe '#initialize' do
    it 'with no given attributes leaves all attributes as nil' do
      obj = ModelSpecs::User.new
      obj[:foo].should be_nil
      obj[:bar].should be_nil
      obj[:baz].should be_nil
    end
    
    it 'sets given attributes' do
      obj = ModelSpecs::User.new foo: 3.142
      obj[:foo].should == 3.142
      obj[:bar].should be_nil
      obj[:baz].should be_nil
    end
    
    it 'sets multiple given attributes' do
      obj = ModelSpecs::User.new foo: 'hello', bar: 'world', baz: 42
      obj[:foo].should == 'hello'
      obj[:bar].should == 'world'
      obj[:baz].should == 42
    end
    
    it 'correctly setups @primary_key variable' do
      ModelSpecs::User.new.instance_variable_get(:@primary_key).should == :id
      ModelSpecs::Page.new.instance_variable_get(:@primary_key).should == :title
    end
  end
end