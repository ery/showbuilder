require 'view_builder/template_methods'

module Viewbuilder
  class ModelViewBuilder
    include ViewBuilder::TemplateMethods

    attr_reader :model

    def initialize(model, template)
      @model = model
      @template = template
    end

    def show_text(method)
      self.show_text_filed(method) do |text|
        self.safe_html_string(text)
      end
    end

    def show_time(method)
      self.show_text_filed(method) do |text|
        self.time_string(text)
      end
    end

    def show_currency(method)
      self.show_text_filed(method) do |text|
        self.currency_string(text)
      end
    end

    def show_percent(method)
      self.show_text_filed(method) do |text|
        self.percent_string(text)
      end
    end

    # row.show_text_to :sale, :number
    # row.show_text_to :contact, :name
    # row.show_text_to :unit, :name
    def show_text_link(link_method, text_method)
      link_model = self.model.send(link_method)

      text = ""
      if link_model
        text = link_model.send(text_method) 
        text = self.safe_html_string(text)
      end

      label   = self.show_i18n_text("#{link_method}.#{text_method}")
      content = self.show_text_link_core(text, link_model)
      self.show_text_filed_core(label, content)
    end

    def show_view_header
      self.content_tag :thead do
        view_header = self.show_i18n_text('view_header')
        self.content_tag :tr do
          self.content_tag(:th, view_header)
        end
      end
    end

    protected

    def show_text_link_core(text, link_model)
      self.link_to(text, link_model)
    end
    
    def show_text_filed(method, &block)
      label = self.show_i18n_text(method)
      content = self.model.send(method)
      content = block.call(content) if block
      self.show_text_filed_core(label, content)
    end

    def show_text_filed_core(label, content)
      self.contents_tag :tr do |contents|
        contents << self.content_tag(:td, label,    :class => self.show_text_filed_td_option_class)
        contents << self.content_tag(:td, content,  :class => self.show_text_filed_td_option_class)
      end
    end

    def show_i18n_text(text_id)
      text_group =  self.model.class.to_s.underscore
      I18n.t("#{text_group}.#{text_id}")
    end

    def show_text_filed_td_option_class
      'span2'
    end
  end
end
