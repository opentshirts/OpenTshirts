<script type="text/javascript" language="javascript">
$(function() {

	$( "#btn_zoom_in" ).button({
			icons: {
					primary: "ui-icon-zoomin"
			},
      text: false
	}).click(function() {
			studioZoomIn();
	});

	$( "#btn_zoom_out" ).button({
			icons: {
					primary: "ui-icon-zoomout"
			},
			text: false
	}).click(function() {
			studioZoomOut();
	});
	
	$( "#btn_zoom_area" ).button({
			icons: {
					primary: "ui-icon-search"
			},
			text: false

	}).click(function() {
			studioZoomArea();
	});
	
	
	$( "#div_zoom" ).draggable({ axis: "y" });
	
	$(document).bind("onApplicationReady", function(event) {
		$( "#div_zoom" ).fadeIn(500);
	});

	
});

</script>
<style>
#div_zoom
{
	position:absolute; 
	top:82px;
	left: 6px;
	padding:10px 5px 5px 5px;
}
#div_zoom a
{
	margin:2px;
}
</style>
<div id="div_zoom" class="ui-widget-content ui-corner-all" style="display:none; white-space:pre-line; cursor:move;">
	<a id="btn_zoom_in" class=" is_ml" ml_label="zoom_text_zoom_in"  ml_attr="title"><?php echo $zoom_text_zoom_in; ?></a>
	<a id="btn_zoom_area" class=" is_ml" ml_label="zoom_text_zoom_area"  ml_attr="title"><?php echo $zoom_text_zoom_area; ?></a>
	<a id="btn_zoom_out" class=" is_ml" ml_label="zoom_text_zoom_out"  ml_attr="title"><?php echo $zoom_text_zoom_out; ?></a>
</div>