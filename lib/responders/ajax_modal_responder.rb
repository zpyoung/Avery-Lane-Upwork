module Responders::AjaxModalResponder
  def to_js
    begin
      if has_errors? && !controller.template_exists?([controller.controller_path, controller.action_name].join("/")) || options[:modal_template]
        ajax_modal_behavior
      else
        default_render
      end
    rescue ActionView::MissingTemplate
      ajax_modal_behavior
    end
    set_flash_message! if set_flash_message?
  end

  def ajax_modal_behavior
    case
    when get?
      render "common/ajax_modal/form", locals: { modal_template: options[:modal_template], headless_modal: options[:headless_modal] }
    when post? || patch? || put? || delete?
      if has_errors?
        render "common/ajax_modal/form", locals: { modal_template: options[:modal_template], headless_modal: options[:headless_modal] }
      elsif options[:refresh]
        render "common/ajax_modal/refresh"
      else
        render "common/ajax_modal/redirect", locals: { navigation_location: navigation_location }
      end
    end
  end

  def set_flash_now?
    false
  end
end