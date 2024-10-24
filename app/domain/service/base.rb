# frozen_string_literal: true

module Service
  class Base
    attr_accessor :error_context

    def self.call(*args, **kwargs, &block)
      error_context = kwargs.delete(:error_context)
      s = new(*args, **kwargs)
      s.error_context = error_context

      s.before_call
      s.call(&block).tap do |_c|
        s.after_call
      end
    end

    include Virtus.model

    def before_call
    end

    def call
      raise StandardError, "This function must be overridden."
    end

    def after_call
    end
  end
end
