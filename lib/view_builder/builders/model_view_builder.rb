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
        self.show_text_filed(method) do |text|
          self.safe_html_string(text)
        end
      end

      def show_time(method)
        self.show_text_filed(method) do |text|
          self.time_string(text)
        end
      end

      def show_currency(method)
        self.show_text_filed(method) do |text|
          self.currency_string(text)
        end
      end

      def show_percent(method)
        self.show_text_filed(method) do |text|
          self.percent_string(text)
        end
      end

      # show_text_link :sale, :number
      # show_text_link :customer, :name
      def show_text_link(link_method, text_method)
        link_model = self.model.send(link_method)

        text = ""
        if link_model
          text = link_model.send(text_method)
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

      def options_td_class
        'span2'
      end

      def show_text_link_core(text, link_model)
        self.link_to(text, link_model)
      end

      def show_text_filed(method, &block)
        label = self.current_itext(method)
        content = self.model.send(method)
        content = block.call(content) if block
        self.show_text_filed_core(label, content)
      end

      def show_text_filed_core(label, content)
        self.contents_tag :tr do |contents|
          contents << self.content_tag(:td, label,    :class => self.options_td_class)
          contents << self.content_tag(:td, content,  :class => self.options_td_class)
        end
      end

      def current_text_group
        self.model.class.to_s.underscore
      end
    end
  end
end