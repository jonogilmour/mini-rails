module ActionDispatch
  module Routing
    class Route < Struct.new(:method, :path, :controller, :action, :name)
      def match?(request)
        request.request_method == method &&
             request.path_info == path
      end

      def controller_class
        # Get the controller class constant from the controller string
        "#{controller.classify}Controller".constantize
      end

      def dispatch(request)
        # Create a new controller instance
        controller = controller_class.new
        # Set the request to the incoming request
        controller.request = request
        # Set the response to a new response
        controller.response = Rack::Response.new
        # Send the route action to the controller
        controller.process(action)
        # Converts the response into an array of status, headers, body
        controller.response.finish
      end
    end
    class RouteSet
      def initialize
        @routes = []
      end

      def add_route(*args)
        route = Route.new(*args)
        @routes << route
        route
      end

      def find_route(request)
        @routes.detect { |route| route.match?(request) }
      end

      def draw(&block)
        mapper = Mapper.new(self)
        # Call the block in the context of mapper
        mapper.instance_eval(&block)
      end

      def call(env)
        request = Rack::Request.new(env)

        if route = find_route(request)
          route.dispatch(request)
        else
          [
            404,
            { "Content-Type" => "text/plain" },
            [ "404 Not Found" ]
          ]
        end
      end
    end
  end
end
