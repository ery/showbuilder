require 'showbuilder/builders/model_form_builder'

module Showbuilder
  module ShowModelForm

    #
    # show_model_form @customer do |form|
    #   form.show_text_input            :name
    #   form.show_email_input           :email
    #   form.show_password_input        :password
    # end
    #
    # dependents:
    # puts @customer.class.to_s.underscore # customer
    # I18n.t('customer.name')
    # I18n.t("customer.email')
    # I18n.t('customer.password')
    #
    def show_model_form(models, options ={}, &block)
      models = Array.wrap(models)
      options.merge!(:builder => Showbuilder::Builders::ModelFormBuilder)
      self.form_for(models, options) do |form|
        self.html_contents do |contents|
          contents << self.error_messages_for(models.last)
          contents << capture(form, &block)
        end
      end
    end
    
    def error_messages_for(*objects)
      options = objects.extract_options!
      options[:header_message]  ||= show_itext("activerecord.errors.header", :default => "Invalid Fields")
      options[:message]         ||= show_itext("activerecord.errors.message", :default => "Correct the following errors and try again.")

      messages = objects.compact.map do |object| 
        object.errors.messages.map do |key, value|
          value
        end
      end
      messages.flatten!

      if messages.empty?
        return
      end

      contents_tag(:div, :class => "alert alert-error") do |contents|
        contents << content_tag(:a, 'x', :class=>'close' , "data-dismiss" => :alert)
        contents << content_tag(:h3, options[:header_message], :class => "alert-heading")
        contents << options[:message]
        contents << content_tag(:ul) do
          list_items = messages.map do |msg|
            content_tag(:li, msg)
          end
          list_items.join.html_safe
        end
      end
    end
  end
end