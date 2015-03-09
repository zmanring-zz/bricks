class Score
  constructor: ->
    @form = $ '.modal form'
    @modalContent = $ '.modal .content'
    @modalLabel = $ '.modal label'
    @submitted = false
    @nameInput = $ '.name'

    @form.on 'submit', (event) =>
      do event.preventDefault

      # add new score
      @add @nameInput.val(), brick.getScore() unless @submitted

      # remove and disable duplicate entries
      do @form.hide
      @submitted = true

  connect: ->
    @firebase = new Firebase('https://bricks.firebaseio.com/')
    do @getLeaders

  getLeaders: ->
    @firebase.child('leaderboards').on 'value', (snapshot) =>
      @displayLeaderboard snapshot.val()

  add: (name='anonymous', score) ->
    epoch = (new Date).getTime()

    @firebase.child('leaderboards').child(epoch).set(
      name: name
      score: score
      time: epoch
    )

  sortDataByScore: (data) ->
    arr = []

    for key of data
      obj = data[key]
      arr.push obj

     _.sortBy(arr, 'score').reverse()

  displayLeaderboard: (data) ->

    leadersArray = @sortDataByScore data
    html = '<ul>'

    for leader in leadersArray
      html += '<li><p>' + leader.name + '<span>' + leader.score + '</span></p></li>'

    html += '</ul>'

    @modalContent.html html


class Brick
  constructor: ->
    @body = $ 'body'
    @brickCount = 0
    @brickHeightInPercent = 3
    @brickLimit = 10
    @delayInSeconds = .7
    @document = $ document
    @dropButton = $ 'button.drop'
    @main = $ 'main'
    @modal = $ '.modal'
    @window = $ window

    # create brick
    do @create

    @dropButton.on 'click', =>
      @dropButton.attr 'disabled', 'disabled'
      do @drop

    @document.keydown (event) =>
      # spacebar
      if event.keyCode is 32
        @dropButton.attr 'disabled', 'disabled'
        do @drop

    $('.reload').on 'click', ->
      do location.reload

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
    ).to(
      @currentBrickElem, @delayInSeconds,
        left: 0
        ease: Linear.easeNone
    )

  moveDown: ->
    bricks = $ '.brick'
    do bricks.last().remove
    bricks = $ '.brick'

    reverseList = bricks.get().reverse()

    $(reverseList).each (i,brick)->

      if i+1 < reverseList.length
        $(brick).css(
          bottom: (i*3) + '%'
        )

  getScore: ->
    @brickCount

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
    $('.score').attr 'data-points', @brickCount
    $('head title').text('Bricks (' + @brickCount + ')')

  gameOver: ->
    @body.attr 'data-points', 'GAME OVER!'

    do score.connect
    do @modal.show

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

          if @brickCount > @brickLimit
            do @moveDown

    @dropTl.to(
      @currentBrickElem, 1,
        bottom: if @brickCount < @brickLimit then @brickCount * @brickHeightInPercent + '%' else @brickLimit * @brickHeightInPercent + '%'
        ease: Bounce.easeOut
    )

# init
brick = new Brick()
score = new Score()
