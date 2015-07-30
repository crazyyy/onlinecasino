/* $(document).ready(function () {
	var windowW = $(window).width();

	if (windowW > 639) {
		$('.home-winnerFeedScroll').liMarquee({
			direction:'up',
			loop:-1,
			scrolldelay:0,
			scrollamount:30,
			circular:true,
			drag:true
		});
	} else {
		$('.home-winners_wrapper').css("overflow", "auto");
	}
}); */


$(document).ready(function() {
	setTimeout(function(){
		$('.home-winnerFeedScroll').liMarquee({
			direction: 'up',
			scrollamount: 30,
		});
	}, 5000);
});

