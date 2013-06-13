(($)->

  $.fn.carousel = (options = {})->
    try
      $(this).kinetic('detach')
    $(this).off('scroll')
    @$ = (sel)=> $(this).find(sel)
    itemWidth = @$('.item').outerWidth()
    itemHeight = @$('.item').outerHeight()
    itemCount = @$('.item').length
    options.itemWidth = itemWidth
    unless options.scale
      options.scale = 0.3
    @$('.item').css
      position: 'relative'
    @$('.inner').css
      width: itemWidth*itemCount
      height: itemHeight + 50
    if options.align == 'left'
      @$('.inner').css
        paddingLeft: $(this).width() * 0.25
        paddingRight: $(this).width() * 0.75
    else
      @$('.inner').css
        paddingLeft: $(this).width() * 0.5
        paddingRight: $(this).width() * 0.5

    carousel = new Carousel(this, options)
    carousel.refresh()

    carousel.snapTo Math.round(itemCount / 2) - 1

    moving = false
    $(this).kinetic
      y: false
      slowdown: options.slowdown || 0.8
      maxvelocity: 100
      moved: (settings)=>
        $(document).trigger 'user:action'
        if options.moved
          options.moved.call(this)
        if Math.abs(settings.velocity) >= 0.1
          moving = true
          carousel.refresh(settings.velocity)
      stopped: (settings)=>
        moving = false
        carousel.center()

    $(this).find('.item-inner').click (e)=>
      parent = $(e.currentTarget).parent('.item')
      unless moving
        if parent.hasClass('active') and options.click
          options.click(parent.index())
        carousel.snapTo parent.index()
    $(this).parent().find('.carousel-arrows img:first-child').click (e)=>
      carousel.snapTo carousel.active().index() - 1
      e.stopPropagation()
    $(this).parent().find('.carousel-arrows img:last-child').click (e)=>
      carousel.snapTo carousel.active().index() + 1
      e.stopPropagation()

  class Carousel
    constructor: (el, @options)->
      @$el = el
      @$ = (sel)=>
        @$el.find(sel)
      if @options.align == 'left'
        @magnet = @$el.width() / 2 / 2
      else
        @magnet = @$el.width() / 2
      @margin = @options.margin
      @positionOffset = @$el.offset().left
    active: ()->
      x = @$el.offset().left + @magnet
      y = @$el.offset().top + (@$el.height() / 2)
      elem = document.elementFromPoint(x, y)
      if $(elem).hasClass 'item-inner'
        return $(elem)
      else if $(elem).closest('.item').length > 0
        $(elem).closest('.item')
      else
        direction = if @velocity > 0 then 1 else -1
        $(@$('.item')[@lastIndex + direction])

    center: ()->
      @snapTo @active().index()

    snapTo: (idx)->
      @lastIndex = idx
      items = @$('.item')
      item = $(items[idx])
      
      @$('.item.active').removeClass('active')
      item.addClass('active')
      if item.length > 0
        width = item.outerWidth()
        position = item.position().left

        scrollLeft = (position + (width / 2)) - @magnet
        @$el.animate { scrollLeft: scrollLeft }, 
          complete: =>
            if @options.stopped
              @options.stopped.call(this, item)
          progress: =>
            @refresh()

    refresh: (velocity)->
      @velocity = velocity if velocity
      carousel = this
      @$('.item').each ()->
        carouselWidth = $(this).closest('.carousel').width()
        carouselCenter = carouselWidth / 2
        carouselMidpoint = carouselCenter / 2

        fromCenter = $(this).offset().left - carousel.positionOffset + ($(this).outerWidth() / 2) - carousel.magnet
        direction = if fromCenter > 0 then -1 else 1
        fromCenter = Math.abs(fromCenter)
        if fromCenter > carouselWidth
          return
        ratio = Math.abs(1.0 - Math.abs(fromCenter / carouselWidth))
        scale = if ratio < carousel.options.scale then carousel.options.scale else ratio
        opacity = 1
        if carousel.options.opacity
          opacity = if ratio < carousel.options.opacity then carousel.options.opacity else ratio
        height = $(this).outerHeight()
        lastRatio = $(this).data('ratio')
        if !lastRatio or lastRatio != scale or true
          translateX = 0
          if carousel.margin
            position = fromCenter / carousel.options.itemWidth
            translateX = Math.round((carousel.margin * (1 - scale) * position * direction * 2) * (1 - ratio) * 3.8) + 'px'
            #console.log "#{$(this).index()} - #{fromCenter} - #{position} - #{translateX}"
          if carousel.options.verticalAlign == 'bottom'
            $(this).find('.item-inner').css '-webkit-transform': "scale(#{scale}) translate(#{translateX}, #{Math.abs((height * scale) - height)}px)"
          else if carousel.options.bottomOffset
            $(this).find('.item-inner').css '-webkit-transform': "scale(#{scale}) translate(#{translateX}, #{(1 - scale) * carousel.options.bottomOffset}px)"
          else
            $(this).find('.item-inner').css '-webkit-transform': "scale(#{scale})"

          $(this).css
             opacity: opacity
             zIndex: Math.round(100 * ratio)
          $(this).data 'ratio', scale


)(jQuery)
