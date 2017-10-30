###!
#
# Angle - Bootstrap Admin App + jQuery
#
# Version: 3.3.1
# Author: @themicon_co
# Website: http://themicon.co
# License: https://wrapbootstrap.com/help/licenses
#
###

((window, document, $) ->
  if typeof $ == 'undefined'
    throw new Error('This application\'s JavaScript requires jQuery')
  $ ->
    # Restore body classes
    # -----------------------------------
    $body = $('body')
    (new StateToggler).restoreState $body
    # enable settings toggle after restore
    $('#chk-fixed').prop 'checked', $body.hasClass('layout-fixed')
    $('#chk-collapsed').prop 'checked', $body.hasClass('aside-collapsed')
    $('#chk-boxed').prop 'checked', $body.hasClass('layout-boxed')
    $('#chk-float').prop 'checked', $body.hasClass('aside-float')
    $('#chk-hover').prop 'checked', $body.hasClass('aside-hover')
    # When ready display the offsidebar
    $('.offsidebar.hide').removeClass 'hide'
    return
  # doc ready
  return
) window, document, window.jQuery
# Start Bootstrap JS
# -----------------------------------
((window, document, $) ->
  $ ->
    # POPOVER
    # -----------------------------------
    $('[data-toggle="popover"]').popover()
    # TOOLTIP
    # -----------------------------------
    $('[data-toggle="tooltip"]').tooltip container: 'body'
    # DROPDOWN INPUTS
    # -----------------------------------
    $('.dropdown input').on 'click focus', (event) ->
      event.stopPropagation()
      return
    return
  return
) window, document, window.jQuery

###*=========================================================
# Module: clear-storage.js
# Removes a key from the browser storage via element click
 =========================================================
###

(($, window, document) ->
  'use strict'
  Selector = '[data-reset-key]'
  $(document).on 'click', Selector, (e) ->
    e.preventDefault()
    key = $(this).data('resetKey')
    if key
      $.localStorage.remove key
      # reload the page
      window.location.reload()
    else
      $.error 'No storage key specified for reset.'
    return
  return
) jQuery, window, document

# GLOBAL CONSTANTS
# -----------------------------------
((window, document, $) ->
  window.APP_COLORS =
    'primary': '#5d9cec'
    'success': '#27c24c'
    'info': '#23b7e5'
    'warning': '#ff902b'
    'danger': '#f05050'
    'inverse': '#131e26'
    'green': '#37bc9b'
    'pink': '#f532e5'
    'purple': '#7266ba'
    'dark': '#3a3f51'
    'yellow': '#fad732'
    'gray-darker': '#232735'
    'gray-dark': '#3a3f51'
    'gray': '#dde6e9'
    'gray-light': '#e4eaec'
    'gray-lighter': '#edf1f2'
  window.APP_MEDIAQUERY =
    'desktopLG': 1200
    'desktop': 992
    'tablet': 768
    'mobile': 480
  return
) window, document, window.jQuery


