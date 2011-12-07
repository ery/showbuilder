require 'view_builder/corekit'
require 'view_builder/model_view_builder'

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
  def show_model_view(model, &block)
    return unless model
    contents_tag(:table, :class => self.show_model_view_option_class) do |contents|
      builder = Viewbuilder::ModelViewBuilder.new(model, self)
      contents << builder.show_view_header
      contents << capture(builder, &block)
    end
  end

  def show_model_view_option_class
    "bordered-table"
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
  def show_model_form(model, &block)
  end

  ::ActionView::Base.send :include, self
end





