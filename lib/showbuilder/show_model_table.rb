require 'showbuilder/builders/model_table_row_builder'
require 'showbuilder/sequence_manager'

module Showbuilder
  module ShowModelTable

    #
    # = show_model_table @sale do |row|
    #  = row.show_date_link_column     :created_at
    #  = row.show_text_link_column     :number
    #  = row.show_text_link_column     :customer, :name, :link => :customer
    #  = row.show_currency_link_column :total
    #
    def show_model_table(models, itext_base = nil, &block)
      contents_tag(:table, :class => "table table-bordered table-striped") do |contents|
        contents << show_model_table_header(itext_base, &block)
        contents << show_model_table_body(models, &block)
      end
    end

    def show_model_table_header(itext_base, &block)
      content_tag :thead do
        show_model_table_header_row itext_base, &block
      end
    end

    def show_model_table_body(models, &block)
      SequenceManager.initialize_sequence(params)

      contents_tag :tbody do |contents|
        models.each do |model|
          contents << show_model_table_body_row(model, &block)
        end
        contents << show_model_table_no_record_row(block) if models.count == 0
      end
    end

    def show_model_table_no_record_row(block)
      column_count = get_show_model_table_column_count(block)
      content_tag :tr do
        content_tag :td, :colspan => column_count do
          show_itext 'no_record'
        end
      end
    end

    def show_model_table_header_row(itext_base, &block)
      row            = Showbuilder::Builders::ShowModelTableRowBuilder.new(self)
      row.is_header  = true
      row.itext_base = itext_base

      content_tag :tr do
        capture row, &block
      end
    end

    def show_model_table_body_row(model, &block)
      row           = Showbuilder::Builders::ShowModelTableRowBuilder.new(self)
      row.is_header = false
      row.model     = model

      content_tag :tr do
        capture row, &block
      end
    end

    def get_show_model_table_column_count(block)
      row = Object.new
      class << row
        attr_accessor :column_count

        def increament_column_count
          self.column_count ||= 0
          self.column_count += 1
        end

        def method_missing(meth, *args, &block)
          if meth.to_s =~ /^show_(.+)_column$/
            self.increament_column_count
          else
            super
          end
        end
      end

      capture row, &block

      return row.column_count
    end

  end
end