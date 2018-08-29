module ActionController
  module Callbacks
    class Callback
      def initialize(method, options)
        @method = method
        @options = options
      end

      # Checks to see if the action (ie the controller method) we are trying to call has a method that should run before it.
      # DO run a callback if the action is in the callback's options.only
      # DO run the callback if it should be called before all actions
      # DONT run a callback if the action being called doesn't appear in the callback's options.only
      def match?(action)
        if @options[:only]
          @options[:only].include? action.to_sym
        else
          true
        end
      end

      def call(controller)
        controller.send @method
      end
    end
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def before_action(method, options = {})
        before_actions << Callback.new(method, options)
      end

      def before_actions
        @before_action ||= []
      end
    end

    def process(action)
      # Run all before-actions
      self.class.before_actions.each do |callback|
        callback.call self if callback.match? action
      end
      super
    end
  end
end
