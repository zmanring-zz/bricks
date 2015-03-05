$(function () {

  var tl, points = 0, delayInSeconds = 1;

  function addNewBar(size) {
    $('main').prepend('<div class="bar current" style="width:' + size + '"></div>');
    sideToSide();
  }

  function sideToSide() {

    var currentBarWidth = $('.current').width();
    var currentWindowWidth = $(window).width();

    tl = new TimelineLite({
      onComplete: sideToSide
    });

    tl.to(
      $('.current'), delayInSeconds, {
        left: (currentWindowWidth - currentBarWidth),
        ease: Linear.easeNone
      }
    );

    tl.to(
      $('.current'), delayInSeconds, {
        left: 0,
        ease: Linear.easeNone
      }
    );

  }

  $('button.drop').on('click', function() {

    tl.stop();

    var $current = $('.current');
    var barLength = $('.bar').length;

    var twl = new TimelineLite({
      onComplete: function() {

        var currentWidth = $current.outerWidth();
        var $prevBar = $current.next();

        if ($prevBar.length > 0) {

          // get current width/offset
          var currentOffset = $current.offset().left;
          var prevBarOffset = $prevBar.offset().left;

          var prevBarWidth = $prevBar.outerWidth();

          var currentWidthMinusOffset = currentWidth - Math.abs(currentOffset-prevBarOffset);
          var currentWidth = (currentWidthMinusOffset < prevBarWidth) ? currentWidthMinusOffset : prevBarWidth

          $current.css({
            width: (currentWidthMinusOffset < prevBarWidth) ? currentWidthMinusOffset : prevBarWidth,
            left: (prevBarOffset > currentOffset) ? prevBarOffset : currentOffset
          });

        }

        if (currentWidth <= 0) {
          alert('Game Over\nPoints:' + points);
        } else {
          points+=1;
          delayInSeconds = delayInSeconds/1.01;
        }

        // remove class
        $current.removeClass('current');
        addNewBar(currentWidth + 'px');

      }
    });

    twl.to(
      $current, 1, {
        bottom: ((barLength-1) * 3) + '%',
        ease: Bounce.easeOut
      }
    );

  });

  // init
  addNewBar('50%');

});
