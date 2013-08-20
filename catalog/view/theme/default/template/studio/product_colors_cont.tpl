<style type="text/css">
#product_color_container {
	position:absolute;
	display:none;
	margin: 2px;
	bottom: 0;
	left: 0;
	right: 0;
	pointer-events: none;
	text-align: center;
}
</style>
<style type="text/css">
#product_color_container ul li {
	margin: 2px;
	padding: 0;
	list-style: none;
	float: left;
	width: 25px;
	height: 25px;
}
#product_color_container ul {
	margin: 0;
	padding: 0;
}
</style>
<script type="text/javascript">
$(function() {
	$(document).bind("onProductChanged", function(event, product_id) {
		//show panel
		$( "#product_color_container" ).show();
		loadAjaxHtml("index.php?route=studio/product_colors/color_list", "#product_color_container", {product_id: product_id}, "POST");
	});
});
</script> 
<div id="product_color_container" align="center"><?php echo $color_list; ?></div>