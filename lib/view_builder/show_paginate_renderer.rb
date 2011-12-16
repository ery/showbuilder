require 'will_paginate'
require 'will_paginate/view_helpers/action_view'

module ViewBuilder
  class ShowPaginateRenderer < WillPaginate::ActionView::LinkRenderer
    def to_html
      links = @options[:page_links] ? windowed_links : []

      links.unshift(page_link_or_span(@collection.previous_page, 'prev', @options[:previous_label]))
      links.push(page_link_or_span(@collection.next_page, 'next', @options[:next_label]))

      html = links.join(@options[:link_separator])

      html_content = @template.content_tag(:div, :class => :pagination) do
        @template.content_tag(:ul, html.html_safe)
      end
      @options[:container] ? html_content : html
    end

    protected

    def windowed_links
      windowed_page_numbers.map { |n| page_link_or_span(n, (n == current_page ? 'active' : nil)) }
    end

    def page_link_or_span(page, span_class, text = nil)
      text ||= page.to_s
      if page == :gap
        text = gap_marker
      end
      if page && page != current_page && page != :gap
        page_link(page, text, :class => span_class)
      else if page == current_page || page == :gap
          page_span(page, text, :class => span_class)
        else
          previous_or_next_page(page)
        end
      end
    end

    def page_link(page, text, attributes = {})
      @template.content_tag(:li, attributes) do
        @template.link_to(text, url(page)).html_safe
      end
    end

    def page_span(page, text, attributes = {})
      @template.content_tag :li, attributes do
        @template.content_tag(:a, text)
      end
    end

    def gap_marker
      @template.will_paginate_translate(:page_gap) { '&hellip;' }
    end

    def previous_or_next_page(page)
      if @collection.current_page <= 1 && @collection.current_page - 1 <= 0
        page_span(page, "上一页", :class => "prev disabled")
      else if @collection.current_page <= @collection.total_pages && @collection.current_page + 1 >= @collection.total_pages
          page_span(page, "下一页", :class => "next disabled")
        end
      end
    end
  end
end
