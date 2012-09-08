class TagHelperSpec
  include Vienna::TagHelper
  
  attr_reader :user

  def initialize
    @user = User.new('Adam Beynon', 26)
  end

  class User
    attr_reader :name, :age

    def initialize(name, age)
      @name = name
      @age  = age
    end
  end
end

describe Vienna::TagHelper do
  before do
    @obj = TagHelperSpec.new
  end
  
  describe '#text_field' do
    it 'creates simple input tag' do
      @obj.text_field(:user, :name).should == '<input id="user_name" name="user[name]" type="text" value="Adam Beynon" />'
    end
  end
  
  describe '#text_field_added' do
    it 'is called with the object, method and model attribute id' do
      result = nil
      @obj.define_singleton_method(:text_field_added) do |obj, meth, id|
        result = [obj, meth, id]
      end
      @obj.text_field(:user, :name)
      
      result.should == [@obj.user, :name, 'user_name']
    end
  end
end