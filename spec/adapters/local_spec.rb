require 'spec_helper'
require 'vienna/adapters/local'

class SimpleLocalModel < Vienna::Model
  adapter Vienna::LocalAdapter
  attributes :name
end

describe Vienna::Model do
  let(:model) { SimpleLocalModel.new}

  before(:each) do
    SimpleLocalModel.reset!

    #resets local storage
    @storage = $global.localStorage
    @storage.setItem(model.class.name, nil)
  end

  describe "crud actions" do
    it "should create" do
      model.name = 'Bob'; model.save
      results = items
      results.count.should eq(1)
      results.first['name'].should eq('Bob')
    end

    it "should destroy" do
      model = SimpleLocalModel.create(name: 'Jim')
      model.destroy
      items.count.should eq(0)
    end

    it "should read" do
      model = SimpleLocalModel.create(name: 'Steve')
      fetched = SimpleLocalModel.find(model.id)
      fetched.name.should eq('Steve')
    end

    it "should update" do
      model = SimpleLocalModel.create(name: 'Allison')
      model.name = 'Jenny'; model.save
      items.first['name'].should eq('Jenny')
    end
  end

  def items
    data = @storage.getItem(model.class.name)
    JSON.parse(data)
  end

end
