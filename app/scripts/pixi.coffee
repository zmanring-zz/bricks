class Brick
  constructor: ->
    @window = window
    @moveRight = true

    do @createStage
    do @render

    @graphics = new PIXI.Graphics()

    @graphics.beginFill 0xEE2C70

    # @graphics.lineStyle 5, 0xFF0000

    @graphics.drawRect 0, 0, @window.innerWidth/2, 30

    @stage.addChild @graphics


    # rect = PIXI.Rectangle 0,0,100,100
    #
    #
    # # create a texture from an image path
    # texture = PIXI.Texture.fromImage 'https://lh6.googleusercontent.com/-laK9i4gWNnY/AAAAAAAAAAI/AAAAAAAAAeM/WEeDQ6_yllw/photo.jpg'
    # # create a new Sprite using the texture
    # @bunny = new PIXI.Sprite texture
    #
    requestAnimFrame @animate
    #
    # # center the sprites anchor point
    # @bunny.anchor.x = 0.5
    # @bunny.anchor.y = 0.5
    #
    # # move the sprite t the center of the screen
    # @bunny.position.x = @window.innerWidth/2
    # @bunny.position.y = @window.innerHeight/2
    #
    # # @stage.addChild @bunny
    # @stage.addChild rect

    # @renderer.render @stage

  render: ->
    # create a renderer instance
    @renderer = new PIXI.autoDetectRenderer @window.innerWidth, @window.innerHeight

    # add the renderer view element to the DOM
    document.body.appendChild @renderer.view

  createStage: ->
    # create an new instance of a pixi stage
    @stage = new PIXI.Stage 0x222222

  animate: =>
    @speed = 20

    requestAnimFrame @animate

    if @moveRight
      @graphics.x += @speed
      if @graphics.position.x > @window.innerWidth - @graphics.width then @moveRight = false

    else
      @graphics.x -= @speed
      if @graphics.position.x < 0 then @moveRight = true

    # update width
    @graphics.width = @window.innerWidth/2

    # render the stage
    @renderer.render @stage

new Brick()
