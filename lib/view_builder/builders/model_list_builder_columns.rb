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

      def show_text_column(methods, &block)
        self.show_column(methods) do |model|
          self.content_tag(:td) do
            self.generate_column_text(model, methods, &block)
          end
        end
      end
      
      protected

      def generate_column_text(model, methods, &block)
        field = self.call_object_methods(model, methods)
        if block
          block.call(field)
        else
          field.to_s
        end
      end
    end
  end
end
