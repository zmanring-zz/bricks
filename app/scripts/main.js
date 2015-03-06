(function() {
  var Brick,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Brick = (function() {
    function Brick() {
      this.startSideToSide = bind(this.startSideToSide, this);
      this.body = $('body');
      this.brickCount = 0;
      this.brickHeightInPercent = 3;
      this.delayInSeconds = .8;
      this.dropButton = $('button.drop');
      this.main = $('main');
      this.window = $(window);
      this.create();
      this.dropButton.on('click', (function(_this) {
        return function() {
          _this.dropButton.attr('disabled', 'disabled');
          return _this.drop();
        };
      })(this));
    }

    Brick.prototype.create = function(width) {
      if (width == null) {
        width = '50%';
      }
      this.main.prepend('<div class="brick current" style="width:' + width + '"></div>');
      return this.startSideToSide();
    };

    Brick.prototype.startSideToSide = function() {
      this.currentBrickElem = $('.current');
      this.currentBrickWidth = this.currentBrickElem.width();
      this.currentWindowWidth = this.window.width();
      this.sideToSideTl = new TimelineLite({
        onComplete: this.startSideToSide
      });
      this.sideToSideTl.to(this.currentBrickElem, this.delayInSeconds, {
        left: this.currentWindowWidth - this.currentBrickWidth,
        ease: Linear.easeNone
      });
      return this.sideToSideTl.to(this.currentBrickElem, this.delayInSeconds, {
        left: 0,
        ease: Linear.easeNone
      });
    };

    Brick.prototype.percentFromLeft = function() {
      var fromLeftInPercent, fromLeftInPx;
      fromLeftInPx = this.currentBrickElem.offset().left;
      fromLeftInPercent = (fromLeftInPx / this.main.width()) * 100;
      this.currentBrickElem.css({
        left: fromLeftInPercent + '%'
      });
      return fromLeftInPercent;
    };

    Brick.prototype.stopSideToSide = function() {
      return this.sideToSideTl.stop();
    };

    Brick.prototype.unbind = function() {
      return this.currentBrickElem.removeClass('current');
    };

    Brick.prototype.calculateOffset = function() {
      var currentBrickInPercentage, currentBrickOffsetInPercentage, currentWidthOffset;
      currentBrickOffsetInPercentage = this.percentFromLeft();
      currentBrickInPercentage = this.currentBrickWidth / this.currentWindowWidth * 100;
      currentWidthOffset = currentBrickInPercentage - Math.abs(currentBrickOffsetInPercentage - this.previousBrickOffsetInPercentage);
      this.newWidth = Math.abs(currentWidthOffset) + '%';
      if (currentWidthOffset > 0) {
        this.currentBrickElem.css({
          width: this.newWidth,
          left: this.previousBrickOffsetInPercentage > currentBrickOffsetInPercentage ? this.previousBrickOffsetInPercentage + '%' : currentBrickOffsetInPercentage + '%'
        });
      }
      return currentWidthOffset;
    };

    Brick.prototype.calculatePoints = function() {
      this.brickCount++;
      this.body.attr('data-points', this.brickCount);
      return $('head title').text('Bricks (' + this.brickCount + ')');
    };

    Brick.prototype.gameOver = function() {
      this.body.attr('data-points', 'GAME OVER');
      return this.dropButton.text(':(');
    };

    Brick.prototype.drop = function() {
      this.stopSideToSide();
      this.dropTl = new TimelineLite({
        onComplete: (function(_this) {
          return function() {
            var currentWidthOffset;
            currentWidthOffset = _this.calculateOffset();
            if (currentWidthOffset < 0) {
              return _this.gameOver();
            } else {
              _this.unbind();
              _this.calculatePoints();
              _this.dropButton.removeAttr('disabled');
              _this.previousBrickOffsetInPercentage = _this.percentFromLeft();
              _this.previousBrickWidth = _this.currentBrickWidth;
              _this.delayInSeconds = _this.delayInSeconds / 1.01;
              if (_this.brickCount <= 1) {
                return _this.create();
              } else {
                return _this.create(_this.newWidth);
              }
            }
          };
        })(this)
      });
      return this.dropTl.to(this.currentBrickElem, 1, {
        bottom: this.brickCount * this.brickHeightInPercent + '%',
        ease: Bounce.easeOut
      });
    };

    return Brick;

  })();

  new Brick();

}).call(this);
