require 'view_builder/builders/form_builder'

module ViewBuilder
  module ShowForm
    def show_form(url, &block)
      self.form_tag url do
        form = Viewbuilder::Builders::FormBuilder.new(self)
        self.capture(form, &block)
      end
    end
  end
end

