!function(e){function t(t,n){return parseInt(e.css(t[0],n))||0}function n(e){return e[0].offsetWidth+t(e,"marginLeft")+t(e,"marginRight")}function l(e){return e[0].offsetHeight+t(e,"marginTop")+t(e,"marginBottom")}e.fn.jCarouselLite=function(t){return t=e.extend({btnPrev:null,btnNext:null,btnGo:null,mouseWheel:!1,auto:null,speed:200,easing:null,vertical:!1,circular:!0,visible:3,start:0,scroll:1,beforeStart:null,afterEnd:null},t||{}),this.each(function(){function i(){return v.slice(p).slice(0,h)}function r(n){if(!s){if(t.beforeStart&&t.beforeStart.call(this,i()),t.circular)n<=t.start-h-1?(u.css(c,-((b-2*h)*g)+"px"),p=n==t.start-h-1?b-2*h-1:b-2*h-t.scroll):n>=b-h+1?(u.css(c,-(h*g)+"px"),p=n==b-h+1?h+1:h+t.scroll):p=n;else{if(0>n||n>b-h)return;p=n}s=!0,u.animate("left"==c?{left:-(p*g)}:{top:-(p*g)},t.speed,t.easing,function(){t.afterEnd&&t.afterEnd.call(this,i()),s=!1}),t.circular||(e(t.btnPrev+","+t.btnNext).removeClass("disabled"),e(p-t.scroll<0&&t.btnPrev||p+t.scroll>b-h&&t.btnNext||[]).addClass("disabled"))}return!1}var s=!1,c=t.vertical?"top":"left",o=t.vertical?"height":"width",a=e(this),u=e("ul",a),f=e("li",u),d=f.size(),h=t.visible;t.circular&&(u.prepend(f.slice(d-h-1+1).clone()).append(f.slice(0,h).clone()),t.start+=h);var v=e("li",u),b=v.size(),p=t.start;a.css("visibility","visible"),v.css({overflow:"hidden","float":t.vertical?"none":"left"}),u.css({margin:"0",padding:"0",position:"relative","list-style-type":"none","z-index":"1"}),a.css({overflow:"hidden",position:"relative","z-index":"2",left:"0px"});var g=t.vertical?l(v):n(v),x=g*b,m=g*h;v.css({width:v.width(),height:v.height()}),u.css(o,x+"px").css(c,-(p*g)),a.css(o,m+"px"),t.btnPrev&&e(t.btnPrev).click(function(){return r(p-t.scroll)}),t.btnNext&&e(t.btnNext).click(function(){return r(p+t.scroll)}),t.btnGo&&e.each(t.btnGo,function(n,l){e(l).click(function(){return r(t.circular?t.visible+n:n)})}),t.mouseWheel&&a.mousewheel&&a.mousewheel(function(e,n){return r(n>0?p-t.scroll:p+t.scroll)}),t.auto&&setInterval(function(){r(p+t.scroll)},t.auto+t.speed)})}}(jQuery);