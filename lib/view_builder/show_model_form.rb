require 'view_builder/builders/model_form_builder'

module ViewBuilder
  module ShowModelForm
    
    #
    # show_model_form @customer do |form|
    #   form.show_text_input            :name
    #   form.show_email_input           :email
    #   form.show_password_input        :password
    # end
    #
    # dependents:
    # text_group = @customer.class.to_s.underscore
    # I18n.t("#{text_group}.name")
    # I18n.t("#{text_group}.email")
    # I18n.t("#{text_group}.password")
    #
    def show_model_form(model, &block)
      self.html_contents do |contents|
        contents << self.error_messages_for(model) || ""
        contents << self.form_for(model, :builder => Viewbuilder::Builders::ModelFormBuilder) do |form|
          capture(form, &block)
        end
      end
    end
  end
end