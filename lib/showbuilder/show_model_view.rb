require 'view_builder/builders/model_view_builder'

module ViewBuilder
  module ShowModelView    
    #
    # show_model_view @product do |view|
    #   view.show_text      :name
    #   view.show_time      :last_update
    #   view.show_currency  :price
    #   view.show_percent   :discount
    #   view.show_text_link :vendor, :name
    # end
    #
    # dependents:
    # text_group = @product.class.to_s.underscore
    # I18n.t("#{text_group}.number")
    # I18n.t("#{text_group}.name")
    # I18n.t("#{text_group}.price")
    #
    def show_model_view(model, &block)
      builder = ViewBuilder::Builders::ModelViewBuilder.new(model, self)
      builder.build_model_view(&block)
    end
  end
end
