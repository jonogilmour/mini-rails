require "spec_helper"

describe ActionDispatch do
  describe "Routing middleware stack" do
    it "should route using the Rails application" do
      app = Rails.application

      request = Rack::MockRequest.new(app)

      expect(request.get("/").ok?).to be true
      expect(request.get("/posts").ok?).to be true
      expect(request.get("/posts/new").ok?).to be true
      expect(request.get("/posts/show?id=1").ok?).to be true

      expect(request.post("/").not_found?).to be true
    end

    it "should route static assets" do
      app = Rails.application

      request = Rack::MockRequest.new(app)
      
      expect(request.get("/favicon.ico").ok?).to be true
      expect(request.get("/assets/application.js").ok?).to be true
      expect(request.get("/assets/application.css").ok?).to be true

      expect(request.get("/assets/missing.css").not_found?).to be true
    end

  end
end
