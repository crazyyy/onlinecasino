!function(){function t(){var t=document.querySelectorAll(".accordion"),e=document.querySelectorAll(".accordion > h3 > a"),n=document.querySelector("a.anchor");$accord(t),n.addEventListener("click",function(t){var e=t.currentTarget,n=window.screenTop,i=e.getAttribute("href"),o=document.querySelector(i),r=_getOffset(o).top;_anim({el:window,from:n,to:r,time:600,scroll:!0}),t.preventDefault()},!1);for(var i=0;i<e.length;i++)e[i].addEventListener("click",function(t){t.preventDefault()},!1)}document.addEventListener("DOMContentLoaded",t,!1)}(),function(){function t(t,n){var i,o;if(!(t instanceof NodeList||t instanceof Node))return!1;for(o=t.length;o--;)i=new e(t[o],n);return i}function e(t,e){this.el=t,this.options={event:"click",active:1};for(i in e)this.options[i]=e[i];this.data={},this.init()}e.prototype={init:function(){this.children=this.el.children,this.titles=this.getEvenOdd(this.children,!0),this.boxs=this.getEvenOdd(this.children,!1),this.hide(this.boxs),this.show(this.boxs[this.options.active-1]),this.bind(this.options.event,this.titles,!1)},handleEvent:function(t){var e=t.currentTarget,n=this.next(e),i=this.siblingArr(this.boxs,n),o=this.siblingArr(this.titles,e);this.hide(i),this.removeClass(o,"active"),this.toggle(n),this.toggleClass(e,"active")},bind:function(t,e,n){var e=e.length?e:[e],i=0,o=e.length;for(i=0;o>i;i++)e[i].addEventListener(t,this,!!n)},getEvenOdd:function(t,e){for(var t=t.length?t:[t],n=[],i=e?0:1,o=0;o<t.length;o++)o%2==i&&n.push(t[o]);return n},siblingArr:function(t,e){for(var n=[],i=0;i<t.length;i++)1===t[i].nodeType&&t[i]!==e&&n.push(t[i]);return n},next:function(t){for(var e=t.nextSibling;e;e=e.nextSibling)if(1===e.nodeType)return e},hide:function(t,e){var t=t.length?t:[t],n=0,i=t.length;for(n=0;i>n;n++)t[n].style.display="none"},show:function(t,e){var t=t.length?t:[t],n=0,i=t.length||0;for(n=0;i>n;n++)t[n].style.display="block"},toggle:function(t,e){function n(t){i.isHidden(t)?i.show(t):i.hide(t)}var i=this,t=t.length?t:[t],o=0,r=t.length;for(o=0;r>o;o++)n(t[o])},isHidden:function(t){var e=window.getComputedStyle(t,null).display,n=window.getComputedStyle(t,null).vissible,i=window.getComputedStyle(t,null).height,o="none"==e||"hidden"==n||0==i||"0px"==i?!0:!1;return o},removeClass:function(t,e){var t=t.length?t:[t],n=0,i=t.length;for(n=0;i>n;n++){var o=t[n].className||"";o=o.replace(e,""),t[n].className=o}},toggleClass:function(t,e){var t=t.length?t:[t],n=0,i=t.length;for(n=0;i>n;n++){var o=t[n].className||"",r=new RegExp(e,"i");o=r.test(o)?o.replace(r,""):o+" "+e,t[n].className=o}}},window.$accord=t}(),function(){function t(t){var n=t.el,i=t.from,o=t.to,r=t.time,l=(new Date).getTime();setTimeout(function(){var s=(new Date).getTime()-l,c=s/r,a=(o-i)*e(c)+i;t.style?n.style.left=a+t.unit:t.scroll&&window.scroll(0,a),1>c&&setTimeout(arguments.callee,10)},10)}function e(t){return t}function n(t){function e(t){var e=t.getBoundingClientRect(),n=document.body,i=document.documentElement,o=window.pageYOffset||i.scrollTop||n.scrollTop,r=window.pageXOffset||i.scrollLeft||n.scrollLeft,l=i.clientTop||n.clientTop||0,s=i.clientLeft||n.clientLeft||0,c=e.top+o-l,a=e.left+r-s;return{top:Math.round(c),left:Math.round(a)}}function n(t){for(var e=0,n=0;t;)e+=parseFloat(t.offsetTop),n+=parseFloat(t.offsetLeft),t=t.offsetParent;return{top:Math.round(e),left:Math.round(n)}}return t.getBoundingClientRect?e(t):n(t)}window._getOffset=n,window._anim=t}();