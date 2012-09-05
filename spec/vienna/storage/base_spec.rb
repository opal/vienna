module BaseStorageSpec
  class Custom < Vienna::BaseStorage; end
  class OtherStorage < Vienna::BaseStorage; end
  
  class User; include Vienna::Model; end
  class Page; include Vienna::Model; end
end

describe Vienna::BaseStorage do
  describe ".inherited" do
    it "registers the storage class as underscore version of name, removing 'Storage' prefix" do
      Vienna::BaseStorage[:custom].should == BaseStorageSpec::Custom
      Vienna::BaseStorage[:other].should == BaseStorageSpec::OtherStorage
    end
    
    it "doesn't register subclasses without a name" do
      Class.new(Vienna::BaseStorage) # raises error if not working..
    end
  end
  
  describe "#add_model" do
    before do
      @store = Vienna::BaseStorage.new
      @store.add_model BaseStorageSpec::User
      @store.add_model BaseStorageSpec::Page
    end

    it "adds the model to the models hash, by underscoring the model name" do
      @store.models[:user].should == BaseStorageSpec::User
      @store.models[:page].should == BaseStorageSpec::Page
    end
    
    it "sets the storage property of the model class to be the store instance" do
      BaseStorageSpec::User.storage.should == @store
      BaseStorageSpec::Page.storage.should == @store
    end
  end
end