require "spec_helper"

describe ActionController do

  class TestController < ActionController::Base
    before_action :show_callback, only: [:show]
    before_action :both_callback, only: [:show, :index]
    before_action :all_callback

    def index
    end

    def show
    end

    def any
    end

    def redirect
      redirect_to "/"
    end

    private
      def show_callback
      end

      def both_callback
      end

      def all_callback
      end
  end

  describe "#process" do
    it "should call the method given by the symbol" do
      controller = TestController.new
      allow(controller).to receive(:index)
      controller.process :index

      expect(controller).to have_received(:index)
    end
  end

  describe "#before_action" do
    it "should call the given method before any action" do
      controller = TestController.new
      allow(controller).to receive(:both_callback)
      allow(controller).to receive(:all_callback)
      allow(controller).to receive(:show_callback)
      controller.process :index

      expect(controller).to have_received(:both_callback).once
      expect(controller).to have_received(:all_callback).once
      expect(controller).not_to have_received(:show_callback)
    end

    it "should call the given method only before the given action" do
      controller = TestController.new
      allow(controller).to receive(:both_callback)
      allow(controller).to receive(:all_callback)
      allow(controller).to receive(:show_callback)
      controller.process :index
      controller.process :show

      expect(controller).to have_received(:both_callback).twice
      expect(controller).to have_received(:all_callback).twice
      expect(controller).to have_received(:show_callback).once
    end
  end

  describe "#redirect_to" do
    class Response
      attr_accessor :status, :location, :body
    end
    it "should set the response status, location, and body" do
      controller = TestController.new
      controller.response = Response.new
      controller.process :redirect

      expect(controller.response.status).to eql(302)
      expect(controller.response.location).to eql("/")
      expect(controller.response.body).to eql(["You are being redirected"])
    end
  end

end
