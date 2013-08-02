<style type="text/css">
#price_container {
	position:absolute;
	display:none;
}
</style>
<script type="text/javascript">
$(function() {

	$(document).bind("onStudioIdChange", function(event, studio_id) {
		$("#price_studio_id").val(studio_id);	
		$( "#prices_form" ).submit();
	});

	$(document).bind("onProductChanged", function(event) {
		//show panel
		$( "#price_container" ).show();
		$( "#prices_form" ).submit();
	});

	$(document).bind("onPriceChange", function(event) {
		$( "#prices_form" ).submit();
	});

	$(document).bind("onPrintingMethodChange", function(event, printing_method) {
		$( "#prices_form" ).submit();
	});

	$( "#price_container" ).draggable({ handle: ".drag_handle" });

});
</script> 
<div id="price_container"><?php echo $price; ?></div>