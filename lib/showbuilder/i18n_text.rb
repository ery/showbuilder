module Showbuilder
  module I18nText
    def show_current_itext(text_id, *args)
      case text_id
      when Array
        text_id = text_id.join('.')
      end

      if self.show_current_itext_base
        current_text_id = "#{self.show_current_itext_base}.#{text_id}" 
      else
        current_text_id = text_id
      end
      
      self.show_itext(current_text_id, *args)      
    end

    def show_current_itext_base
    end

    def show_itext(id, *args)
      I18n.t(id, *args)
    end
  end
end

