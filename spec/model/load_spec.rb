require 'spec_helper'

describe Vienna::Model do
  describe "#load" do

    let(:model) { SimpleModel.new }

    it "marks the model instance as loaded" do
      model.load({})
      model.loaded?.should be_true
    end

    it "marks the model as not being a new record" do
      model.load({})
      model.new_record?.should be_false
    end
  end
end
