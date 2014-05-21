require 'spec_helper'

describe Vienna::Model do
  describe '.adapter' do
    it 'raises an exception when no adapter defined on subclass' do
      expect {
        Class.new(Vienna::Model).adapter
      }.to raise_error(Exception, /No adapter for/)
    end

    it "accepts a given adapter subclass and sets it on subclass" do
      model = Class.new(Vienna::Model) do
        adapter Vienna::Adapter
      end

      expect(model.adapter).to be_kind_of(Vienna::Adapter)
      expect(model.adapter).to eq(model.adapter)
    end
  end
end
