require 'showbuilder/builders/template_methods'
require 'showbuilder/i18n_text'

module Showbuilder
  module Builders
    class ModelFormBuilder < ActionView::Helpers::FormBuilder
      include Showbuilder::Builders::TemplateMethods
      include Showbuilder::I18nText

      def show_text_input(method, options = {})
        options ||= {}
        html_options = options[:html] || {}
        input_options = options[:input_options] || {}
        self.show_method_input(method, html_options) do
          self.text_field(method, input_options)
        end
      end

      def show_text_field(method)
        text = @object.send(method)

        self.show_method_input(method) do
          self.content_tag(:span, text, :class => "uneditable-input")
        end
      end

      def show_email_input(method)
        self.show_method_input(method) do
          self.contents_tag(:div, :class => "input-append") do |contents|
            contents << self.email_field(method, :class => :medium)
            contents << self.content_tag(:span, content_tag(:i, '', :class =>"icon-envelope"), :class => "add-on")
          end
        end
      end

      def show_password_input(method)
        self.show_method_input(method) do
          self.password_field(method, :class => 'input-large changes')
        end
      end

      def show_memo_input(method)
        self.show_method_input(method) do
          self.text_area(method, :rows => 5)
        end
      end

      def show_select_input(method, choices, lable, options = {}, html_options = {})
        self.show_method_input(method, :label_text => lable) do
          self.select(method, choices, options, html_options)
        end
      end

      def show_method_input(method, options = {})
        label_text = options[:label_text] || self.show_current_itext(method)
        div_options = options[:class] || ''

        if object.errors.count > 0 and object.errors[method].count > 0
          div_options = " error"
        end

        self.contents_tag :div, :class => "control-group #{div_options}" do |contents|
          contents << self.label(method, label_text, :class => "control-label")
          contents << self.content_tag(:div, :class => 'controls') do
            yield
          end
        end
      end

      protected

      def show_current_itext_base
        self.object.class.to_s.underscore
      end

    end
  end
end