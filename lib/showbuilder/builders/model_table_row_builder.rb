require 'showbuilder/builders/template_methods'
require 'showbuilder/i18n_text'

module Showbuilder
  module Builders
    class ShowModelTableRowBuilder
      include Showbuilder::Builders::TemplateMethods
      include Showbuilder::I18nText

      attr_accessor :is_header
      attr_accessor :itext_base
      attr_accessor :model

      def initialize(template)
        @template = template
      end

      # show_text_column :number
      # show_text_column :sale, :number
      def show_text_column(*methods)
        return show_header_column(methods) if is_header

        content = get_methods_text_value(model, methods)
        content_tag :td, content, :class => 'text'
      end

      # show_currency_column :price
      # show_currency_column :product, :price
      def show_currency_column(*methods)
        return show_header_column(methods) if is_header

        content = get_methods_currency_value(model, methods)
        content_tag :td, content, :class => 'currency'
      end

      # show_percent_column :discount
      # show_percent_column :product, :discount
      def show_percent_column(*methods)
        return show_header_column(methods) if is_header

        content = get_methods_percent_value(model, methods)
        content_tag :td, content, :class => 'percent'
      end

      # show_time_column :create_at
      # show_time_column :sale, :create_at
      def show_time_column(*methods)
        return show_header_column(methods) if is_header

        content = get_methods_time_value(model, methods)
        content_tag :td, content, :class => 'time'
      end

      # show_date_column :create_at
      # show_date_column :sale, :create_at
      def show_date_column(*methods)
        return show_header_column(methods) if is_header

        content = get_methods_date_value(model, methods)
        content_tag :td, content, :class => 'date'
      end

      # show_text_link_column :number
      # show_text_link_column :sale, :number
      # show_text_link_column :sale, :number, :link => :sale
      # show_text_link_column :sale, :number, :link => [:sale, :customer]
      # show_text_link_column :sale, :number, :link => ->(book){ book_path(book) }
      def show_text_link_column(*methods)
        return show_header_column(methods) if is_header

        name = get_methods_text_value(model, methods)
        content_tag :td, :class => 'text' do
          show_column_link name, methods
        end
      end

      # show_date_link_column :create_at
      # show_date_link_column :sale, :create_at
      # show_date_link_column :sale, :create_at, :link => :sale
      # show_date_link_column :sale, :create_at, :link => [:sale, :customer]
      # show_date_link_column :sale, :create_at, :link => ->(book){ book_path(book) }
      def show_date_link_column(*methods)
        return show_header_column(methods) if is_header

        name = get_methods_date_value(model, methods)
        content_tag :td, :class => 'date' do
          show_column_link name, methods
        end
      end

      # show_time_link_column :create_at
      # show_time_link_column :sale, :create_at
      # show_time_link_column :sale, :create_at, :link => :sale
      # show_time_link_column :sale, :create_at, :link => [:sale, :customer]
      # show_time_link_column :sale, :create_at, :link => ->(book){ book_path(book) }
      def show_time_link_column(*methods)
        return show_header_column(methods) if is_header

        name = get_methods_time_value(model, methods)
        content_tag :td, :class => 'time' do
          show_column_link name, methods
        end
      end

      # show_currency_link_column :price
      # show_currency_link_column :product, :price
      # show_currency_link_column :product, :price,     :link => :product
      # show_currency_link_column :product, :price,     :link => [:sale, :customer]
      # show_currency_link_column :product, :create_at, :link => ->(book){ book_path(book) }
      def show_currency_link_column(*methods)
        return show_header_column(methods) if is_header

        name = get_methods_currency_value(model, methods)
        content_tag :td, :class => 'currency' do
          show_column_link name, methods
        end
      end

      private

      def show_header_column(methods = nil)
        text = ''
        if methods
          methods = Array.wrap(methods)
          methods = filter_methods_options(methods)
          text    = show_current_itext(methods)
        end
        content_tag :th, text
      end

      def show_column_link(name, methods)
        link_option = get_link_option(methods)
        show_model_link_to name, link_option
      end

      def get_link_option(methods)
        if methods.count == 1
          return model
        end

        link_methods = get_methods_option(methods, :link)

        case link_methods
        when Proc
          link_option = link_methods.call(model)
        when String, Symbol, Array
          link_option = call_object_methods(model, link_methods)
        when NIL
          link_option = model
        else
          raise 'Unknow type #{link_methods}.'
        end

        return link_option
      end

      def get_methods_text_value(model, methods)
        methods = filter_methods_options(methods)
        value   = call_object_methods(model, methods)
        value.to_s
      end

      def get_methods_date_value(model, methods)
        methods = filter_methods_options(methods)
        value   = call_object_methods(model, methods)
        date_string value
      end

      def get_methods_time_value(model, methods)
        methods = filter_methods_options(methods)
        value   = call_object_methods(model, methods)
        time_string value
      end

      def get_methods_currency_value(model, methods)
        methods = filter_methods_options(methods)
        value   = call_object_methods(model, methods)
        currency_string value
      end

      def get_methods_percent_value(model, methods)
        methods = filter_methods_options(methods)
        value   = call_object_methods(model, methods)
        percent_string value
      end

      def filter_methods_options(methods)
        case methods.last
        when Hash
          return methods[0..-2]
        else
          return methods
        end
      end

      def get_methods_option(methods, key)
        case methods.last
        when Hash
          return methods.last[key]
        else
          return nil
        end
      end

      def show_current_itext_base
        itext_base || controller_name.to_s.singularize
      end

    end
  end
end