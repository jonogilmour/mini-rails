require "spec_helper"

describe ActionView::Rendering do
  class TestController < ActionController::Base
    def index
      @var = "var value"
    end
  end

  describe '#view_assigns' do
    it "should return the controller instance variables as a hash" do
      controller = TestController.new
      controller.index
      expect(controller.view_assigns).to eql({ 'var' => 'var value' })
    end
  end

  describe '#render' do
    it "should get the path to the template" do
      controller = TestController.new
      controller.response = Rack::Response.new
      expect(controller).to receive(:template_path).with("show").and_return("path/to/show.html.erb")
      expect(ActionView::Template).to receive(:find).with("path/to/show.html.erb").and_return(ActionView::Template.new(nil, nil))

      # Stub render to as it shouldn't be called for real
      allow_any_instance_of(ActionView::Template).to receive(:render).and_return("foobar")

      controller.render("show")
    end

    it "should set the content to the response body" do

      controller = TestController.new
      controller.response = Rack::Response.new
      # Stub out render
      allow(controller).to receive(:template_path).and_return("path/to/show.html.erb")
      allow_any_instance_of(ActionView::Template).to receive(:render).and_return("foobar")
      allow(ActionView::Template).to receive(:find).and_return(ActionView::Template.new(nil, nil))

      expect(controller.response).to receive(:body=).with(["foobar"])

      controller.render("show")
    end
  end
end
