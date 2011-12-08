require 'view_builder/template_methods'

module Viewbuilder
  class ModelFormBuilder < ActionView::Helpers::FormBuilder
    include ViewBuilder::TemplateMethods

    def show_text_input(method, field_options = {}, input_options = {})
      field_options[:class] = "#{field_options[:class]} clearfix"
      self.contents_tag :div, field_options do |contents|
        contents << self.field_label(method)
        contents << self.content_tag(:div, :class => :input) do
          self.text_field(method, input_options)
        end
      end
    end

    def show_email_input(method)
      self.contents_tag :div , :class => :clearfix do |contents|
        contents << self.field_label(method)
        contents << self.content_tag(:div, :class => :input) do
          self.contents_tag(:div, :class => "input-append") do |contents|
            contents << self.email_field(method, :class => :medium)
            contents << self.content_tag(:span, "@", :class => "add-on")
          end
        end
      end
    end

    def show_password_input(method)
      self.contents_tag :div, :class => :clearfix do |contents|
        contents << self.field_label(method)
        contents << self.content_tag(:div, :class => :input) do
          self.password_field(method)
        end
      end
    end

    def show_model_form_button()
      text_button         = I18n.t('form_button')
      text_button_loading = I18n.t('form_button_loading')

      options = {}
      options['class']              = "form-button btn primary"
      options['data-loading-text']  = text_button_loading
      options['type']               = :button

      self.content_tag(:button, text_button, options)
    end
    
    protected

    def field_label(method, text_id = nil, option = {})
      text_id ||= method
      text = self.current_itext(text_id)
      self.label(method, text, option)
    end

    def current_itext(text_id)
      text_group =  self.object.class.to_s.underscore
      I18n.t("#{text_group}.#{text_id}")
    end
  end
end
