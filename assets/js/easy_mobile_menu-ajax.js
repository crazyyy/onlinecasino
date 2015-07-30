(function($){


var mobileBreakPoint = 'screen and (max-width:1010px), screen and (max-device-width:1024px)', //Set mobileBreakPoint to the screenwidth at which the regular desktop menu is no longer needed and a top mobile menu is needed instead	
    menuIdentifier = '#nav' //parent id or class of menu container
	mobileMenuIdentifier = 'ocau-mobile-menu',//id of new mobile menu
	menuCategoryIdentifier = 'li.section_top'; //target for menu category headers
	mobileMenuInsert = '#main_area'; //div from which mobile menu will be prepended to
	reduceList = false; //if the menu category is part of the LI and not its own separate entity, set this to true, otherwise false.
	slickNavNative = false; //set to true if no menu rebuilding is necessary
	menuText = 'MENU', //if different text is needed for the hamburger text, change it here
	slickNavAjax = 'http://www.onlinecasino.com.au/js/easy-mobile-menu-ajax.php', //if you need to ajax in the menu, create on and then put the full file path here, otherwise false. 
	slickNavEngaged = false, //always false
    slickNavInitiated = false; //always false
	
	
	
	
var screenwidth={
	  //function to check initial state on page load and decide whether or not we need to initiate slicknav
	  initialState:function(){
		 var initialWidth = screenwidth.checkSize(),
             currentMenuIndicator = screenwidth.checkMediaQuery(); 
			 if(currentMenuIndicator == true){
	             mobilemenu.slicknavEngage();
			 }
		     screenwidth.checkResize();
		     console.log('running!');
		  
	  },
	  //function to decide during window resize events if we need to show or hide slicknav
	  checkResize: function(){
			  $(window).resize(function() {
				  var belowThreshold = screenwidth.checkMediaQuery();
					if(belowThreshold == true && slickNavEngaged == false && slickNavInitiated == false){
						mobilemenu.slicknavEngage();
					}
					else if(belowThreshold == true && slickNavEngaged == false && slickNavInitiated == true){
						mobilemenu.slicknavShow();
					}
					else if(belowThreshold == false && slickNavEngaged == true){
						mobilemenu.slicknavHide();
				    }
					else{
					}
			  })
	  },
	  
	  //simple function to return screen width
	  checkSize:function(){
			  $size = $(window).width();
			  return $size;
	  },
	  //simple function to return screen height (not currently called in this script)
	  checkHeight:function(){
		  var $height = $(window).height();
		  return $height;
	  },
	  checkMediaQuery: function(){
		 return $.mobile.media(mobileBreakPoint);
	  }	  
	  
	  
	 
}

var mobilemenu={
	//all functions in mobilemenu are used to initiate, show or hide slicknav
	 slicknavEngage: function(){
		 $('#'+mobileMenuIdentifier).slicknav({
		       prependTo: mobileMenuInsert,
			   label: menuText
           });
		 slickNavEngaged = true;
		 slickNavInitiated = true;
		 mobilemenu.desktopMenuHide();
         console.log('engaged');
	 },
	 
	 slicknavShow: function(){
		 $('.slicknav_menu').show();
		 slickNavEngaged = true;
		 mobilemenu.desktopMenuHide();
		          console.log('shown');

	 },
	 
	 slicknavHide: function(){
		 $('.slicknav_menu').hide();
		 slickNavEngaged = false;
		 mobilemenu.desktopMenuShow();
		          console.log('hidden');

	 },
	 
	 desktopMenuShow:function(){
       $(menuIdentifier).show();
	 },
	 
	 desktopMenuHide:function(){
       $(menuIdentifier).hide();
	 }
}

//function to rebuild menu into a structure that works well with slicknav. If no rebuilding is necessary, function simply clones regular menu for use as mobile menu
var rebuildmenu={
	
	start:function(){

		var $menuParent = $(menuIdentifier),
		    $menuCategories = $(menuCategoryIdentifier),
			$unorderedList = $($menuParent.find('ul'));
			$newMenu = $('<div>').attr('id',mobileMenuIdentifier);
			 
		if(slickNavAjax != false){
			rebuildmenu.ajaxMobileMenu($newMenu);
			console.log('ajax!');
		}
			 
		else if(slickNavNative != true){
              rebuildmenu.makeNewMenu($menuCategories, $unorderedList, $newMenu)
               console.log('rebuilding');
		}
		else{
			rebuildmenu.useCurrentMenu($menuParent,$newMenu);
			   console.log('using current');

		}
	},
	
	
	ajaxMobileMenu:function($newMenu){
		$.ajax({
            type:"GET",
            url: slickNavAjax,
            success: function(data) {
			$newMenu.append(data);
            rebuildmenu.engageRebuiltMenu($newMenu);
            }

     });

	},
	
	makeNewMenu:function($menuCategories, $unorderedList, $newMenu){
				 $menuCategories.each(function(i){
					if(reduceList == true){
						var $listReduce = $unorderedList.eq(i).children('li').clone().slice(1);
							$curList = $('<ul>').append($listReduce).html();
					}
					else{
						var $curList = $unorderedList.eq(i).html();	
					 }
			
					 var header = $(this).text();
					   $newMenu.append('<li>'+header+'<ul>'+$curList+'</ul></li>');
				});	
			    rebuildmenu.engageRebuiltMenu($newMenu);
	},
	
	useCurrentMenu:function($menuParent,$newMenu){
			$menuParentClone = $menuParent.clone().attr('class','thingybob');
			$newMenu.append($menuParentClone);
			rebuildmenu.engageRebuiltMenu($newMenu);
		
	},
	
	engageRebuiltMenu:function($newMenu){
		$newMenu.appendTo('body').hide();
	    screenwidth.initialState();
		
	}
}

$(document).ready(rebuildmenu.start);
})(jQuery);
