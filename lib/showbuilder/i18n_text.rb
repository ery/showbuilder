module Showbuilder
  module I18nText

    def showbuilder_itext(text_id, *args)
      case text_id
      when Array
        text_id = text_id.join('.')
      end

      if self.showbuilder_itext_base
        current_text_id = "#{self.showbuilder_itext_base}.#{text_id}" 
      else
        current_text_id = text_id
      end
      
      self.itext(current_text_id, *args)      
    end

    def showbuilder_itext_base
    end

    def itext(id, *args)
      I18n.t(id, *args)
    end
  end
end

