module ViewBuilder
  module Builders
    module ModelListBuilderColumns

      class Column
        attr_accessor :methods
        attr_accessor :generate_column_method
      end

      # show_text_column :number
      # show_text_column :member, :number
      def show_text_column(*methods)
        self.show_method_column(methods) do |value|
          self.safe_html_string(value)
        end
      end

      # show_text_link_column :number
      # show_text_link_column :member, :number
      def show_text_link_column(*methods)
        self.show_method_link_column(methods) do |value|
          self.safe_html_string(value)
        end
      end
      
      # show_time_column :created_at
      def show_time_column(*methods)
        self.show_method_column(methods) do |value|
          self.time_string(value)
        end
      end

      # show_date_column :created_at
      def show_date_column(*methods)
        self.show_method_column(methods) do |value|
          self.date_string(value)
        end
      end

      # show_date_link_column :created_at
      def show_date_link_column(*methods)
        self.show_method_link_column(methods) do |value|
          self.date_string(value)
        end
      end

      # show_currency_column :total
      def show_currency_column(*methods)
        self.show_method_column(methods) do |value|
          self.currency_string(value)
        end
      end

      # show_percent_column :percent
      def show_percent_column(*methods)
        self.show_method_column(methods) do |value|
          self.percent_string(value)
        end
      end

      def show_column(methods = nil, &block)
        column = Column.new
        column.methods = methods
        column.generate_column_method = block
        self.columns << column
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

      def show_method_link_column(methods, &block)
        case methods.count
        when 0
          raise 'show_method_link_column need a argument!'
        when 1
          link_method = nil
          text_method = methods.first
        else
          link_method = methods.first
          text_method = methods
        end

        get_link_object = lambda do |model|
          if link_method
            self.call_object_methods(model, link_method)
          else
            model
          end
        end

        get_link_name = lambda do |model, block|
          method_value = self.call_object_methods(model, text_method)
          if block
            text = block.call(method_value)
          else
            text = method_value
          end
          text.to_s
        end
        
        self.show_column(methods) do |model|
          self.content_tag(:td) do
            link_object = get_link_object.call(model)
            link_name   = get_link_name.call(model, block)
            self.link_to link_name, link_object            
          end
        end        
      end

    end
  end
end
