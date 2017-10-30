namespace "Averylane.Layout", (exports) ->
  exports.init = ->
    initAjaxModal()
    initSelect()
    initAutosubmit()
    initGetFormsTurbolinks()
    initEditable()

  initAjaxModal = ->
    $(document).on 'turbolinks:load', ->
      loadingContent = $("#ajax-modal-content").html()
      $ajaxModal = $("#ajax-modal").modal
        backdrop: "static"
        show: false
      $("#ajax-modal").on "hidden.bs.modal", ->
        $("#ajax-modal-content").html(loadingContent)
        $("#ajax-modal .modal-dialog").attr("class", "modal-dialog")
      $("#ajax-modal").on "shown.bs.modal", ->
        $("#ajax-modal input[data-autofocus]").first().focus()

    $(document).on "click", "[data-toggle=ajax-modal]", ->
      openAjaxModal = =>
        $this = $(this)
        $("#ajax-modal .modal-title").text($this.data("title"))
        if $this.data("class")
          $("#ajax-modal .modal-dialog").addClass($this.data("class"))
        $.getScript $this.attr("href"), ->
          $("#ajax-modal").trigger("ajaxmodalloaded")
        $("#ajax-modal").modal("show")
      if $("#ajax-modal").hasClass("in")
        $("#ajax-modal").modal("hide")
        $("#ajax-modal").one "hidden.bs.modal", openAjaxModal
      else
        openAjaxModal()
      false

  initAutosubmit = ->
    $(document).on 'turbolinks:load', ->
      exports.initAutosubmitCheckbox()

  exports.initAutosubmitCheckbox = ->
    $("input[type=checkbox]").on "change", ->
      if $(this).data("autosubmit")
        $(this).parents("form").submit()

  initSelect = ->
    $.fn.select2.defaults.set "theme", "bootstrap"
    $.fn.select2.defaults.set "width", "100%"
    $.fn.select2.defaults.set "placeholder", ""
    $.fn.select2.defaults.set "allowClear", true
    $.fn.select2.defaults.set "minimumResultsForSearch", 7
    $(document).on 'turbolinks:load', ->
      $("select").not("[data-ajax-select]").select2().on "change", ->
        if $(this).data("autosubmit")
          $(this).parents("form").submit()

  exports.initSearchField = (selector = ".search-field input") ->
    $(selector).on "input", $.debounce ->
      $(this).parents("form").submit()
    , 500

  exports.initAjaxSelect = ->
    $("select[data-ajax-select]").select2(
      minimumResultsForSearch: 0
      allowClear: true
      ajax:
        url: ->
          $(this).data("source-url")
        dataType: 'json'
        delay: 250
        data: (params) ->
          prms = { page: params.page }
          prms[$(this).data("search-term")] = params.term
          { q: prms}
        processResults: (data, params) ->
          params.page = params.page || 1;
          {
            results: data.items,
            pagination: {
              more: (params.page * 25) < data.total_count
            }
          }
        cache: true
    ).on "change", ->
      if $(this).data("autosubmit")
        $(this).parents("form").submit()

  exports.initDateTimePicker = (selector = ".datetimepicker")->
    $(selector).datetimepicker
      icons:
        date: "fa fa-calendar"
        time: "fa fa-clock-o"
        up: "fa fa-chevron-up"
        down: "fa fa-chevron-down"
        previous: "fa fa-chevron-left"
        next: "fa fa-chevron-right"
        today: "fa fa-crosshairs"
        clear: "fa fa-trash-o"
        close: "fa fa-times"
    .on "dp.change", ->
      if $(this).find("input[data-autosubmit]").size() > 0
        $(this).parents("form").submit()

  initGetFormsTurbolinks = ->
    $(document).on "submit", "form[data-turbolinks]", (event) ->
      Turbolinks.visit($(this).attr("action") + "?" + $(this).serialize())
      event.preventDefault()

  initEditable = ->
    $(document).on "click", ".editable-link", ->
      $this = $(this)
      $.ajax
        url: $this.data("editable-url"),
        data:
          editable_attribute: $this.data("editable-attribute")
          editable_as: $this.data("editable-as")
        dataType: "script"
      false
    $(document).on "click", ".editable-cancel", ->
      $editable = $(this).parents(".editable")
      $editable.find(".editable-form").empty()
      $editable.find(".editable-value").show()
      false

  exports.initEditableForm = (selector) ->
    $(selector).find(".form-group input, .form-group textarea").focus()
    autosize($(selector).find(".form-group textarea"))

Averylane.Layout.init()
