module ViewBuilder
  module Corekit
    def html_contents
      contents = []
      yield contents
      contents.join(' ').html_safe
    end

    def contents_tag(tag_name, options = {}, &block)
      self.content_tag tag_name, options do
        self.html_contents(&block)
      end
    end
  
    def currency_string(number)
      if number
        number_to_currency(number)
      else
        ''
      end
    end

    def date_string(date)
      if date
        I18n.l(date)
      else
        ''
      end
    end

    def percent_string(number)
      if number
        number_to_percentage(number, :precision => 2)
      else
        ''
      end
    end

    def time_string(time)
      if time
        I18n.l(time)
      else
        ''
      end
    end

    def safe_html_string(text)
      if text.is_a?(String)
        text.gsub(/\n/, "<br/>").html_safe
      else
        text.to_s
      end
    end
  end
end

