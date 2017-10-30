module ApplicationHelper
  def page_title(title)
    content_for :title do
      title.to_s
    end
    title.to_s
  end

  def page_title_content
    [content_for(:title), Rails.configuration.app_name].compact.join(" – ").html_safe
  end

  def paginate_description(scope)
    if scope.count > 0
      content = "Showing #{number_with_delimiter(scope.offset_value + 1)}–#{number_with_delimiter(scope.offset_value + scope.count)} of #{number_with_delimiter(scope.total_count)} #{"entry".pluralize(scope.total_count)}"
    else
      content = "There are no entries"
    end
    content_tag(:div, content, class: "text-muted pagination-description")
  end

  def ajax_modal_render(options)
    %{$("#ajax-modal-content").html("#{escape_javascript(render(options))}");}.html_safe
  end

  def replace_with_render(selector, *render_options)
     %{$("#{selector}").replaceWith("#{escape_javascript(render(*render_options))}");}.html_safe
  end

  def replace_content_with_render(selector, *render_options)
    %{$("#{selector}").html("#{escape_javascript(render(*render_options))}");}.html_safe
  end

  def append_with_render(selector, *render_options)
    %{$("#{selector}").append("#{escape_javascript(render(*render_options))}");}.html_safe
  end
  
  def show_flash
    if flash[:alert].present?
      raw %{$.notify("#{flash[:alert]}", { status: "danger" });}
    elsif flash[:notice].present?
      raw %{$.notify("#{flash[:notice]}", { status: "success" });}
    end
  end
  
  def editable_id(resource, attribute)
    ["editable", dom_id(resource), attribute].compact.join("_")
  end

  def editable(resource, attribute, url, as = nil)
    value = resource.send(attribute)
    if value.present? || value == false
      if as
        case as.to_sym
        when :date
          value = l(value)
        when :money
          value = number_to_currency(value)
        when :attribute_option
          value = resource.send(attribute.to_s + "_to_human")
        when :boolean
          value = value ? fa_icon("check", text: "Yes") : fa_icon("times", text: "No")
        when :percentage
          value = number_to_percentage(value, precision: 2)
        end
      end
    end
    html = content_tag(:span, value.present? || value == false ? value : "Edit", class: ["editable-link", ("blank" if value.blank?)].compact, data: { editable_attribute: attribute, editable_as: as, editable_url: url })
    html = content_tag(:span, html, class: "editable-value")
    html << content_tag(:div, nil, class: "editable-form")
    content_tag(:div, html, id: editable_id(resource, attribute), class: "editable")
  end
end
