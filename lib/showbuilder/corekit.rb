module Showbuilder
  module Corekit

    def html_contents
      contents = []
      result = yield contents

      if contents.count > 0
        return contents.join(' ').html_safe
      end

      if result.respond_to?(:html_safe)
        return result.html_safe
      end
    end

    def contents_tag(tag_name, options = {}, &block)
      self.content_tag tag_name, options do
        self.html_contents(&block)
      end
    end

    def divc(option_class, &block)
      contents_tag :div, :class => option_class , &block
    end

    def currency_string(number)
      if number
        number_to_currency(number)
      else
        ''
      end
    end

    def date_string(date)
      case date
      when Date
        I18n.l(date)
      when Time
        time = date
        date = time.to_date
        I18n.l(date)
      else
        date.to_s
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
