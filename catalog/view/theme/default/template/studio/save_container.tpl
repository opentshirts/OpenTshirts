<script type="text/javascript">
$(function() {

	$(document).bind("onStudioIdChange", function(event, studio_id) {
		$("#save_studio_id").val(studio_id);
	});

	$(document).bind("onSaveDesignCompletedSuccessfully", function(event) {
		onSaveDesignCompletedSuccessfullyHandler();
		
	});

	$(document).bind("onSaveDesignError", function(event, errorStr) {
		onSaveDesignErrorHandler();
	});

});

//called from Add to cart button and save desing button on toolbar
function saveDesign(addToCart) {
	var studio_id = ($( "#save_studio_id" ).val()!="")?'&studio_id=' + $( "#save_studio_id" ).val():'';
	var add = (addToCart != null)?'&add=1':'';
	loadPopUp('index.php?route=studio/save' + studio_id + add);
}
</script> 
<input type="hidden" value="" id="save_studio_id" />