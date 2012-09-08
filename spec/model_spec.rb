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

ModelSpecs::User.add ModelSpecs::User.new(foo: 'adam', id: 1)
ModelSpecs::User.add ModelSpecs::User.new(foo: 'ben', id: 2)

ModelSpecs::User.add([ModelSpecs::User.new(foo: 'tom', id: 3),
                      ModelSpecs::User.new(foo: 'tim', id: 4)])

describe Vienna::Model do
  describe '.add' do
    it 'makes the model findable through id_map' do
      ModelSpecs::User.id_map[1].foo.should == 'adam'
      ModelSpecs::User.id_map[2].foo.should == 'ben'
    end

    it 'adds multiple models when passed an array' do
      ModelSpecs::User.id_map[3].foo.should == 'tom'
      ModelSpecs::User.id_map[4].foo.should == 'tim'
    end
  end

  describe '.get' do
    it 'returns the model instance with the given id' do
      ModelSpecs::User.get(1).foo.should == 'adam'
      ModelSpecs::User.get(2).foo.should == 'ben'
    end

    it 'returns nil when no record with matching id is found' do
      ModelSpecs::User.get(42).should be_nil
    end
  end

  describe '.get!' do
    it "returns the model with the given primary key" do
      ModelSpecs::User.get!(1).foo.should == 'adam'
      ModelSpecs::User.get!(2).foo.should == 'ben'
    end
      
    it "raises an error if the given record is not found" do
      lambda {
        ModelSpecs::User.get!(42)
      }.should raise_error(Exception)
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