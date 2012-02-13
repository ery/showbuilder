require 'showbuilder/builders/model_list_builder'

module Showbuilder
  module ShowModelList  
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
    # ---------------------------------------------------------------
    # Demo:
    # show_model_list @sale do |list|
    #   list.show_text_link_column :number
    # end
    #
    # Explain:
    #   text = sale.number
    #   link = link_to(sale)
    # ---------------------------------------------------------------
    #
    # ---------------------------------------------------------------
    # Demo:
    # show_model_list @sale do |list|
    #   list.show_text_link_column :member, :number
    # end
    #
    # Explain:
    #   text = sale.member.number
    #   link = link_to(sale.member)
    # ---------------------------------------------------------------
    #
    def show_model_list(models, text_group = nil, &block)
      builder = Showbuilder::Builders::ModelListBuilder.new(self, text_group)
      builder.build_model_list(models, &block)
    end    
  end
end
