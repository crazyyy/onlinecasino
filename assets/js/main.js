$.get("http://www.onlinecasino.com.au/feeds/scheduled.php?g=games", function(data) {
  $(".home-winnerFeedScroll").append(data);
});
$(function() {
  $(document).on('scroll', function() {

    if ($(window).scrollTop() > 100) {
      $('.scroll-top-wrapper').addClass('show');
    } else {
      $('.scroll-top-wrapper').removeClass('show');
    }
  });

  $('.scroll-top-wrapper').on('click', scrollToTop);
});

function scrollToTop() {
  verticalOffset = typeof(verticalOffset) != 'undefined' ? verticalOffset : 0;
  element = $('body');
  offset = element.offset();
  offsetTop = offset.top;
  $('html, body').animate({
    scrollTop: offsetTop
  }, 500, 'linear');
}
$(function() {

  $(document).on('scroll', function() {

    if ($(window).scrollTop() > 100) {
      $('.scroll-top-wrapper').addClass('show');
    } else {
      $('.scroll-top-wrapper').removeClass('show');
    }
  });
});


var _vwo_code = (function() {

  var account_id = 61702,

    settings_tolerance = 2000,

    library_tolerance = 2500,

    use_existing_jquery = false,

    // DO NOT EDIT BELOW THIS LINE

    f = false,
    d = document;
  return {
    use_existing_jquery: function() {
      return use_existing_jquery;
    },
    library_tolerance: function() {
      return library_tolerance;
    },
    finish: function() {
      if (!f) {
        f = true;
        var a = d.getElementById('_vis_opt_path_hides');
        if (a) a.parentNode.removeChild(a);
      }
    },
    finished: function() {
      return f;
    },
    load: function(a) {
      var b = d.createElement('script');
      b.src = a;
      b.type = 'text/javascript';
      b.innerText;
      b.onerror = function() {
        _vwo_code.finish();
      };
      d.getElementsByTagName('head')[0].appendChild(b);
    },
    init: function() {
      settings_timer = setTimeout('_vwo_code.finish()', settings_tolerance);
      this.load('//dev.visualwebsiteoptimizer.com/j.php?a=' + account_id + '&u=' + encodeURIComponent(d.URL) + '&r=' + Math.random());
      var a = d.createElement('style'),
        b = 'body{opacity:0 !important;filter:alpha(opacity=0) !important;background:none !important;}',
        h = d.getElementsByTagName('head')[0];
      a.setAttribute('id', '_vis_opt_path_hides');
      a.setAttribute('type', 'text/css');
      if (a.styleSheet) a.styleSheet.cssText = b;
      else a.appendChild(d.createTextNode(b));
      h.appendChild(a);
      return settings_timer;
    }
  };
}());
_vwo_settings_timer = _vwo_code.init();
_vwo_code.finish();

(function(f, b) {
  var c;
  f.hj = f.hj || function() {
    (f.hj.q = f.hj.q || []).push(arguments)
  };
  f._hjSettings = {
    hjid: 23413,
    hjsv: 3
  };
  c = b.createElement("script");
  c.async = 1;
  c.src = "//static.hotjar.com/c/hotjar-23413.js?sv=3";
  b.getElementsByTagName("head")[0].appendChild(c);
})(window, document);

$(document).ready(function() {
  $('.thumb_img,.small_thumb_img').each(function() {
    var t_hite = eval(parseInt($(this).height()) - parseInt($(this).find('img').height()));
    t_hite /= 2;
    $(this).find('img').animate({
      marginTop: t_hite + 'px'
    }, 0);
  });
});
