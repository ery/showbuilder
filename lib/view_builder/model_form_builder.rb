require 'view_builder/template_methods'

module Viewbuilder
  class ModelFormBuilder < ActionView::Helpers::FormBuilder
    include ViewBuilder::TemplateMethods
    include ViewBuilder::I18nText

    def show_text_input(field)
      self.show_field_core(field) do
        self.text_field(field, :class => 'xlarge', :id => 'xlInput')
      end
    end

    def show_email_input(field)
      self.show_field_core(field) do
        self.contents_tag(:div, :class => "input-append") do |contents|
          contents << self.email_field(field, :class => 'xlarge', :id => 'xlInput')
          contents << self.content_tag(:span, "@", :class => "add-on")
        end
      end
    end

    def show_password_input(field)
      self.show_field_core(field) do
        self.password_field(field, :class => 'xlarge', :id => 'xlInput')
      end
    end

    protected

    def show_field_core(field)
      self.contents_tag :div, :class => :clearfix do |contents|
        label_text = self.current_itext(field)
        contents << self.label(field, label_text)
        contents << self.content_tag(:div, :class => :input) do
          yield
        end
      end
    end

    def field_label(method, text_id = nil, option = {})
      text_id ||= method
      text = self.current_itext(text_id)
      self.label(method, text, option)
    end

    def current_text_group
      self.object.class.to_s.underscore
    end
    
  end
end
