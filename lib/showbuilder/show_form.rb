require 'showbuilder/builders/form_builder'

module Showbuilder
  module ShowForm
    def show_form(url, options = {}, &block)
      self.form_tag url, options do
        builder = Showbuilder::Builders::FormBuilder.new(self)
        self.capture(builder, &block)
      end
    end
  end
end

