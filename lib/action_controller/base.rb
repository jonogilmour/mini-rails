module ActionController
  class Base < Metal
    include Callbacks
    include RequestForgeryProtection
    include Redirecting
    include ActionView::Rendering
    include ImplicitRender
  end
end
