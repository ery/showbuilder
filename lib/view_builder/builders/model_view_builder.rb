require 'view_builder/builders/template_methods'
require 'view_builder/i18n_text'

module Viewbuilder
  module Builders
    class ModelViewBuilder
      include ViewBuilder::Builders::TemplateMethods
      include ViewBuilder::I18nText

      attr_reader :model

      def initialize(model, template)
        @model      = model
        @template   = template
      end

      def show_text(method)
        self.show_method_field(method) do |value|
          self.safe_html_string(value)
        end
      end

      def show_time(method)
        self.show_method_field(method) do |value|
          self.time_string(value)
        end
      end

      def show_currency(method)
        self.show_method_field(method) do |value|
          self.currency_string(value)
        end
      end

      def show_percent(method)
        self.show_method_field(method) do |value|
          self.percent_string(value)
        end
      end

      # show_text_link :sale, :number
      # show_text_link :customer, :name
      def show_text_link(link_method, text_method)
        link_model = self.call_object_methods(model, link_method)

        text = ""
        if link_model
          text = link_call_object_methods(model, text_method)
          text = self.safe_html_string(text)
        end

        label   = self.current_itext("#{link_method}.#{text_method}")
        content = self.show_text_link_core(text, link_model)
        self.show_text_filed_core(label, content)
      end

      def options_table_class
        "bordered-table"
      end
    
      protected

      def show_method_field(method, &block)
        label = self.current_itext(method)
        method_value = self.call_object_methods(model, method)
        if block
          method_value = block.call(method_value) 
        end
        self.show_filed(label, method_value)
      end

      def show_filed(label, content)
        self.contents_tag :tr do |contents|
          contents << self.content_tag(:td, label,    :class => self.options_td_class)
          contents << self.content_tag(:td, content,  :class => self.options_td_class)
        end
      end

      def show_text_link_core(text, link_model)
        self.link_to(text, link_model)
      end

      def options_td_class
        'span2'
      end

      def current_text_group
        self.model.class.to_s.underscore
      end
    end
  end
end