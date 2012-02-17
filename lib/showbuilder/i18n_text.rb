module Showbuilder
  module I18nText

    def current_itext(text_id, *args)
      case text_id
      when Array
        text_id = text_id.join('.')
      end

      if self.current_text_group
        current_text_id = "#{self.current_text_group}.#{text_id}" 
      else
        current_text_id = text_id
      end
      
      self.itext(current_text_id, *args)      
    end

    def current_text_group
    end

    def itext(id, *args)
      I18n.t(id, *args)
    end
  end
end