# SIDEBAR
# -----------------------------------
((window, document, $) ->
  $win = undefined
  $html = undefined
  $body = undefined
  $sidebar = undefined
  mq = undefined

  sidebarAddBackdrop = ->
    $backdrop = $('<div/>', 'class': 'dropdown-backdrop')
    $backdrop.insertAfter('.aside').on 'click mouseenter', ->
      removeFloatingNav()
      return
    return

  # Open the collapse sidebar submenu items when on touch devices
  # - desktop only opens on hover

  toggleTouchItem = ($element) ->
    $element.siblings('li').removeClass('open').end().toggleClass 'open'
    return

  # Handles hover to open items under collapsed menu
  # -----------------------------------

  toggleMenuItem = ($listItem) ->
    removeFloatingNav()
    ul = $listItem.children('ul')
    if !ul.length
      return $()
    if $listItem.hasClass('open')
      toggleTouchItem $listItem
      return $()
    $aside = $('.aside')
    $asideInner = $('.aside-inner')
    # for top offset calculation
    # float aside uses extra padding on aside
    mar = parseInt($asideInner.css('padding-top'), 0) + parseInt($aside.css('padding-top'), 0)
    subNav = ul.clone().appendTo($aside)
    toggleTouchItem $listItem
    itemTop = $listItem.position().top + mar - $sidebar.scrollTop()
    vwHeight = $win.height()
    subNav.addClass('nav-floating').css
      position: if isFixed() then 'fixed' else 'absolute'
      top: itemTop
      bottom: if subNav.outerHeight(true) + itemTop > vwHeight then 0 else 'auto'
    subNav.on 'mouseleave', ->
      toggleTouchItem $listItem
      subNav.remove()
      return
    subNav

  removeFloatingNav = ->
    $('.sidebar-subnav.nav-floating').remove()
    $('.dropdown-backdrop').remove()
    $('.sidebar li.open').removeClass 'open'
    return

  isTouch = ->
    $html.hasClass 'touch'

  isSidebarCollapsed = ->
    $body.hasClass 'aside-collapsed'

  isSidebarToggled = ->
    $body.hasClass 'aside-toggled'

  isMobile = ->
    $win.width() < mq.tablet

  isFixed = ->
    $body.hasClass 'layout-fixed'

  useAsideHover = ->
    $body.hasClass 'aside-hover'

  $ ->
    $win = $(window)
    $html = $('html')
    $body = $('body')
    $sidebar = $('.sidebar')
    mq = APP_MEDIAQUERY
    # AUTOCOLLAPSE ITEMS
    # -----------------------------------
    sidebarCollapse = $sidebar.find('.collapse')
    sidebarCollapse.on 'show.bs.collapse', (event) ->
      event.stopPropagation()
      if $(this).parents('.collapse').length == 0
        sidebarCollapse.filter('.in').collapse 'hide'
      return
    # SIDEBAR ACTIVE STATE
    # -----------------------------------
    # Find current active item
    currentItem = $('.sidebar .active').parents('li')
    # hover mode don't try to expand active collapse
    if !useAsideHover()
      currentItem.addClass('active').children('.collapse').collapse 'show'
    # and show it
    # remove this if you use only collapsible sidebar items
    $sidebar.find('li > a + ul').on 'show.bs.collapse', (e) ->
      if useAsideHover()
        e.preventDefault()
      return
    # SIDEBAR COLLAPSED ITEM HANDLER
    # -----------------------------------
    eventName = if isTouch() then 'click' else 'mouseenter'
    subNav = $()
    $sidebar.on eventName, '.nav > li', ->
      if isSidebarCollapsed() or useAsideHover()
        subNav.trigger 'mouseleave'
        subNav = toggleMenuItem($(this))
        # Used to detect click and touch events outside the sidebar
        sidebarAddBackdrop()
      return
    sidebarAnyclickClose = $sidebar.data('sidebarAnyclickClose')
    # Allows to close
    if typeof sidebarAnyclickClose != 'undefined'
      $('.wrapper').on 'click.sidebar', (e) ->
        # don't check if sidebar not visible
        if !$body.hasClass('aside-toggled')
          return
        $target = $(e.target)
        if !$target.parents('.aside').length and !$target.is('#user-block-toggle') and !$target.parent().is('#user-block-toggle')
          $body.removeClass 'aside-toggled'
        return
    return
  return
) window, document, window.jQuery

# ---
# generated by js2coffee 2.2.0

###*=========================================================
# Module: play-animation.js
# Provides a simple way to run animation with a trigger
# Targeted elements must have
#   [data-animate"]
#   [data-target="Target element affected by the animation"]
#   [data-play="Animation name (http://daneden.github.io/animate.css/)"]
#
# Requires animo.js
 =========================================================
###

(($, window, document) ->
  'use strict'
  Selector = '[data-animate]'
  $ ->
    $scroller = $(window).add('body, .wrapper')
    # Parse animations params and attach trigger to scroll
    $(Selector).each ->
      $this = $(this)
      offset = $this.data('offset')
      delay = $this.data('delay') or 100
      animation = $this.data('play') or 'bounce'
      # Test an element visibilty and trigger the given animation

      testAnimation = (element) ->
        if !element.hasClass('anim-running') and $.Utils.isInView(element, topoffset: offset)
          element.addClass 'anim-running'
          setTimeout (->
            element.addClass('anim-done').animo
              animation: animation
              duration: 0.7
            return
          ), delay
        return

      if typeof offset != 'undefined'
        # test if the element starts visible
        testAnimation $this
        # test on scroll
        $scroller.scroll ->
          testAnimation $this
          return
      return
    # Run click triggered animations
    $(document).on 'click', Selector, ->
      $this = $(this)
      targetSel = $this.data('target')
      animation = $this.data('play') or 'bounce'
      target = $(targetSel)
      if target and target.length
        target.animo animation: animation
      return
    return
  return
) jQuery, window, document

