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

      def show_text_column(method)
        self.show_method_column(method) do |value|
          value.to_s
        end
      end
      
      def show_time_column(method)
        self.show_method_column(method) do |value|
          self.time_string(value)
        end
      end

      def show_currency_column(method)
        self.show_method_column(method) do |value|
          self.currency_string(value)
        end
      end
    
      protected

      def show_method_column(method, &block)
        self.show_column(method) do |model|
          self.content_tag(:td) do
            method_value = self.call_object_methods(model, method)
            if block
              block.call(method_value)
            end
          end
        end
      end
    end
  end
end
