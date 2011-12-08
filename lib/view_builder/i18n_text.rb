module ViewBuilder
  module I18nText

    def current_itext(text_id)
      crrent_text_id = text_id
      crrent_text_id = "#{self.current_text_group}.#{text_id}" if self.current_text_group
      self.itext(crrent_text_id)
    end

    def current_text_group
    end

    def itext(id, *args)
      I18n.t(id, *args)
    end
  end
end

