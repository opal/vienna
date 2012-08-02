module Vienna
  module Observable
    def get_attribute(name)
      if respond_to? name
        __send__ name
      elsif respond_to? "#{name}?"
        __send__ "#{name}?"
      end
    end
  end
end

class Object
  include Vienna::Observable
end