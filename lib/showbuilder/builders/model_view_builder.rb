require 'showbuilder/builders/template_methods'
require 'showbuilder/i18n_text'

module Showbuilder
  module Builders
    class ModelViewBuilder
      include Showbuilder::Builders::TemplateMethods
      include Showbuilder::I18nText

      attr_reader :model

      def initialize(model, template)
        @model      = model
        @template   = template
      end

      def build_model_view(&block)
        unless @model
          return
        end
        self.content_tag(:table, :class => "table table-bordered nohead") do
          @template.capture(self, &block)
        end
      end

      def show_text(*methods)
        self.show_method_field(*methods) do |value|
          self.safe_html_string(value)
        end
      end

      # def show_text_link(link_method, text_method)
      #   methods      = [link_method, text_method]
      #   method_label = self.show_current_itext(methods)
      #   method_value = self.call_object_methods(model, methods)
      #   method_link  = self.call_object_methods(model, link_method)

      #   self.contents_tag :tr do |contents|
      #     contents << self.content_tag(:td, method_label.to_s)
      #     contents << self.content_tag(:td) do
      #       self.show_model_link_to(method_value.to_s, method_link)
      #     end
      #   end
      # end

      def show_text_link(*args)

       link_to_self args

       link_to_special args

       link_to_last_second args

     else raise "Parameter must be Symbols"
        # if args.count == 1
        #   if args.first.is_a?(Symbol)
        #     methods     = args
        #     link_method = :self
        #     return create_link methods, link_method
        #   else
        #     raise "Parameter must be a Symbol"
        #   end
        # end

        # if args.last.is_a?(Hash)
        #   if args.last[:link]
        #     methods     = args[0..-2]
        #     link_method = args.last[:link]
        #     return create_link methods, link_method
        #   else
        #     raise 'Hash key must be ":link"'
        #   end
        # end

        # args.each do |item|
        #   raise "Parameter must be Symbols" unless item.is_a?(Symbol)
        # end

        # methods      = args
        # link_method  = args[-2]
        # create_link methods, link_method
      end

      def link_to_self(args)
        if args.count == 1
          if args.first.is_a?(Symbol)
            methods     = args
            link_method = :self
            return create_link methods, link_method
          else
            raise "Parameter must be a Symbol"
          end
        end
      end

      def link_to_special(args)
        if args.last.is_a?(Hash)
          if args.last[:link]
            methods     = args[0..-2]
            link_method = args.last[:link]
            return create_link methods, link_method
          else
            raise 'Hash key must be ":link"'
          end
        end
      end

      def link_to_last_second(args)
        methods      = args
        link_method  = args[-2]
        create_link methods, link_method
      end

      def create_link(methods, link_method)
        method_label = self.show_current_itext(methods)
        method_value = self.call_object_methods(model, methods)
        method_link  = self.call_object_methods(model, link_method)

        self.contents_tag :tr do |contents|
          contents << self.content_tag(:td, method_label.to_s)
          contents << self.content_tag(:td) do
            self.show_model_link_to(method_value.to_s, method_link)
          end
        end
      end

      def show_time(method)
        self.show_method_field(method) do |value|
          self.time_string(value)
        end
      end

      def show_date(method)
        self.show_method_field(method) do |value|
          self.date_string(value)
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

      def show_method_field(*method, &block)
        method_label = self.show_current_itext(method)
        method_value = self.call_object_methods(model, method)
        if block
          method_value = block.call(method_value)
        end

        self.contents_tag :tr do |contents|
          contents << self.content_tag(:td, method_label.to_s)
          contents << self.content_tag(:td, method_value.to_s)
        end
      end

      protected

      def show_current_itext_base
        self.model.class.to_s.underscore
      end
    end
  end
end