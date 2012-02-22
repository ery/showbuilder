require 'showbuilder/builders/template_methods'
require 'showbuilder/i18n_text'

module Showbuilder
  module Builders
    class ModelFormBuilder < ActionView::Helpers::FormBuilder
      include Showbuilder::Builders::TemplateMethods
      include Showbuilder::I18nText

      def show_text_input(method, options = {})
        options ||={}
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
          self.text_area(method, :rows => 3, :cols => 40)
        end
      end

      def show_select_field(method, include_blank = false, options = nil)
        method = method.to_s
        choices = @object.send("#{method}_names")
        show_select_by_number_field_core(method, choices, include_blank, options)
      end

      def show_select_by_number_field_core(method, choices, include_blank = false, html_options = nil)
        method_for_number = "#{method}_number"
        label_text = show_current_itext("#{method}.name")  

        self.show_method_input(method_for_number, :label_text => label_text) do
          self.select(method_for_number, choices, {:include_blank => include_blank}, html_options||{})
        end
      end

      def show_check_box_field(method, options = {})
        self.show_memo_input(method) do
          contents_tag(:label, :class => :checkbox) do |contents|
            contents << self.check_box(method, options)
            contents << self.content_tag(:span, self.controller_itext("#{method}_detail"))
          end
        end
      end

      def show_prepend_check_box_field(method,options = {})
        self.show_method_input(method) do
          contents_tag(:div, :class => "input input-prepend") do |contents|
            contents << content_tag(:label , :class => "add-on") do
              check_box(method, options)
            end
            contents << self.text_field(:discount_percent ,:class => 'discount', :placeholder => show_itext('product.discount_example'))
          end
        end
      end

      def show_check_box_list_field(name, method_list, label_options = {})
        self.show_method_input(name) do
          html_contents do |contents|
            method_list.each do |method|
              contents << self.show_check_box_list_field_item(method, label_options)
            end

          end
        end
      end

      def show_check_box_list_field_item(method, label_options = {})
        contents_tag(:label, label_options) do |contents|
          contents << self.check_box(method, options)
          contents << self.content_tag(:span, self.show_current_itext("#{method}_detail")) #method_label(method, "#{method}_detail")
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