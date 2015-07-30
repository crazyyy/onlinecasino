
var free ={
	start: function(){
		free.initFilterToggle();
		free.getFilter();
		//free.getGameCount();
		$colThree = $('.filter-data').children('.col:eq(2)').children('.value');
	    $updateThree = $('.free-games-block').children('.game-block').length;
		//free.countImagesLoading();
		getCount =  setInterval(free.updateImagesLoading,100);
	},//end function
	
	initFilterToggle: function(){
		
		/*$('.row').on('click','a.filter-lnk',function(e){
			e.preventDefault();
			$target = $(this);
			$form = $('#form_hold');
			$parent =  $(this).parent().parent().parent();
			if($parent.hasClass('open')){
				$parent.removeClass('open');
				$form.slideUp('fast');
			}
			else{
				$parent.addClass('open');
				$form.slideDown('fast');
			}
		});*/
		$form = $('#form_hold');
		$form.slideDown('fast');

		
	}, //end initFilterToggle
	
	getFilter: function(){
		
		$('#form_hold').on('change','select',function(){
		 $listOne   = $('#sort-games').val();
		 $listTwo   = $('#by-software').val();
		 $listThree = $('#game-type').val();
		 
		 free.constructFilter($listOne,$listTwo,$listThree);
	    });
		
		
	},//end getfilter
	
	   constructFilter:function(one,two,three){
		$.ajax({
            type:"GET",
            beforeSend: function (request)
            {
                request.setRequestHeader("authorize", sessionAuthorize);
            },
            url: 'http://www.onlinecasino.com.au/free-games/free_games/filter_return.php?one='+one+'&two='+two+'&three='+three,
            success: function(data) {
                $('.free-games-block').html(data);
				free.updateFilterOnScreen(one,two);
 				free.justGetImages();
				lightbox.start();
	 			//lazy.start();
				
$.ajax({
type: "POST",
url: 'http://www.onlinecasino.com.au/free-games/games_count.php?getParam1='+one+'&getParam2='+two+'&getParam3='+three,
cache: false,
success: function(html){

$(".filter-panel .col:last-child").html(html);

}
});
            }

     });

	},//end constructfilter
	
	updateFilterOnScreen: function(one,two){
	  $colOne = $('.filter-data').children('.col:eq(0)');
	  $colTwo = $('.filter-data').children('.col:eq(1)');
	  $updateOne = $('#sort-games').find(":selected").text();
	  $updateTwo = $('#by-software').find(":selected").text();
	  $updateThree = $('#game-type').find(":selected").text();
	  
      $colOne.html('Sorted: '+$updateOne);
	  if($updateThree =='All'){
	  $colTwo.html('Filter: '+$updateTwo);
	  }
	  else{
	  $colTwo.html('Filters: '+$updateTwo+', '+$updateThree);
	  }
	},//end updatefilteronscreen
	getGameCount:function(){
	  $colThree = $('.filter-data').children('.col:eq(2)').children('.value');
	  $colThree.html($updateThree);
	  $colThree.css({'fontWeight':'bold',
	                 'color':'#090'
	                 });
	  console.log($updateThree);
			
	},
	countImagesLoading:function(){
	  imgCount = 0;
	  $img = $('.free-games-block').children('.game-block').children('a').children('img');
	  $img.one('load',function() {
		  //$colThree.html('<strong>'+imgCount+'</strong>');
		  		  imgCount++;
	  });

	},
	justGetImages: function(){
	  $filterImg = $('.free-games-block').children('.game-block').children('a').children('img');
	  $colThree.html($filterImg.length);	
	  $colThree.css({'fontWeight':'bold',
	                 'color':'#090'
	                 });
	},
	/* updateImagesLoading: function(){
	  $colThree.html(imgCount);	
	  $colThree.css({'fontWeight':'bold',
	                 'color':'#090'
	                 });

	},*/

	resetFilter:function(){
		  /* $listReset = $('.filters-area li');
            if($listReset.hasClass('active')){
				$listReset.removeClass('active');
			    filter.applyClass($('#az').parent());
				filter.constructFilter(null,'az');
			}	*/   
	},//end resetFilter
	

}
//end var free======================================================================================================================================================================================

