require 'view_builder/corekit'
require 'view_builder/show_model_view'
require 'view_builder/show_model_form'
require 'view_builder/show_model_list'
require 'view_builder/show_form'
require 'view_builder/show_paginate_renderer'

module Viewbuilder
  include ViewBuilder::Corekit
  include ViewBuilder::I18nText
  include ViewBuilder::ShowModelView
  include ViewBuilder::ShowModelForm
  include ViewBuilder::ShowModelList
  include ViewBuilder::ShowForm

  def show_paginate_renderer
    ViewBuilder::ShowPaginateRenderer
  end

  def show_form_button(text_id = nil)
    text_id                       ||= 'commit'
    text                          = I18n.t("form_button.#{text_id}")
    text_loading                  = I18n.t("form_button.#{text_id}_loading")
    options                       = {}
    options['class']              = "form-button btn primary"
    options['data-loading-text']  = text_loading
    options['type']               = :button
    self.content_tag(:button, text, options)
  end

  def show_page_title
    self.content_tag :div, :class => 'page-header' do
      self.content_tag :h1 do
        self.current_itext("title_#{self.action_name}")
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

  def current_text_group
    self.controller_name.to_s.singularize
  end

  def call_object_methods(object, methods)    
    unless object
      return
    end

    methods = Array.wrap(methods)
    if methods.count == 0
      return
    end

    first_method = methods.first
    unless first_method
      return
    end

    unless object.respond_to?(first_method)
      return
    end

    method_result = object.send(first_method)
    if methods.count <= 1
      return method_result
    else
      remaining_methods = methods.clone
      remaining_methods.shift
      return call_object_methods(method_result, remaining_methods)
    end
  end

  ::ActionView::Base.send :include, self
end
