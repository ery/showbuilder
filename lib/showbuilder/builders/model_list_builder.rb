require 'showbuilder/builders/template_methods'
require 'showbuilder/builders/model_list_builder/show_columns'
require 'showbuilder/i18n_text'

module Showbuilder
  module Builders
    class ModelListBuilder
      include Showbuilder::I18nText
      include Showbuilder::Builders::TemplateMethods
      include Showbuilder::Builders::ModelListBuilder::ShowColumns

      class Column
        attr_accessor :methods
        attr_accessor :build_body_column_method
        attr_accessor :build_header_column_method
      end

      attr_reader   :template
      attr_reader   :text_group
      attr_accessor :columns
      attr_accessor :table_options
      attr_accessor :body_row_options

      def initialize(template, text_group)
        @template = template
        @text_group = text_group
        self.columns = []
      end

      def build_model_list(models, &block)
        block.call(self)        
        self.table_options ||= {}
        self.table_options[:class] ||= ""
        self.table_options[:class] += " table table-bordered table-striped"

        contents_tag(:table, self.table_options) do |contents|
          contents << self.build_header
          contents << self.build_body(models)
        end
      end

      protected

      def build_header
        self.content_tag :thead do          
          self.contents_tag :tr do |contents|
            self.columns.each do |column|
              contents << self.build_header_column(column)            
            end
          end
        end
      end

      def build_header_column(column)
        if column.build_header_column_method
          column.build_header_column_method.call(column)
        else
          self.content_tag(:th) do 
            if column.methods            
              methods = Array.wrap(column.methods)
              methods = filter_method_option(methods)
              text_id = methods.join('.')
              self.showbuilder_itext(text_id)
            end
          end
        end
      end

      def build_body(models)
        models ||= []

        contents_tag :tbody do |contents|
          if models.count == 0
            contents << build_body_row_for_no_record
          else
            models.each do |model|
              contents << build_body_row(model)
            end
          end
        end
      end

      def build_body_row(model)
        options = self.build_body_row_options
        contents_tag(:tr, :class => "#{options}")do |contents|
          self.columns.each do |column|
            contents << self.build_body_column(column, model)
          end
        end
      end

      def build_body_row_options
        even = self.cycle('', 'even')
        self.body_row_options ||= {}
        self.body_row_options[:class] ||= ""
        self.body_row_options[:class] += " #{even}"
      end

      def build_body_row_for_no_record
        contents_tag :tr do |contents|
          self.columns.each_index do |index|
            contents << self.content_tag(:td) do
              itext('no_record') if index == 0
            end
          end
        end
      end

      def build_body_column(column, model)
        if column.build_body_column_method
          column.build_body_column_method.call(model)
        else
          self.tag(:td)
        end
      end

      def showbuilder_itext_base
        @text_group || self.controller_name.to_s.singularize
      end
    end
  end
end