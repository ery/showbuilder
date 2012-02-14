module Showbuilder
  module Builders
    class ModelListBuilder
      module ShowColumns

        # show_text_column :number
        # show_text_column :member, :number
        def show_text_column(*methods)
          self.show_method_column(methods) do |value|
            self.safe_html_string(value)
          end
        end

        # show_text_link_column :number
        # show_text_link_column :member, :number
        # show_text_link_column :member, :number, :link => :member
        # show_text_link_column :member, :number, :link => [:member, :department]
        def show_text_link_column(*methods)
          self.show_method_link_column(*methods) do |value|
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
          self.show_method_link_column(*methods) do |value|
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

        def show_method_link_column(*methods, &customize_link_name_block)
          if methods.count == 0
            raise 'show_method_link_column need a argument!'
          end

          self.show_column(methods) do |model|
            self.content_tag(:td) do
              link_object = self.show_method_link_column__get_link_object(model, methods)
              link_name   = self.show_method_link_column__get_link_name(model, methods, customize_link_name_block)
              self.show_model_link_to link_name, link_object
            end
          end
        end

        def show_method_link_column__get_link_object(model, methods)
          if methods.count == 1
            return model
          end          

          last_item = methods.last
          if last_item.is_a? Hash
            if last_item[:link]
              link_methods = last_item[:link]
              
              link_object = self.call_object_methods(model, link_methods)
              if model.is_a? Customer
                `echo "link methods is #{link_methods}" > ~/log`
                `echo "link object is #{link_object}" >> ~/log`
                `echo "model is #{model}" >> ~/log`
                `echo "model.category is #{model.category}" >> ~/log`
              end              
              
              return link_object
            end
          end

          return model
        end

        def show_method_link_column__get_link_name(model, methods, customize_link_name_block)
          if methods.last.is_a? Hash
            methods.pop
          end

          method_value = self.call_object_methods(model, methods)
          if customize_link_name_block
            link_name = customize_link_name_block.call(method_value)
          else
            link_name = method_value
          end
          link_name.to_s
        end

        def show_column(methods = nil, build_header_column_method = nil, &build_body_column_method)
          column = ModelListBuilder::Column.new
          column.methods = methods
          column.build_header_column_method = build_header_column_method
          column.build_body_column_method   = build_body_column_method
          self.columns << column
        end

      end
    end
  end
end