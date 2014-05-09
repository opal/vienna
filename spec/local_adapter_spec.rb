require 'spec_helper'
require 'vienna/adapters/local'

class LocalModel < Vienna::Model
end

class LocalModelAdapter < Vienna::LocalAdapter
end

describe Vienna::LocalAdapter do
  describe "#create_record" do
    it "returns a promise resolved with new record" do
      promise = LocalModel.new.create
      promise.should be_a Promise
      promise.should be_resolved
      promise.value.should be_a LocalModel
    end

    it "marks record as not new" do
      model = LocalModel.new
      model.should be_new_record

      model.create
      model.should_not be_new_record
    end
  end
end
