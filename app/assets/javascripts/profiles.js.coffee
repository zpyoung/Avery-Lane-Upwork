namespace "Averylane.Profiles", (exports) ->
  exports.initForm = ->
    password_fields = $(".form-group.user_password, .form-group.user_password_confirmation")
    unless password_fields.hasClass("has-error")
      password_fields.addClass("hidden")
    $("#change_password_link").click ->
      password_fields.toggleClass("hidden")
      false

