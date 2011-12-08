require 'view_builder/corekit'
require 'view_builder/model_view_builder'
require 'view_builder/model_form_builder'

module Viewbuilder
  include ViewBuilder::Corekit

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
  # I18n.t("#{text_group}.view_header")
  # I18n.t("#{text_group}.number")
  # I18n.t("#{text_group}.name")
  # I18n.t("#{text_group}.price")
  #
  def show_model_view(model, &block)
    return unless model

    builder = Viewbuilder::ModelViewBuilder.new(model, self)
    contents_tag(:table, :class => builder.options_table_class) do |contents|
      contents << builder.show_view_header
      contents << capture(builder, &block)
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
  def show_model_form(model, options = {}, &block)
    options.merge!({:builder => Viewbuilder::ModelFormBuilder})
    self.html_contents do |contents|
      contents << self.error_messages_for(model) || ""
      contents << self.form_for(model, options) do |form|
        self.html_contents do |contents|
          contents << capture(form, &block)
          contents << form.show_model_form_button
        end
      end
    end
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

  ::ActionView::Base.send :include, self
end
