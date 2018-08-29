# Integration testing between
# mini-rails and rails app for
# action_controller

require "spec_helper"

describe PostsController do
  describe "#before_action" do
    it "should not call the method for #index" do
      posts_controller = PostsController.new
      allow(posts_controller).to receive(:set_post)
      posts_controller.process :index
      expect(posts_controller).not_to have_received(:set_post)
    end

    it "should call the method for #show" do
      posts_controller = PostsController.new
      allow(posts_controller).to receive(:set_post)
      posts_controller.process :show
      expect(posts_controller).to have_received(:set_post)
    end
  end

  describe "#set_post" do
    it "should set @post" do
      posts_controller = PostsController.new
      allow(posts_controller).to receive(:params) { {id: 1} }
      posts_controller.send :set_post
      expect(posts_controller.instance_variable_get(:@post).id).to eql(1)
    end
  end
end
