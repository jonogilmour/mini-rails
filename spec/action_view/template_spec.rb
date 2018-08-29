require "spec_helper"

describe ActionView::Template do
  describe "#render" do
    it "should render with the provided context" do
      template = ActionView::Template.new("<p>Hello</p>", "test_render_template")

      context = ActionView::Base.new
      expect(template.render(context)).to eql "<p>Hello</p>"
    end

    it "should pass variables to the template" do
      template = ActionView::Template.new("<p><%= @var %></p>", "test_render_with_vars")

      context = ActionView::Base.new var: "some value"
      expect(template.render(context)).to eql "<p>some value</p>"
    end

    it "should yield to child template" do
      template = ActionView::Template.new("<p><%= yield %></p>", "test_render_with_yield")

      context = ActionView::Base.new
      rendered = template.render(context) { "yielded content" }
      expect(rendered).to eql "<p>yielded content</p>"
    end
  end
end
