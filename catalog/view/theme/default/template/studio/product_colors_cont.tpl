<style type="text/css">
#product_color_container {
	position:absolute;
	display:none;
	margin: 2px;
	bottom: 0;
	left: 300px;
	right: 300px;
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
<div id="product_color_container"><?php echo $color_list; ?></div>