(function(){
    document.addEventListener( "DOMContentLoaded", ready, false);

    function ready(){
        var list = document.querySelectorAll(".accordion"),
            a = document.querySelectorAll(".accordion > h3 > a"),
            menu = document.querySelector("a.anchor");

        $accord(list);

        menu.addEventListener("click", function(e){
            var el = e.currentTarget,
                scrollT = window.screenTop,
                href = el.getAttribute("href"),
                to = document.querySelector(href),
                top = _getOffset(to).top;

            _anim({
                el : window,
                from : scrollT,
                to : top,
                time : 600,
                scroll : true
            });

            e.preventDefault();
        }, false)

        for (var i = 0; i< a.length; i++){
            a[i].addEventListener("click", function(e){
                e.preventDefault();
            }, false)
        }
    }

})();

(function(){
    function wrap(el, opt) {
        var new_,
            len;

        if (!(el instanceof NodeList) && !(el instanceof Node)) return false;

        len = el.length;

        while(len--){
            new_ = new accordion(el[len], opt);
        }
        return new_;
    }

    function accordion(el, opt) {
        this.el = el;
        this.options = {
            event : "click",
            active : 1
        }

        for (i in opt) this.options[i] = opt[i];

        this.data = {};
        this.init();
    }

    accordion.prototype = {
        init: function(){
            this.children = this.el.children;
            this.titles = this.getEvenOdd(this.children, true);
            this.boxs = this.getEvenOdd(this.children, false);

            this.hide(this.boxs);
            this.show(this.boxs[this.options.active - 1]);

            this.bind(this.options.event, this.titles, false);
        },
        handleEvent: function (e) {
            var el_target = e.currentTarget,
                nextBox = this.next(el_target),
                otherBoxs = this.siblingArr(this.boxs, nextBox),
                otherTitles = this.siblingArr(this.titles, el_target);

            this.hide(otherBoxs);
            this.removeClass(otherTitles, "active");

            this.toggle(nextBox);
            this.toggleClass(el_target, "active");
        },
        bind: function (type, el, bubble) {
            var el = el.length ? el : [el],
                i = 0,
                j = el.length;

            for ( i = 0; i < j; i++ ) {
                el[i].addEventListener(type, this, !!bubble);
            }
        },
        getEvenOdd : function( el, even ) {
            var el = el.length ? el : [el],
                r = [],
                d = even ? 0 : 1;

            for ( var i = 0; i < el.length; i++ ) {
                if ( i % 2 == d ) {
                    r.push( el[i] );
                }
            }

            return r;
        },
        siblingArr: function(arr, el){
            var r = [];

            for (var i = 0 ; i < arr.length; i++ ) {
                if ( arr[i].nodeType === 1 && arr[i] !== el ) {
                    r.push( arr[i] );
                }
            }

            return r;
        },
        next: function( el ) {
            var n = el.nextSibling;

            for ( ; n; n = n.nextSibling ) {
                if ( n.nodeType === 1 ) {
                    return n;
                }
            }
        },
        hide: function( el, speed ) {
            var el = el.length ? el : [el],
                i = 0,
                j = el.length;

            for ( i = 0; i < j; i++ ) {
                el[i].style.display = "none";
            }
        },
        show: function( el, speed ) {
            var el = el.length ? el : [el],
                i = 0,
                j = el.length || 0;

            for ( i = 0; i < j; i++ ) {
                el[i].style.display = "block";
            }
        },
        toggle: function(el, speed){
            var that = this,
                el = el.length ? el : [el],
                i = 0,
                j = el.length;

            for ( i = 0; i < j; i++ ) {
                inner(el[i]);
            }

            function inner(elem){
                if (that.isHidden(elem)) {
                    that.show(elem);
                }
                else {
                    that.hide(elem);
                }
            }
        },
        isHidden: function(el){
            var display = window.getComputedStyle(el, null).display,
                vissible = window.getComputedStyle(el, null).vissible,
                height = window.getComputedStyle(el, null).height,
                out = (display == "none" || vissible == "hidden" || (height == 0 || height == "0px")) ? true : false;

            return out;
        },
        removeClass: function(el, name){
            var that = this,
                el = el.length ? el : [el],
                i = 0,
                j = el.length;

            for ( i = 0; i < j; i++ ) {
                var _class = el[i].className || "";

                _class = _class.replace(name, "");
                el[i].className = _class;
            }
        },
        toggleClass: function(el, name){
            var that = this,
                el = el.length ? el : [el],
                i = 0,
                j = el.length;

            for ( i = 0; i < j; i++ ) {
                var _class = el[i].className || "",
                    reg = new RegExp(name, "i");

                if (reg.test(_class)) {
                    _class = _class.replace(reg, "");
                }
                else {
                    _class = _class + " " + name;
                }

                el[i].className = _class;
            }
        }
    }

    window.$accord = wrap;
}());

(function(){
    function anim( opt ){
        var element = opt.el;
        var from = opt.from;
        var to = opt.to;
        var duration = opt.time;
        var start = new Date().getTime();

        setTimeout(function() {
            var now = (new Date().getTime()) - start;
            var progress = now / duration;
            var result = (to - from) * delta(progress) + from;

            if (opt.style) {
                element.style.left = result + opt.unit;
            }
            else if (opt.scroll) {
                window.scroll(0, result);
            }

            if (progress < 1) {
                setTimeout(arguments.callee, 10);
            }
        }, 10);
    }

    function delta(a){
        return a;
    }

    function getOffset(elem) {
        if (elem.getBoundingClientRect) {
            // "правильный" вариант
            return getOffsetRect(elem)
        } else {
            // пусть работает хоть как-то
            return getOffsetSum(elem)
        }

        function getOffsetRect(elem) {
            // (1)
            var box = elem.getBoundingClientRect()

            // (2)
            var body = document.body
            var docElem = document.documentElement

            // (3)
            var scrollTop = window.pageYOffset || docElem.scrollTop || body.scrollTop
            var scrollLeft = window.pageXOffset || docElem.scrollLeft || body.scrollLeft

            // (4)
            var clientTop = docElem.clientTop || body.clientTop || 0
            var clientLeft = docElem.clientLeft || body.clientLeft || 0

            // (5)
            var top  = box.top +  scrollTop - clientTop
            var left = box.left + scrollLeft - clientLeft

            return { top: Math.round(top), left: Math.round(left) }
        }

        function getOffsetSum(elem) {
            var top=0, left=0
            while(elem) {
                top = top + parseFloat(elem.offsetTop)
                left = left + parseFloat(elem.offsetLeft)
                elem = elem.offsetParent
            }

            return {top: Math.round(top), left: Math.round(left)}
        }
    }

    window._getOffset = getOffset;
    window._anim = anim;
})()