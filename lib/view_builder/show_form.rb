require 'view_builder/builders/form_builder'

module ViewBuilder
  module ShowForm
    def show_form(url, &block)
      self.form_tag url do
        builder = ViewBuilder::Builders::FormBuilder.new(self)
        self.capture(builder, &block)
      end
    end
  end
end

