module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = I18n.t('community_name')
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # Returns viewport meta tag to ensure proper rendering and touch zooming
  def mobile_first_viewport_meta_tag
    if protect_against_forgery?
      [
          tag("meta", name: "viewport", content: 'width=device-width, initial-scale=1')
      ].join("\n").html_safe
    end
  end
end
