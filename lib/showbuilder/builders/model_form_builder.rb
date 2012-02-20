require 'showbuilder/builders/template_methods'
require 'showbuilder/i18n_text'

module Showbuilder
  module Builders
    class ModelFormBuilder < ActionView::Helpers::FormBuilder
      include Showbuilder::Builders::TemplateMethods
      include Showbuilder::I18nText

      def show_text_input(method, options = {})
        self.show_method_input(method) do
          self.text_field(method, options)
        end
      end

      def show_email_input(method)
        self.show_method_input(method) do
          self.contents_tag(:div, :class => "input-append") do |contents|          
            contents << self.email_field(method, :class => :medium)
            contents << self.content_tag(:span, content_tag(:i, '', :class =>"icon-envelope"), :class => "add-on")
          end
        end
      end

      def show_password_input(method)
        self.show_method_input(method) do
          self.password_field(method, :class => 'xlarge')
        end
      end

      def show_memo_input(method)
        self.show_method_input(method) do
          self.text_area(method, :rows => 3, :cols => 40)
        end
      end

      def show_method_input(method, options = {})
        label_text = options[:label_text] || self.showbuilder_itext(method)
        self.contents_tag :div, :class => 'control-group' do |contents|          
          contents << self.label(method, label_text, :class => "control-label")
          contents << self.content_tag(:div, :class => 'controls') do
            yield
          end
        end
      end

      protected
      
      def showbuilder_itext_base
        self.object.class.to_s.underscore
      end
      
    end
  end
end