require 'showbuilder/corekit'
require 'showbuilder/show_model_view'
require 'showbuilder/show_model_form'
require 'showbuilder/show_model_table'
require 'showbuilder/show_form'
require 'showbuilder/show_paginate_renderer'

module Showbuilder
  include Showbuilder::Corekit
  include Showbuilder::I18nText
  include Showbuilder::ShowModelView
  include Showbuilder::ShowModelForm
  include Showbuilder::ShowModelTable
  include Showbuilder::ShowForm

  def show_paginate_renderer
    Showbuilder::ShowPaginateRenderer
  end

  def show_form_button(text_id = nil, options = {})
    text_id                        ||= 'save'
    text                           = show_itext("form_button.#{text_id}")
    text_loading                   = show_itext("form_button.#{text_id}_loading")
    options                        ||= {}
    options[:class]                = "form-button btn #{options[:class]}"
    options[:'data-loading-text']  ||= text_loading
    options[:type]                 ||= :submit
    self.content_tag(:button, text, options)
  end

  def show_page_title
    self.content_tag :div, :class => 'page-header' do
      self.content_tag :h1 do
        self.show_current_itext("title_#{self.action_name}")
      end
    end
  end

  def show_alerts
    self.html_contents do |contents|
      self.flash.each do |name, message|
        contents << self.contents_tag(:div, :class => 'alert-message error') do |contents|
          contents << self.content_tag(:a, "x", :href => '#', :class => 'close')
          contents << self.content_tag(:p, message)
        end
      end
    end
  end

  def show_current_itext_base
    self.controller_name.to_s.singularize
  end

  def show_model_link_to(name, options)
    self.link_to name, options
  end

  ::ActionView::Base.send :include, self

  ::ActionView::Base.field_error_proc = proc do |html_tag, instance_tag|
    html_tag
  end

end
