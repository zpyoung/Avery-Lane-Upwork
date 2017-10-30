$.rails.allowAction = (element) ->
  message = element.data("confirm")
  return true unless message
  $link = element.clone()
  $link.removeAttr("class").removeAttr("data-confirm").addClass("btn").addClass("btn-danger").html("Confirm")
  $modal_html = $("#confirm-modal")
  $modal_html.find("span#confirm-modal-link").html($link)
  $modal_html.find(".modal-body").text(message)
  $modal_html.modal()
  $link.on "ajax:success", ->
    $modal_html.modal("hide")
  return false