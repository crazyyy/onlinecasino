!function(e){e.fn.lightBox=function(t){function i(){return n(this,f),!1}function n(i,n){if(e("embed, object, select").css({visibility:"hidden"}),a(),t.imageArray.length=0,t.activeImage=0,1==n.length){var r=i.getAttribute("href")?i.getAttribute("href"):url_to_concat+i.getAttribute("alt");t.imageArray.push(new Array(r,i.getAttribute("title")))}else for(var g=0;g<n.length;g++){var r=n[g].getAttribute("href")?n[g].getAttribute("href"):url_to_concat+n[g].getAttribute("alt");t.imageArray.push(new Array(r,n[g].getAttribute("title")))}for(var r=i.getAttribute("href")?i.getAttribute("href"):url_to_concat+i.getAttribute("alt");t.imageArray[t.activeImage][0]!=r;)t.activeImage++;o()}function a(){e("body").append('<div id="jquery-overlay"></div><div id="jquery-lightbox"><div id="lightbox-container-image-box"><div id="lightbox-container-image"><img id="lightbox-image"><div style="" id="lightbox-nav"><a href="#" id="lightbox-nav-btnPrev"></a><a href="#" id="lightbox-nav-btnNext"></a></div><div id="lightbox-loading"><a href="#" id="lightbox-loading-link"><img src="'+t.imageLoading+'"></a></div></div></div><div id="lightbox-container-image-data-box"><div id="lightbox-container-image-data"><div id="lightbox-image-details"><span id="lightbox-image-details-caption"></span><span id="lightbox-image-details-currentNumber"></span></div><div id="lightbox-secNav"><a href="#" id="lightbox-secNav-btnClose"><img src="'+t.imageBtnClose+'"></a></div></div></div></div>');var i=s();e("#jquery-overlay").css({backgroundColor:t.overlayBgColor,opacity:t.overlayOpacity,width:i[0],height:i[1]}).fadeIn();var n=v();e("#jquery-lightbox").css({top:n[1]+i[3]/10,left:n[0]}).show(),e("#jquery-overlay,#jquery-lightbox").click(function(){b()}),e("#lightbox-loading-link,#lightbox-secNav-btnClose").click(function(){return b(),!1}),e(window).resize(function(){var t=s();e("#jquery-overlay").css({width:t[0],height:t[1]});var i=v();e("#jquery-lightbox").css({top:i[1]+t[3]/10,left:i[0]})})}function o(){e("#lightbox-loading").show(),t.fixedNavigation?e("#lightbox-image,#lightbox-container-image-data-box,#lightbox-image-details-currentNumber").hide():e("#lightbox-image,#lightbox-nav,#lightbox-nav-btnPrev,#lightbox-nav-btnNext,#lightbox-container-image-data-box,#lightbox-image-details-currentNumber").hide();var i=new Image;i.onload=function(){e("#lightbox-image").attr("src",t.imageArray[t.activeImage][0]),r(i.width,i.height),i.onload=function(){}},i.src=t.imageArray[t.activeImage][0]}function r(i,n){var a=e("#lightbox-container-image-box").width(),o=e("#lightbox-container-image-box").height(),r=i+2*t.containerBorderSize,c=n+2*t.containerBorderSize,l=a-r,d=o-c;e("#lightbox-container-image-box").animate({width:r,height:c},t.containerResizeSpeed,function(){g()}),0==l&&0==d&&x(e.browser.msie?250:100),e("#lightbox-container-image-data-box").css({width:i}),e("#lightbox-nav-btnPrev,#lightbox-nav-btnNext").css({height:n+2*t.containerBorderSize})}function g(){e("#lightbox-loading").hide(),e("#lightbox-image").fadeIn(function(){c(),l()}),u()}function c(){e("#lightbox-container-image-data-box").slideDown("fast"),e("#lightbox-image-details-caption").hide(),t.imageArray[t.activeImage][1]&&e("#lightbox-image-details-caption").html(t.imageArray[t.activeImage][1]).show(),t.imageArray.length>1&&e("#lightbox-image-details-currentNumber").html(t.txtImage+" "+(t.activeImage+1)+" "+t.txtOf+" "+t.imageArray.length).show()}function l(){e("#lightbox-nav").show(),e("#lightbox-nav-btnPrev,#lightbox-nav-btnNext").css({background:"transparent url("+t.imageBlank+") no-repeat"}),0!=t.activeImage&&(t.fixedNavigation?e("#lightbox-nav-btnPrev").css({background:"url("+t.imageBtnPrev+") left 15% no-repeat"}).unbind().bind("click",function(){return t.activeImage=t.activeImage-1,o(),!1}):e("#lightbox-nav-btnPrev").unbind().hover(function(){e(this).css({background:"url("+t.imageBtnPrev+") left 15% no-repeat"})},function(){e(this).css({background:"transparent url("+t.imageBlank+") no-repeat"})}).show().bind("click",function(){return t.activeImage=t.activeImage-1,o(),!1})),t.activeImage!=t.imageArray.length-1&&(t.fixedNavigation?e("#lightbox-nav-btnNext").css({background:"url("+t.imageBtnNext+") right 15% no-repeat"}).unbind().bind("click",function(){return t.activeImage=t.activeImage+1,o(),!1}):e("#lightbox-nav-btnNext").unbind().hover(function(){e(this).css({background:"url("+t.imageBtnNext+") right 15% no-repeat"})},function(){e(this).css({background:"transparent url("+t.imageBlank+") no-repeat"})}).show().bind("click",function(){return t.activeImage=t.activeImage+1,o(),!1})),d()}function d(){e(document).keydown(function(e){h(e)})}function m(){e(document).unbind()}function h(e){null==e?(keycode=event.keyCode,escapeKey=27):(keycode=e.keyCode,escapeKey=e.DOM_VK_ESCAPE),key=String.fromCharCode(keycode).toLowerCase(),(key==t.keyToClose||"x"==key||keycode==escapeKey)&&b(),(key==t.keyToPrev||37==keycode)&&0!=t.activeImage&&(t.activeImage=t.activeImage-1,o(),m()),(key==t.keyToNext||39==keycode)&&t.activeImage!=t.imageArray.length-1&&(t.activeImage=t.activeImage+1,o(),m())}function u(){t.imageArray.length-1>t.activeImage&&(objNext=new Image,objNext.src=t.imageArray[t.activeImage+1][0]),t.activeImage>0&&(objPrev=new Image,objPrev.src=t.imageArray[t.activeImage-1][0])}function b(){e("#jquery-lightbox").remove(),e("#jquery-overlay").fadeOut(function(){e("#jquery-overlay").remove()}),e("embed, object, select").css({visibility:"visible"})}function s(){var e,t;window.innerHeight&&window.scrollMaxY?(e=window.innerWidth+window.scrollMaxX,t=window.innerHeight+window.scrollMaxY):document.body.scrollHeight>document.body.offsetHeight?(e=document.body.scrollWidth,t=document.body.scrollHeight):(e=document.body.offsetWidth,t=document.body.offsetHeight);var i,n;return self.innerHeight?(i=document.documentElement.clientWidth?document.documentElement.clientWidth:self.innerWidth,n=self.innerHeight):document.documentElement&&document.documentElement.clientHeight?(i=document.documentElement.clientWidth,n=document.documentElement.clientHeight):document.body&&(i=document.body.clientWidth,n=document.body.clientHeight),pageHeight=n>t?n:t,pageWidth=i>e?e:i,arrayPageSize=new Array(pageWidth,pageHeight,i,n),arrayPageSize}function v(){var e,t;return self.pageYOffset?(t=self.pageYOffset,e=self.pageXOffset):document.documentElement&&document.documentElement.scrollTop?(t=document.documentElement.scrollTop,e=document.documentElement.scrollLeft):document.body&&(t=document.body.scrollTop,e=document.body.scrollLeft),arrayPageScroll=new Array(e,t),arrayPageScroll}function x(e){var t=new Date;i=null;do var i=new Date;while(e>i-t)}t=jQuery.extend({overlayBgColor:"#000",overlayOpacity:.8,fixedNavigation:!1,imageLoading:"http://www.onlinecasino.com.au/i/pk/lightbox-ico-loading.gif",imageBtnPrev:"http://www.onlinecasino.com.au/i/pk/lightbox-btn-prev.gif",imageBtnNext:"http://www.onlinecasino.com.au/i/pk/lightbox-btn-next.gif",imageBtnClose:"http://www.onlinecasino.com.au/i/pk/lightbox-btn-close.gif",imageBlank:"http://www.onlinecasino.com.au/i/pk/lightbox-blank.gif",containerBorderSize:10,containerResizeSpeed:400,txtImage:"Image",txtOf:"of",keyToClose:"c",keyToPrev:"p",keyToNext:"n",imageArray:[],activeImage:0},t);var f=this;return this.unbind("click").click(i)}}(jQuery);