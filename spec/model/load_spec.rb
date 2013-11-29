require 'spec_helper'

describe Vienna::Model do
  describe "#load" do
    let(:model) { SimpleModel.new }

    it "marks the model instance as loaded" do
      model.load({})
      expect(model).to be_loaded
    end

    it "marks the model as not being a new record" do
      model.load({})
      expect(model).to_not be_new_record
    end
  end
end
