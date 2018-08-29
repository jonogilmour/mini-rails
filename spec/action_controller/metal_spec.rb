require "spec_helper"

describe ActionController::Metal do
  describe "#params" do
    it "should return the request.params hash" do
      metal = ActionController::Metal.new
      metal.request = {}
      allow(metal.request).to receive(:params) { { a: 1, b: 2 } }
      expect(metal.params).to eql({ a: 1, b: 2 })
    end

    it "should convert request.params keys to symbols" do
      metal = ActionController::Metal.new
      metal.request = {}
      allow(metal.request).to receive(:params) { { "a" => 1, "b" => 2 } }
      expect(metal.params).to eql({ a: 1, b: 2 })
    end
  end
end
