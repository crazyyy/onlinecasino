!function(e){var n="screen and (max-width:1010px), screen and (max-device-width:1024px)",i="#nav";mobileMenuIdentifier="ocau-mobile-menu",menuCategoryIdentifier="li.section_top",mobileMenuInsert="#main_area",reduceList=!1,slickNavNative=!1,menuText="MENU",slickNavAjax="ajax/easy-mobile-menu-ajax.html",slickNavEngaged=!1,slickNavInitiated=!1;var a={initialState:function(){var e=(a.checkSize(),a.checkMediaQuery());1==e&&t.slicknavEngage(),a.checkResize(),console.log("running!")},checkResize:function(){e(window).resize(function(){var e=a.checkMediaQuery();1==e&&0==slickNavEngaged&&0==slickNavInitiated?t.slicknavEngage():1==e&&0==slickNavEngaged&&1==slickNavInitiated?t.slicknavShow():0==e&&1==slickNavEngaged&&t.slicknavHide()})},checkSize:function(){return $size=e(window).width(),$size},checkHeight:function(){var n=e(window).height();return n},checkMediaQuery:function(){return e.mobile.media(n)}},t={slicknavEngage:function(){e("#"+mobileMenuIdentifier).slicknav({prependTo:mobileMenuInsert,label:menuText}),slickNavEngaged=!0,slickNavInitiated=!0,t.desktopMenuHide(),console.log("engaged")},slicknavShow:function(){e(".slicknav_menu").show(),slickNavEngaged=!0,t.desktopMenuHide(),console.log("shown")},slicknavHide:function(){e(".slicknav_menu").hide(),slickNavEngaged=!1,t.desktopMenuShow(),console.log("hidden")},desktopMenuShow:function(){e(i).show()},desktopMenuHide:function(){e(i).hide()}},c={start:function(){var n=e(i),a=e(menuCategoryIdentifier),t=e(n.find("ul"));$newMenu=e("<div>").attr("id",mobileMenuIdentifier),0!=slickNavAjax?(c.ajaxMobileMenu($newMenu),console.log("ajax!")):1!=slickNavNative?(c.makeNewMenu(a,t,$newMenu),console.log("rebuilding")):(c.useCurrentMenu(n,$newMenu),console.log("using current"))},ajaxMobileMenu:function(n){e.ajax({type:"GET",url:slickNavAjax,success:function(e){n.append(e),c.engageRebuiltMenu(n)}})},makeNewMenu:function(n,i,a){n.each(function(n){if(1==reduceList){var t=i.eq(n).children("li").clone().slice(1);c=e("<ul>").append(t).html()}else var c=i.eq(n).html();var u=e(this).text();a.append("<li>"+u+"<ul>"+c+"</ul></li>")}),c.engageRebuiltMenu(a)},useCurrentMenu:function(e,n){$menuParentClone=e.clone().attr("class","thingybob"),n.append($menuParentClone),c.engageRebuiltMenu(n)},engageRebuiltMenu:function(e){e.appendTo("body").hide(),a.initialState()}};e(document).ready(c.start)}(jQuery);