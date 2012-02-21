require 'showbuilder/corekit'
require 'showbuilder/show_model_view'
require 'showbuilder/show_model_form'
require 'showbuilder/show_model_list'
require 'showbuilder/show_form'
require 'showbuilder/show_paginate_renderer'

module Showbuilder
  include Showbuilder::Corekit
  include Showbuilder::I18nText
  include Showbuilder::ShowModelView
  include Showbuilder::ShowModelForm
  include Showbuilder::ShowModelList
  include Showbuilder::ShowForm

  def show_paginate_renderer
    Showbuilder::ShowPaginateRenderer
  end

  def show_form_button(text_id = nil, options = {})
    text_id                       ||= 'commit'
    text                          = I18n.t("form_button.#{text_id}")
    text_loading                  = I18n.t("form_button.#{text_id}_loading")
    options                       ||= {}
    options['class']              = "form-button btn btn-primary #{options[:class]}"
    options['data-loading-text']  = options['data-loading-text'] || text_loading
    options['type']               = options[:type] || :button
    self.content_tag(:button, text, options)
  end

  def show_page_title
    self.content_tag :div, :class => 'page-header' do
      self.content_tag :h1 do
        self.showbuilder_itext("title_#{self.action_name}")
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

  def showbuilder_itext_base
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

  def show_model_link_to(name, object)
    self.link_to name, object
  end

  ::ActionView::Base.send :include, self

  ::ActionView::Base.field_error_proc = proc do |html_tag, instance_tag|
    html_tag
  end
end