# SIDEBAR
# -----------------------------------
((window, document, $) ->
  $win = undefined
  $html = undefined
  $body = undefined
  $sidebar = undefined
  mq = undefined

  sidebarAddBackdrop = ->
    $backdrop = $('<div/>', 'class': 'dropdown-backdrop')
    $backdrop.insertAfter('.aside').on 'click mouseenter', ->
      removeFloatingNav()
      return
    return

  # Open the collapse sidebar submenu items when on touch devices
  # - desktop only opens on hover

  toggleTouchItem = ($element) ->
    $element.siblings('li').removeClass('open').end().toggleClass 'open'
    return

  # Handles hover to open items under collapsed menu
  # -----------------------------------

  toggleMenuItem = ($listItem) ->
    removeFloatingNav()
    ul = $listItem.children('ul')
    if !ul.length
      return $()
    if $listItem.hasClass('open')
      toggleTouchItem $listItem
      return $()
    $aside = $('.aside')
    $asideInner = $('.aside-inner')
    # for top offset calculation
    # float aside uses extra padding on aside
    mar = parseInt($asideInner.css('padding-top'), 0) + parseInt($aside.css('padding-top'), 0)
    subNav = ul.clone().appendTo($aside)
    toggleTouchItem $listItem
    itemTop = $listItem.position().top + mar - $sidebar.scrollTop()
    vwHeight = $win.height()
    subNav.addClass('nav-floating').css
      position: if isFixed() then 'fixed' else 'absolute'
      top: itemTop
      bottom: if subNav.outerHeight(true) + itemTop > vwHeight then 0 else 'auto'
    subNav.on 'mouseleave', ->
      toggleTouchItem $listItem
      subNav.remove()
      return
    subNav

  removeFloatingNav = ->
    $('.sidebar-subnav.nav-floating').remove()
    $('.dropdown-backdrop').remove()
    $('.sidebar li.open').removeClass 'open'
    return

  isTouch = ->
    $html.hasClass 'touch'

  isSidebarCollapsed = ->
    $body.hasClass 'aside-collapsed'

  isSidebarToggled = ->
    $body.hasClass 'aside-toggled'

  isMobile = ->
    $win.width() < mq.tablet

  isFixed = ->
    $body.hasClass 'layout-fixed'

  useAsideHover = ->
    $body.hasClass 'aside-hover'

  $ ->
    $win = $(window)
    $html = $('html')
    $body = $('body')
    $sidebar = $('.sidebar')
    mq = APP_MEDIAQUERY
    # AUTOCOLLAPSE ITEMS
    # -----------------------------------
    sidebarCollapse = $sidebar.find('.collapse')
    sidebarCollapse.on 'show.bs.collapse', (event) ->
      event.stopPropagation()
      if $(this).parents('.collapse').length == 0
        sidebarCollapse.filter('.in').collapse 'hide'
      return
    # SIDEBAR ACTIVE STATE
    # -----------------------------------
    # Find current active item
    currentItem = $('.sidebar .active').parents('li')
    # hover mode don't try to expand active collapse
    if !useAsideHover()
      currentItem.addClass('active').children('.collapse').collapse 'show'
    # and show it
    # remove this if you use only collapsible sidebar items
    $sidebar.find('li > a + ul').on 'show.bs.collapse', (e) ->
      if useAsideHover()
        e.preventDefault()
      return
    # SIDEBAR COLLAPSED ITEM HANDLER
    # -----------------------------------
    eventName = if isTouch() then 'click' else 'mouseenter'
    subNav = $()
    $sidebar.on eventName, '.nav > li', ->
      if isSidebarCollapsed() or useAsideHover()
        subNav.trigger 'mouseleave'
        subNav = toggleMenuItem($(this))
        # Used to detect click and touch events outside the sidebar
        sidebarAddBackdrop()
      return
    sidebarAnyclickClose = $sidebar.data('sidebarAnyclickClose')
    # Allows to close
    if typeof sidebarAnyclickClose != 'undefined'
      $('.wrapper').on 'click.sidebar', (e) ->
        # don't check if sidebar not visible
        if !$body.hasClass('aside-toggled')
          return
        $target = $(e.target)
        if !$target.parents('.aside').length and !$target.is('#user-block-toggle') and !$target.parent().is('#user-block-toggle')
          $body.removeClass 'aside-toggled'
        return
    return
  return
) window, document, window.jQuery

