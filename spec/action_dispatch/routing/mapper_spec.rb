require "spec_helper"

describe ActionDispatch::Routing::Mapper do
  it "should assign the passed in value to @route_set" do
    mapper = ActionDispatch::Routing::Mapper.new(1)
    expect(mapper.instance_variable_get :@route_set).to eql 1
  end

  describe "#get" do
    it "should add a new GET route" do
      my_route = true # don't care about the object type
      allow(my_route).to receive(:add_route)
      mapper = ActionDispatch::Routing::Mapper.new(my_route)

      mapper.get "/foo", to: "bar#baz", as: "foo_bar"
      expect(my_route).to have_received(:add_route)
        .with("GET", "/foo", "bar", "baz", "foo_bar")
    end

    it "should default :as to nil" do
      my_route = true # don't care about the object type
      allow(my_route).to receive(:add_route)
      mapper = ActionDispatch::Routing::Mapper.new(my_route)

      mapper.get "/foo", to: "bar#baz"
      expect(my_route).to have_received(:add_route)
        .with("GET", "/foo", "bar", "baz", nil)
    end
  end

  describe "#root" do
    it "should add a new GET route to '/'" do
      mapper = ActionDispatch::Routing::Mapper.new(nil)
      allow(mapper).to receive(:get)

      mapper.root to: "bar#baz"
      expect(mapper).to have_received(:get)
        .with("/", to: "bar#baz", as: "root")
    end
  end

  describe "#resources" do
    it "should add a set of routes to a resource" do
      mapper = ActionDispatch::Routing::Mapper.new(nil)
      allow(mapper).to receive(:get)

      mapper.resources "foobars"
      expect(mapper).to have_received(:get)
        .with("/foobars", to: "foobars#index", 
            as: "foobars")
      expect(mapper).to have_received(:get)
        .with("/foobars/new", to: "foobars#new",
            as: "new_foobar")
      expect(mapper).to have_received(:get)
        .with("/foobars/show", to: "foobars#show",
            as: "foobar")
    end
  end
end
