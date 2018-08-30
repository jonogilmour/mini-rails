require "spec_helper"

describe ActionDispatch::Routing::RouteSet do

  before(:each) do
    allow(File).to receive(:read).and_return("foobar_routeset")
  end

  describe "#add_route" do
    it "should add a new route with a linked controller action" do
      routes = ActionDispatch::Routing::RouteSet.new
      route = routes.add_route "GET", "/posts", "posts", "index"

      expect(route.controller).to eql "posts"
      expect(route.action).to eql "index"
    end
  end

  describe "#find_route" do
    it "should return the route if present" do
      routes = ActionDispatch::Routing::RouteSet.new
      routes.add_route "GET", "/posts", "posts", "index"
      routes.add_route "POST", "/posts", "posts", "create"

      request = Rack::Request.new(
        "REQUEST_METHOD" => "POST",
        "PATH_INFO"      => "/posts"
      )
      route = routes.find_route(request)

      expect(route.controller).to eql "posts"
      expect(route.action).to eql "create"
    end
  end

  describe "#draw" do
    it "should allow adding routes via routing DSL" do
      routes = ActionDispatch::Routing::RouteSet.new
      routes.draw do
        get "/home", to: "home#index"
        root to: "posts#index"
        resources :posts
      end

      # Successes
      request = Rack::Request.new(
        "REQUEST_METHOD" => "GET",
        "PATH_INFO"      => "/posts/new"
      )
      route = routes.find_route(request)
      expect(route.controller).to eql "posts"
      expect(route.action).to eql "new"
      expect(route.name).to eql "new_post"

      request = Rack::Request.new(
        "REQUEST_METHOD" => "GET",
        "PATH_INFO"      => "/posts"
      )
      route = routes.find_route(request)
      expect(route.controller).to eql "posts"
      expect(route.action).to eql "index"
      expect(route.name).to eql "posts"

      request = Rack::Request.new(
        "REQUEST_METHOD" => "GET",
        "PATH_INFO"      => "/home"
      )
      route = routes.find_route(request)
      expect(route.controller).to eql "home"
      expect(route.action).to eql "index"

      request = Rack::Request.new(
        "REQUEST_METHOD" => "GET",
        "PATH_INFO"      => "/"
      )
      route = routes.find_route(request)
      expect(route.controller).to eql "posts"
      expect(route.action).to eql "index"
      expect(route.name).to eql "root"

      # Fails
      request = Rack::Request.new(
        "REQUEST_METHOD" => "POST",
        "PATH_INFO"      => "/foo"
      )
      expect(routes.find_route request).to be nil

      request = Rack::Request.new(
        "REQUEST_METHOD" => "POST",
        "PATH_INFO"      => "/home"
      )
      expect(routes.find_route request).to be nil
    end
  end

  describe "#call" do
    it "should return 200 if request is recognised" do
      routes = ActionDispatch::Routing::RouteSet.new
      routes.draw do
        resources :posts
        root to: "posts#index"
      end

      request = Rack::MockRequest.new(routes)

      expect(request.get("/posts/new").ok?).to be true
      expect(request.get("/posts").ok?).to be true
      expect(request.get("/posts/show?id=1").ok?).to be true
    end

    it "should 404 if request is not recognised" do
      routes = ActionDispatch::Routing::RouteSet.new
      routes.draw do
        get "/posts/new", to: "posts#new"
        root to: "posts#index"
      end

      request = Rack::MockRequest.new(routes)

      expect(request.get("/posts/create").not_found?).to be true
      expect(request.post("/").not_found?).to be true
    end
  end
end


describe ActionDispatch::Routing::Route do
  describe "#match?" do
    it "should return true if the request matches the route" do
      args = ["GET", "/home", "home", "index"]
      route = ActionDispatch::Routing::Route.new(*args)
      request = Rack::Request.new(
        "REQUEST_METHOD" => "GET",
        "PATH_INFO"      => "/home"
      )

      expect(route.match? request).to be true
    end

    it "should return false if the request method does not match the route" do
      args = ["GET", "/home", "home", "index"]
      route = ActionDispatch::Routing::Route.new(*args)
      request = Rack::Request.new(
        "REQUEST_METHOD" => "POST",
        "PATH_INFO"      => "/home"
      )

      expect(route.match? request).to be false
    end

    it "should return false if the request path does not match the route" do
      args = ["GET", "/home", "home", "index"]
      route = ActionDispatch::Routing::Route.new(*args)
      request = Rack::Request.new(
        "REQUEST_METHOD" => "GET",
        "PATH_INFO"      => "/posts"
      )

      expect(route.match? request).to be false
    end
  end

  describe "#dispatch" do
    it "should send the action to the right controller" do
      class HomeController < ActionController::Base
        def index
        end
      end

      args = ["GET", "/home", "home", :index]

      expect_any_instance_of(ActionController::Base).to receive(:process).with(:index)

      route = ActionDispatch::Routing::Route.new(*args)
      allow(route).to receive(:controller_class).and_return(HomeController)

      request = Rack::Request.new(
        "REQUEST_METHOD" => "GET",
        "PATH_INFO"      => "/posts"
      )
      route.dispatch(request)
    end
  end
end