# TOGGLE STATE
# -----------------------------------
((window, document, $) ->
  $ ->
    $body = $('body')
    toggle = new StateToggler
    $('[data-toggle-state]').on 'click', (e) ->
      # e.preventDefault();
      e.stopPropagation()
      element = $(this)
      classname = element.data('toggleState')
      target = element.data('target')
      noPersist = element.attr('data-no-persist') != undefined
      # Specify a target selector to toggle classname
      # use body by default
      $target = if target then $(target) else $body
      if classname
        if $target.hasClass(classname)
          $target.removeClass classname
          if !noPersist
            toggle.removeState classname
        else
          $target.addClass classname
          if !noPersist
            toggle.addState classname
      # some elements may need this when toggled class change the content size
      # e.g. sidebar collapsed mode and jqGrid
      $(window).resize()
      return
    return
  # Handle states to/from localstorage

  window.StateToggler = ->
    storageKeyName = 'jq-toggleState'
    # Helper object to check for words in a phrase //
    WordChecker =
      hasWord: (phrase, word) ->
        new RegExp('(^|\\s)' + word + '(\\s|$)').test phrase
      addWord: (phrase, word) ->
        if !@hasWord(phrase, word)
          return phrase + (if phrase then ' ' else '') + word
        return
      removeWord: (phrase, word) ->
        if @hasWord(phrase, word)
          return phrase.replace(new RegExp('(^|\\s)*' + word + '(\\s|$)*', 'g'), '')
        return
    # Return service public methods
    {
      addState: (classname) ->
        data = $.localStorage.get(storageKeyName)
        if !data
          data = classname
        else
          data = WordChecker.addWord(data, classname)
        $.localStorage.set storageKeyName, data
        return
      removeState: (classname) ->
        data = $.localStorage.get(storageKeyName)
        # nothing to remove
        if !data
          return
        data = WordChecker.removeWord(data, classname)
        $.localStorage.set storageKeyName, data
        return
      restoreState: ($elem) ->
        data = $.localStorage.get(storageKeyName)
        # nothing to restore
        if !data
          return
        $elem.addClass data
        return
    }

  return
) window, document, window.jQuery

###*
# Notify Addon definition as jQuery plugin
# Adapted version to work with Bootstrap classes
# More information http://getuikit.com/docs/addons_notify.html
###

(($, window, document) ->
  containers = {}
  messages = {}

  notify = (options) ->
    if $.type(options) == 'string'
      options = message: options
    if arguments[1]
      options = $.extend(options, if $.type(arguments[1]) == 'string' then status: arguments[1] else arguments[1])
    new Message(options).show()

  closeAll = (group, instantly) ->
    `var id`
    if group
      for id of messages
        if group == messages[id].group
          messages[id].close instantly
    else
      for id of messages
        messages[id].close instantly
    return

  Message = (options) ->
    $this = this
    @options = $.extend({}, Message.defaults, options)
    @uuid = 'ID' + (new Date).getTime() + 'RAND' + Math.ceil(Math.random() * 100000)
    @element = $([
      '<div class="uk-notify-message alert-dismissable">'
      '<a class="close">&times;</a>'
      '<div>' + @options.message + '</div>'
      '</div>'
    ].join('')).data('notifyMessage', this)
    # status
    if @options.status
      @element.addClass 'alert alert-' + @options.status
      @currentstatus = @options.status
    @group = @options.group
    messages[@uuid] = this
    containers[@options.pos] = $('<div class="uk-notify uk-notify-' + @options.pos + '"></div>').appendTo('body').on('click', '.uk-notify-message', ->
      $(this).data('notifyMessage').close()
      return
    )
    return

  $.extend Message.prototype,
    uuid: false
    element: false
    timout: false
    currentstatus: ''
    group: false
    show: ->
      if @element.is(':visible')
        return
      $this = this
      containers[@options.pos].show().prepend @element
      marginbottom = parseInt(@element.css('margin-bottom'), 10)
      @element.css(
        'opacity': 0
        'margin-top': -1 * @element.outerHeight()
        'margin-bottom': 0).animate {
        'opacity': 1
        'margin-top': 0
        'margin-bottom': marginbottom
      }, ->
        if $this.options.timeout

          closefn = ->
            $this.close()
            return

          $this.timeout = setTimeout(closefn, $this.options.timeout)
          $this.element.hover (->
            clearTimeout $this.timeout
            return
          ), ->
            $this.timeout = setTimeout(closefn, $this.options.timeout)
            return
        return
      this
    close: (instantly) ->
      $this = this

      finalize = ->
        $this.element.remove()
        if !containers[$this.options.pos].children().length
          containers[$this.options.pos].hide()
        delete messages[$this.uuid]
        return

      if @timeout
        clearTimeout @timeout
      if instantly
        finalize()
      else
        @element.animate {
          'opacity': 0
          'margin-top': -1 * @element.outerHeight()
          'margin-bottom': 0
        }, ->
          finalize()
          return
      return
    content: (html) ->
      container = @element.find('>div')
      if !html
        return container.html()
      container.html html
      this
    status: (status) ->
      if !status
        return @currentstatus
      @element.removeClass('alert alert-' + @currentstatus).addClass 'alert alert-' + status
      @currentstatus = status
      this
  Message.defaults =
    message: ''
    status: 'normal'
    timeout: 5000
    group: null
    pos: 'top-center'
  $['notify'] = notify
  $['notify'].message = Message
  $['notify'].closeAll = closeAll
  notify
) jQuery, window, document
