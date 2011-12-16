require 'view_builder/builders/template_methods'
require 'view_builder/builders/model_list_builder_columns'
require 'view_builder/i18n_text'

module ViewBuilder
  module Builders
    class ModelListBuilder
      include ViewBuilder::I18nText
      include ViewBuilder::Builders::TemplateMethods
      include ViewBuilder::Builders::ModelListBuilderColumns

      attr_reader   :template
      attr_reader   :text_group
      attr_accessor :columns

      def initialize(template, text_group)
        @template = template
        @text_group = text_group
        self.columns = []
      end

      def build_model_list(models, &block)
        block.call(self)
        
        contents_tag(:table, :class => 'bordered-table zebra-striped') do |contents|
          contents << self.generate_header
          contents << self.generate_body(models)
        end
      end

      protected

      def generate_header
        self.content_tag :thead do
          generate_header_row
        end
      end

      def generate_header_row
        contents_tag :tr do |contents|
          self.columns.each do |column|
            contents << self.content_tag(:th) do
              generate_header_column_text(column)
            end
          end
        end
      end

      def generate_header_column_text(column)
        unless column.methods
          return " "
        end

        methods = Array.wrap(column.methods)
        text_id = methods.join('.')
        self.current_itext(text_id)
      end

      def generate_body(models)
        models ||= []

        contents_tag :tbody do |contents|
          if models.count == 0
            contents << generate_body_row_for_no_record
          else
            models.each do |model|
              contents << generate_body_row(model)
            end
          end
        end
      end

      def generate_body_row(model)
        options = self.generate_body_row_options
        contents_tag(:tr, options)do |contents|
          self.columns.each do |column|
            contents << self.generate_body_row_column(column, model)
          end
        end
      end

      def generate_body_row_options
        even = self.cycle('', 'even')
        {:class => even}
      end

      def generate_body_row_for_no_record
        contents_tag :tr do |contents|
          self.columns.each_index do |index|
            contents << self.content_tag(:td) do
              itext('no_record') if index == 0
            end
          end
        end
      end

      def generate_body_row_column(column, model)
        if column.generate_column_method
          column.generate_column_method.call(model)
        else
          self.tag(:td)
        end
      end

      def current_text_group
        @text_group || self.controller_name.to_s.singularize
      end
    end
  end
end