module Vienna
  class ViewRenderer

    def initialize(tag, options={})
      @tag      = tag
      @children = []
      @classes  = []
      @options  = options
    end
    
    def <<(str)
      @children << str
    end

    def add_class(class_name)
      @classes << class_name
    end

    def attr(name, value)
      @options[name] = value
    end
    
    alias :[]= :attr

    def id=(id)
      @id = id
    end
    
    def to_s
      open = [@tag]
      open << "id=\"#@id\"" if @id

      @options.each do |name, value|
        open << "#{name}=\"#{value}\""
      end

      open << "class=\"#{@classes.join ' '}\"" unless @classes.empty?

      opening  = open.join(' ')
      return "<#{opening} />" if @tag == :input

      children = @children.map(&:to_s).join('')
      "<#{opening}>#{children}</#{@tag}>"
    end
  end
end