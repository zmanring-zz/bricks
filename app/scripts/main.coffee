class Brick
  constructor: ->
    @body = $ 'body'
    @brickCount = 0
    @brickHeightInPercent = 3
    @delayInSeconds = .8
    @dropButton = $ 'button.drop'
    @main = $ 'main'
    @window = $ window

    # create brick
    do @create

    @dropButton.on 'click', =>
      @dropButton.attr 'disabled', 'disabled'
      do @drop

  create: (width='50%')->
    @main.prepend '<div class="brick current" style="width:' + width + '"></div>'
    do @startSideToSide

  startSideToSide: =>
    @currentBrickElem = $ '.current'

    @currentBrickWidth = @currentBrickElem.width()
    @currentWindowWidth = @window.width()

    @sideToSideTl = new TimelineLite
      onComplete: @startSideToSide

    @sideToSideTl.to(
      @currentBrickElem, @delayInSeconds,
        left: @currentWindowWidth - @currentBrickWidth
        ease: Linear.easeNone
    )

    @sideToSideTl.to(
      @currentBrickElem, @delayInSeconds,
        left: 0
        ease: Linear.easeNone
    )

  percentFromLeft: ->
    fromLeftInPx = @currentBrickElem.offset().left
    fromLeftInPercent = (fromLeftInPx / @main.width()) * 100

    @currentBrickElem.css(
      left: fromLeftInPercent + '%'
    )

    return fromLeftInPercent

  stopSideToSide: ->
    # stop animation
    do @sideToSideTl.stop

  unbind: ->
    @currentBrickElem.removeClass 'current'

  calculateOffset: ->
    currentBrickOffsetInPercentage = do @percentFromLeft
    currentBrickInPercentage = @currentBrickWidth/@currentWindowWidth*100
    currentWidthOffset = currentBrickInPercentage - Math.abs(currentBrickOffsetInPercentage-@previousBrickOffsetInPercentage)

    # store globally so I can reuse later
    @newWidth = Math.abs(currentWidthOffset) + '%'

    if currentWidthOffset > 0
      @currentBrickElem.css(
        width: @newWidth
        left: if @previousBrickOffsetInPercentage > currentBrickOffsetInPercentage then @previousBrickOffsetInPercentage + '%' else currentBrickOffsetInPercentage + '%'
      )

    return currentWidthOffset

  calculatePoints: ->
    @brickCount++
    @body.attr 'data-points', @brickCount
    $('head title').text('Bricks (' + @brickCount + ')')

  gameOver: ->
    @body.attr 'data-points', 'GAME OVER'
    @dropButton.text ':('

  drop: ->
    # stop first
    do @stopSideToSide

    @dropTl = new TimelineLite
      onComplete: =>
        currentWidthOffset = do @calculateOffset

        if currentWidthOffset < 0
          do @gameOver
        else
          do @unbind
          do @calculatePoints

          # enable button
          @dropButton.removeAttr 'disabled'

          # store previous brick width to prevent hacking of DOM
          @previousBrickOffsetInPercentage = do @percentFromLeft
          @previousBrickWidth = @currentBrickWidth

          @delayInSeconds = @delayInSeconds/1.01

          if @brickCount <= 1
            do @create
          else
            @create(@newWidth)

    @dropTl.to(
      @currentBrickElem, 1,
        bottom: @brickCount * @brickHeightInPercent + '%'
        ease: Bounce.easeOut
    )

# init
new Brick()
