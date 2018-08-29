require "spec_helper"

describe ActiveSupport do

  describe "#search_for_file" do
    it "should return the full path to a file" do
      file = ActiveSupport::Dependencies.search_for_file("application_controller")
      expect(file).to eql "#{__dir__}/muffin_blog/app/controllers/application_controller.rb"
    end

    it "should return nil for unknown files" do
      file = ActiveSupport::Dependencies.search_for_file("unknown")
      expect(file).to be_nil
    end

    it "should leverage const_missing to auto-require files when an unknown constant is found" do
      expect(Post).not_to be_nil
    end
  end

end