var lightbox={
	 start: function(){
		 lightbox.lightboxHide();
		 lightbox.initGames();
		 lightbox.closeLightbox();
	 },
	 
	 initGames:function(){
		 

		 
		 
		 //$('.game-block').on('click','.popover',function(e){
		 $(document).off('click', '.popover').on('click', '.popover', function(e){
			 e.preventDefault();
			 console.log('happening');
			 var id = $(this).attr('name');
			  $.ajax({
				  type:"GET",
				  beforeSend: function (request)
				  {
					  request.setRequestHeader("authorize", sessionAuthorize);
				  },
				  url: 'http://www.onlinecasino.com.au/free-games/free_games/filter_return.php?type='+id,
				  success: function(data) {
					  lightbox.createScreen();
					  lightbox.lightboxShow();
					  lightbox.appendGame(data);
					  lightbox.addId(id);
					  lightbox.trackClick(id);
					  rating.start();	

				  }
		      });
		 });
		 
		 
	 },
	createScreen: function(){
         var $screenElement =
			 $('<div></div>')
			   .attr('id','modalscreen')
			   .css(
			         {
					   position:'fixed',
					   width:'100%',
					   height:'100%',
					   zIndex:998,
					   backgroundColor: '#000000',
                       opacity: '0.5'				   					   
					   
				     }
			)
			lightbox.modifyStyles();
			lightbox.showScreen($screenElement);
	},
	showScreen: function(e){
				e.prependTo(document.body);
	},//end showScreen	
	modifyStyles: function(){
		$('.lightbox').css(
		                     {
							  marginTop: '-261px',
							  marginLeft: '-484px',
							  top: '50%',
							  left: '50%',
							  position: 'fixed',
							  zIndex: '9999'							   
						     }
						   )
	},
	trackClick: function(e){
		$.ajax({
		type:"POST",
		beforeSend: function (request)
		{
			request.setRequestHeader("authorize", sessionAuthorize);
		},
		url: 'http://www.onlinecasino.com.au/free-games/free_games/click_track.php?game='+e,
		 success: function(data) {
			 console.log('click successfully tracked');
		}
	  });
		
	},
	addId: function(e){
       $('span.rating').attr('id',e);
	},
	appendGame: function(e){
		var $game = '<iframe frameBorder="0" style="margin-left:10px;" src="'+e+'" height="504px" width="720"></iframe>';
		$('.game-holder').append($game);
	},
	removeGame: function(){
		$('.game-holder').empty();
	},
	closeLightbox: function(){
		$('div.lightbox-inner').on('click','a.lnk-close',function(e){
			  e.preventDefault();
			  lightbox.lightboxHide();
			  lightbox.screenHide();
			  lightbox.removeGame();
		});
	},
	screenHide: function(){
		$('#modalscreen').remove();
	},
	lightboxHide: function(){
		$('.lightbox').hide();
		$('span.rating_label').html('Help us rate this game');
		$('span.rating').attr('class','rating rating_00');
	},
	lightboxShow: function(){
		$('.lightbox').show();
	}		
		
}

//end var lightbox========================================================================================================================================================================================

