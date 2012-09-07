module CollectionSpecs  
  class Model < Vienna::Model
    attribute :name
  end

  class Models < Vienna::Collection
    model Model
  end

  class Other < Vienna::Collection
  end
end

describe Vienna::Collection do
  before do
    @models = CollectionSpecs::Models.new
    @adam   = CollectionSpecs::Model.new name: 'Adam', id: 1
    @ben    = CollectionSpecs::Model.new name: 'Ben', id: 2
  end

  describe '.add' do
    it 'makes the model findable through id_map' do
      @models.add @adam
      @models.add @ben

      @models.id_map[1].should == @adam
      @models.id_map[2].should == @ben
    end

    it 'adds multiple models when passed array' do
      @models.add([@adam, @ben])
      @models.id_map[1].should == @adam
      @models.id_map[2].should == @ben
    end
  end

  describe '.get' do
    before do
      @models.add([@adam, @ben])
    end

    it 'returns the model instance with the given id' do
      @models.get(1).should == @adam
      @models.get(2).should == @ben
    end

    it 'returns nil when no record with matching id is found' do
      @models.get(42).should be_nil
    end
  end

  describe '.get!' do
    before do
      @models.add([@adam, @ben])
    end
    
    it "returns the model with the given primary key" do
      @models.get!(1).should == @adam
      @models.get!(2).should == @ben
    end
    
    it "raises an error if the given record is not found" do
      lambda {
        @models.get!(42)
      }.should raise_error(Exception)
    end
  end

  describe '#initialize' do
    it 'sets which Model subclass the collection uses' do
      CollectionSpecs::Models.new.model.should == CollectionSpecs::Model
      CollectionSpecs::Other.new.model.should == Vienna::Model
    end
  end
end