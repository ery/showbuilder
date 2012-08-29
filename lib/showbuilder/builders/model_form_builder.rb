require 'showbuilder/builders/template_methods'
require 'showbuilder/i18n_text'

module Showbuilder
  module Builders
    class ModelFormBuilder < ActionView::Helpers::FormBuilder
      include Showbuilder::Builders::TemplateMethods
      include Showbuilder::I18nText

      def show_text_input(method, options = {})
        options ||= {}
        input_options = options[:input] || {}

        self.show_method_shell(method, options) do
          self.text_field(method, input_options)
        end
      end

      def show_text_field(method)
        text = @object.send(method)

        self.show_method_shell(method) do
          self.content_tag(:span, text, :class => "uneditable-input")
        end
      end

      def show_email_input(method)
        self.show_method_shell(method) do
          self.contents_tag(:div, :class => "input-append") do |contents|
            contents << self.email_field(method)
            contents << self.content_tag(:span, :class => "add-on") do
              content_tag(:i, '', :class =>"icon-envelope")
            end
          end
        end
      end

      def show_password_input(method)
        self.show_method_shell(method) do
          self.password_field(method)
        end
      end

      def show_memo_input(method)
        self.show_method_shell(method) do
          self.text_area(method, :rows => 5)
        end
      end

      def show_select_input(method, choices, options = {})
        options ||= {}

        select_options      = options[:select]      || {}
        select_html_options = options[:select_html] || {}

        show_method_shell method, options do
          select method, choices, select_options, select_html_options
        end
      end

      def show_method_shell(method, options = {}, &block)
        options ||= {}

        shell_options   = options[:shell] || {}
        label_options   = options[:shell_label] || {}
        label_content   = options[:shell_title] || show_current_itext(method)
        control_options = options[:shell_control] || {}

        shell_options[:class]   = merge_class_option(shell_options[:class], 'control-group')
        shell_options[:class]   = merge_class_option(shell_options[:class], 'error') if is_object_method_error(method)
        label_options[:class]   = merge_class_option(label_options[:class], 'control-label')
        control_options[:class] = merge_class_option(control_options[:class], 'controls')

        contents_tag :div, shell_options do |contents|
          contents << label(method, label_content, label_options)
          contents << contents_tag(:div, control_options, &block)
        end
      end

      private

      def show_current_itext_base
        object.class.to_s.underscore
      end

      def is_object_method_error(method)
        if object.errors.count == 0
          return false
        end

        if object.errors[method].count > 0
          return true
        else
          return false
        end
      end

    end
  end
end
