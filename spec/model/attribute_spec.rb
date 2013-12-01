require "spec_helper"

describe Vienna::Model do
  describe ".attribute" do
    let(:model) { User.new }

    it "should create a reader method for attribute" do
      expect(model).to respond_to(:foo)
    end

    it "should create a writer method for attribute" do
      expect(model).to respond_to(:foo=)
    end

    describe "writer" do
      it "sets value on model" do
        model.foo = 'Tommy'
        expect(model.foo).to eq('Tommy')
      end
    end
  end
end
