require 'view_builder/corekit'
require 'view_builder/model_view_builder'
require 'view_builder/model_form_builder'
require 'view_builder/form_builder'

module Viewbuilder
  include ViewBuilder::Corekit
  include ViewBuilder::I18nText

  #
  # show_model_view @product do |view|
  #   view.show_text      :number
  #   view.show_text      :name
  #   view.show_currency  :price
  #   view.show_percent   :discount
  #   view.show_text_link :vendor, :name
  #   view.show_time      :last_update
  # end
  #
  # dependents:
  # text_group = @product.class.to_s.underscore
  # I18n.t("#{text_group}.number")
  # I18n.t("#{text_group}.name")
  # I18n.t("#{text_group}.price")
  #
  def show_model_view(model, &block)
    return unless model

    view = Viewbuilder::ModelViewBuilder.new(model, self)
    content_tag(:table, :class => view.options_table_class) do
      capture(view, &block)
    end
  end

  #
  # show_model_form @customer do |form|
  #   form.show_text                  :number
  #   form.show_text_input            :name
  #   form.show_email_input           :email
  #   form.show_password_input        :password
  #   form.show_memo_input            :memo
  #   form.show_date_time_input       :time
  #   form.show_select_input          :categorys
  #   form.show_checkbox_input        :x_field
  #   form.show_checkbox_input_list   :x_field
  # end
  #
  # dependents:
  # text_group = @customer.class.to_s.underscore
  # I18n.t("#{text_group}.number")
  # I18n.t("#{text_group}.name")
  # I18n.t("#{text_group}.email")
  # I18n.t("#{text_group}.password")
  # I18n.t("#{text_group}.form_button")
  # I18n.t("#{text_group}.form_button_loading")
  #
  def show_model_form(model, &block)
    self.html_contents do |contents|
      contents << self.error_messages_for(model) || ""
      contents << self.form_for(model, :builder => Viewbuilder::ModelFormBuilder) do |form|
        capture(form, &block)
      end
    end
  end

  def show_form(url, &block)
    self.form_tag url do
      form = Viewbuilder::FormBuilder.new(self)
      self.capture(form, &block)
    end
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

  #
  # show_model_list @products do |list|
  #   list.show_column                :x_field
  #   list.show_text_column           :x_field
  #   list.show_currency_column       :x_field
  #   list.show_percent_column        :x_field
  #   list.show_date_column           :x_field
  #   list.show_time_column           :x_field
  #   list.show_text_link_column      :x_field
  #   list.show_currency_link_column  :x_field
  #   list.show_percent_link_column   :x_field
  #   list.show_date_link_column      :x_field
  #   list.show_time_link_column      :x_field
  # end
  #
  def show_model_list(model, &block)
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

  ::ActionView::Base.send :include, self
end
