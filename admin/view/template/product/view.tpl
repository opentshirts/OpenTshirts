<div class="ui-widget-content ui-state-highlight" style="padding: 10px; margin: 10px;">
	<div><a onclick="$(this).parent().next().toggle();"><?php echo $text_help_create_views_header; ?></a></div>
	<div style="display:none"><?php echo $text_help_create_views_body; ?></div>
</div>
<?php if ($error_views) { ?>
<div class="ui-widget-content ui-state-error" style="padding: 5px; margin: 5px;"><?php echo $error_views; ?></div>
<?php } ?>
<?php if ($error_view_fills) { ?>
<div class="ui-widget-content ui-state-error" style="padding: 5px; margin: 5px;"><?php echo $error_view_fills; ?></div>
<?php } ?>
<?php if ($error_view_shade_underfill) { ?>
<div class="ui-widget-content ui-state-error" style="padding: 5px; margin: 5px;"><?php echo $error_view_shade_underfill; ?></div>
<?php } ?>
<?php if ($error_view_regions) { ?>
<div class="ui-widget-content ui-state-error" style="padding: 5px; margin: 5px;"><?php echo $error_view_regions; ?></div>
<?php } ?>
<?php if ($error_default_region) { ?>
<div class="ui-widget-content ui-state-error" style="padding: 5px; margin: 5px;"><?php echo $error_default_region; ?></div>
<?php } ?>
<span style="float:right; margin:10px;" ><img src="view/image/add.png" /><a onclick="addView()"><?php echo $button_add_view; ?></a></span>
<div style="clear:both;" align="left" id="views">
<?php foreach($views as $view) { ?>
<?php echo $view; ?>
<?php } ?>
</div>
<script language="javascript">
function addView() {
	$.get('index.php?route=product/view/form&token=<?php echo $token; ?>',
	   function(data){
		   $('#views').append(data);
		   setNumColors($('input[name="colors_number"]:checked').val());
	});
}
function removeView(view_index) {
	$('#view_' + view_index).remove();
}
//---------------------------------
function addRegion(view_index) {
	$.get('index.php?route=product/region/form&token=<?php echo $token; ?>&product_id=<?php echo $product_id; ?>&view_index='+view_index,
	   function(data){
		   $('#regions_' + view_index).append(data);
	});
}
function updateRegion(view_index, region_index) {
	var name = $('input[name="views[' + view_index + '][regions][' + region_index + '][name]"]').val();
	var width = $('input[name="views[' + view_index + '][regions][' + region_index + '][width]"]').val();
	var height = $('input[name="views[' + view_index + '][regions][' + region_index + '][height]"]').val();
	swfobject.getObjectById("view_drawer_" + view_index).updateRegion(region_index, width, height, name);
}
function removeRegion(view_index, region_index) {
	$('#region_' + view_index + '_' + region_index).remove();
	swfobject.getObjectById("view_drawer_" + view_index).removeRegion(region_index);
}
function addFill(view_index) {
	var url = 'index.php?route=product/view/fill&token=<?php echo $token; ?>&view_index='+view_index;	
	$.get(url, function(data) {
		   $('#fills_' + view_index).append(data);
	});
}
function removeFill(view_index) {
	$('#fills_' + view_index + ' > table:last').remove();
}
//------------------------------------

//callbacks from actionscript
function drawerCreationComplete(view_index) {
	$('#button_add_region_' + view_index).show();
	swfobject.getObjectById("view_drawer_" + view_index).updateScale($('input[name="views[' + view_index + '][regions_scale]"]').val());
	swfobject.getObjectById("view_drawer_" + view_index).setShade($('#shade_url_' + view_index).val());
	swfobject.getObjectById("view_drawer_" + view_index).setUnderfill($('#underfill_url_' + view_index).val());
	
	//trigger event for add previous created regions
	$(document).trigger('creation_complete_' + view_index);
}
function onScaleUpdated(view_index, scale) {
	$('input[name="views[' + view_index + '][regions_scale]"]').val(scale);
	$('#span_scale_' + view_index).html(scale);
}
function onRegionPositionUpdated(view_index, region_index, x, y) {
	$('input[name="views[' + view_index + '][regions][' + region_index + '][x]"]').val(x);
	$('input[name="views[' + view_index + '][regions][' + region_index + '][y]"]').val(y);
	
	$('#span_x_' + view_index + '_' + region_index).html(x);
	$('#span_y_' + view_index + '_' + region_index).html(y);

}
</script>
