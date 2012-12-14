
console.log("Piiiip");

$(function (){
	console.log("pip2");
	$.jGrowl("Hi!");	

	// Setting handlers...
	$("#login").click(function(){
		$.jGrowl("Click login!")
	});

	$("#register").click(function(){
		$.jGrowl("register!");
	});
})