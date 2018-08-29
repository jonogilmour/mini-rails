require "spec_helper"

describe "rendering view using real controller actions" do
  describe "rails app posts controller" do
    it "should render the post/show template" do
      request = Rack::MockRequest.new(Rails.application)
      response = request.get("/posts/show?id=1")

      expect(response.body).to include("<h1>A new post</h1>")
    end
  end
end