module ViewBuilder
  module Builders
    module ModelListBuilderColumns

      class Column
        attr_accessor :methods
        attr_accessor :generate_column_method
      end

      def show_column(methods = nil, &block)
        column = Column.new
        column.methods = methods
        column.generate_column_method = block
        self.columns << column
      end

      def show_text_column(*methods)
        self.show_method_column(methods) do |value|
          self.safe_html_string(value)
        end
      end

      def show_text_link_column(*methods)
        case methods.count
        when 0
          raise 'show_text_link_column need a argument!'
        when 1
          link_method = nil
          text_method = methods.first
        else
          link_method = methods.first
          text_method = methods
        end
        
        self.show_column(methods) do |model|
          self.content_tag(:td) do
            if link_method
              method_link = self.call_object_methods(model, link_method)
            else
              method_link = model
            end            
            method_value = self.call_object_methods(model, text_method)
            self.link_to method_value.to_s, method_link            
          end
        end
      end
      
      def show_time_column(*methods)
        self.show_method_column(methods) do |value|
          self.time_string(value)
        end
      end

      def show_date_column(*methods)
        self.show_method_column(methods) do |value|
          self.date_string(value)
        end
      end

      def show_currency_column(*methods)
        self.show_method_column(methods) do |value|
          self.currency_string(value)
        end
      end

      def show_method_column(methods, &block)
        self.show_column(methods) do |model|
          self.content_tag(:td) do
            method_value = self.call_object_methods(model, methods)
            if block
              content = block.call(method_value)
            else
              content = method_value
            end
            content.to_s
          end
        end
      end
    end
  end
end