var rating={
	start: function(){
       $('div.game-info').on('mousemove','span.rating',function(e){
	   
	   var x = e.pageX - $(this).offset().left
       var y = e.pageY - $(this).offset().top
	   
       //rating.makeBold();

			if(x>'0' && x<'12'){
			 $(this).attr('class','rating rating_05')	
			}
			else if(x>'12' && x<'24'){
			 $(this).attr('class','rating rating_10')	
			}
			else if(x>'24' && x<'36'){
			 $(this).attr('class','rating rating_15')	
			}
			else if(x>'36' && x<'48'){
			 $(this).attr('class','rating rating_20')	
			}
			else if(x>'48' && x<'60'){
			 $(this).attr('class','rating rating_25')	
			}
			else if(x>'60' && x<'72'){
			 $(this).attr('class','rating rating_30')	
			}
			else if(x>'72' && x<'84'){
			 $(this).attr('class','rating rating_35')	
			}
			else if(x>'84' && x<'96'){
			 $(this).attr('class','rating rating_40')	
			}
			else if(x>'96' && x<'108'){
			 $(this).attr('class','rating rating_45')	
			}
			else if(x>'108' && x<'120'){
			 $(this).attr('class','rating rating_50')	
			}
	   }).on('mouseleave','span.rating', function(){
		     $(this).attr('class','rating rating_00');
			// rating.removeBold();	
		   
	   }).on('click','span.rating', function(){
		   var ratingId = ($(this).attr('id'));
		   var ratingClass = ($(this).attr('class'));
           var ratingNum = ratingClass.replace(/[^0-9]/g, '')
		   rating.sendRating(ratingId,ratingNum)
	   })
		    	
  },//end start
     sendRating:function(e,f){
		$.ajax({
		type:"POST",
		beforeSend: function (request)
		{
			request.setRequestHeader("authorize", sessionAuthorize);
		    rating.disableHandler()	   
		},
		url: 'http://www.onlinecasino.com.au/free-games/free_games/write_rating.php?game='+e+'&rating='+f,
		success: function(data) {
		}
	});

   },//end sendrating
     disableHandler:function(){
       $('div.game-info').off('mousemove','span.rating')
                .off('mouseleave','span.rating')	
		        .off('click','span.rating');
	rating.endingEffects();
   },//end disableHandler
     endingEffects: function(){
		$('span.rating_label').html('<strong>Thanks For Your Rating!</strong>');
   }


}
//end var rating==========================================================================================================================================================================================

$(function() {
 
$('.more_button').live("click",function()
{
var getId = $(this).attr("id");
var getParam1 = $(this).data("param1");
var getParam2 = $(this).data("param2");
var getParam3 = $(this).data("param3");
var numItems1 = $('.game-block').length;

var listOne   = $('#sort-games').val();
		 var listTwo   = $('#by-software').val();
		 var listThree = $('#game-type').val();

if(getId)
{
$("#load_more_"+getId).attr("disabled", "disabled"); 
$.ajax({
type: "POST",
url: "http://www.onlinecasino.com.au/free-games/more_content.php",
data: "getLastContentId="+ getId + "&getParam1="+ listOne + "&getParam2="+ listTwo + "&getParam3="+ listThree + "&numItems="+ numItems1,
cache: false,
success: function(html){
$(".free-games-block").append(html);
$("#more_div"+getId).remove();

}
});
}
else
{
$(".more_tab").html('<div class="more_button">No more games.</div>');
}
return false;
});
});

$.ajax({
type: "POST",
url: "http://www.onlinecasino.com.au/free-games/games_count.php",
data: "getParam2=all&getParam3=all",
cache: false,
success: function(html){

$(".filter-panel .col:last-child").html(html);

}
});

/* var lazy={
	start: function(){
 		$("img.lazyfree").lazyload({ threshold : 600 });
 	}
} */

$(document).ready(free.start);
$(document).ready(lightbox.start);
//$(document).ready(lazy.start);
$(document).ready(function(){
$(function () {
		$('#back-top').hide();
		$(window).scroll(function () {
			if ($(this).scrollTop() > 200) {
				$('#back-top').fadeIn();
			} else {
				$('#back-top').fadeOut();
			}
		});

		// scroll body to 0px on click
		$('#back-top a').click(function () {
			$('body,html').animate({
				scrollTop: 0
			}, 800);
			return false;
		});
	});
});


/*
$(window).load(function() {
	  if(imgCount == $updateThree){
	     clearInterval(getCount);
	  }
	  else{
	     clearInterval(getCount);
		 $colThree.html('<strong>'+$updateThree+'</strong>');	
	  }
}); */