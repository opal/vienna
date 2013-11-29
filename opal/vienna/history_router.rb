module Vienna
  class HistoryRouter
    attr_reader :path, :routes

    def initialize(&block)
      @routes = []
      @location = $global.location

      Window.on(:popstate) { update }

      instance_eval(&block) if block
    end

    def route(path, &handler)
      route = Router::Route.new(path, &handler)
      @routes << route
      route
    end

    def update
      path = if @location.pathname.empty?
                '/'
              else
                @location.pathname
              end

      unless @path == path
        @path = path
        match @path
      end
    end

    def match(path)
      @routes.find { |r| r.match path }
    end

    def navigate(path)
      `history.pushState(null, null, path)`
      update
    end
  end
end
