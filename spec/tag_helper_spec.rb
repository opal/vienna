class TagHelperSpec < Vienna::View
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
    @view = TagHelperSpec.new
    @user = TagHelperSpec::User.new('Adam Beynon', 26)
  end
  
  describe '#text_field' do
    it 'creates simple input tag' do
      # we don't know text field's id, so we must sub it from string..
      @view.text_field(@user, :name).sub(/\sid="[^"]*"/, '').should == '<input type="text" value="Adam Beynon" />'
    end
  end
end