namespace "Averylane.Users", (exports) ->
  exports.initIndex = ->
    Averylane.Layout.initSearchField()
  
  exports.initForm = ->
    $("#ajax-modal select").select2()
    Averylane.Layout.initDateTimePicker()

