module Vienna
  
  module Filters

    def before(*paths,&blk)
      @before_filters ||= {}
      paths.each do |path|
        @before_filters[path] = [] if @before_filters[path].nil?
        @before_filters[path].push(blk)
      end
    end

    def exec_before_filters(path)
      unless @before_filters.nil?
        filters=@before_filters[path]
        unless filters.nil?
          filters.each {|blk| instance_eval(&blk) }
        end
      end
    end

  end


  class Router

    include Filters

    attr_accessor :params

    def initialize
      @routes={}
      @params={}
    end

    def define(&blk)
      instance_eval(&blk)
    end

    def hash=(url)
      `window.location.hash=#{url}`
    end

    def hash
      `window.location.hash`
    end


    def page(path,&blk)
      context=self
      %x{
        routie(#{path},function() {
               #{context.params=Hash.from_native(`this.params`)};
               #{context.exec_before_filters(path)};
               #{context.instance_eval(&blk)};
        });
      }
    end


    def redirect(path)
      `routie(#{path})`
    end

    alias goto redirect

  end
  
end