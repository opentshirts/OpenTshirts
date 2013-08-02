<style type="text/css">
#div_toolbar
{
	position:absolute; 
	top:37px;
	left: 6px;
	padding:10px 5px 5px 5px;
	font-size: .8em;
}
</style>
<div id="div_toolbar" class="ui-widget-content ui-corner-all" style="display:none; white-space:nowrap; cursor:move;">
	<a id="btn_select_product"><?php echo $toolbar_text_select_product; ?></a>
	<a id="btn_add_clipart"><?php echo $toolbar_text_add_clipart; ?></a>
	<a id="btn_add_text"><span class="ot_ui-icon ot_ui-icon-text"></span><?php echo $toolbar_text_add_text; ?></a>
	<a id="btn_import_template"><?php echo $toolbar_text_import_template; ?></a>
	<a id="btn_save_composition"><?php echo $toolbar_text_save; ?></a>
	<?php if($show_export_image) { ?>
	<a id="btn_export_image"><?php echo $toolbar_text_export_image; ?></a>
	<?php } ?>
</div>
<script type="text/javascript" language="javascript">
$(function() {
	$( "#btn_add_clipart" ).button({
			icons: {
					primary: "ot_ui-icon-clipart"
			}
	}).click(function() {
			showClipartList();
	});

	$( "#btn_add_text" ).button({
					icons: {
							primary: "ot_ui-icon-text"
					}
	}).click(function() {
			studioAddText();
	});
	
	$( "#btn_select_product" ).button({
					icons: {
							primary: "ot_ui-icon-product"
					}
	}).click(function() {
			showProductList();
	});
	
	$( "#btn_import_template" ).button({
					icons: {
							primary: "ot_ui-icon-template"
					}
	}).click(function() {
			showTemplateList();
	});
	
	$( "#btn_save_composition" ).button({
					icons: {
							primary: "ot_ui-icon-save"
					}
	}).click(function() {
			saveDesign();
	});

	$( "#btn_export_image" ).button({
					icons: {
							primary: "ui-icon-refresh"
					}
	}).click(function() {
		studioExportImage();
	});
	
	
	$( "#div_toolbar" ).draggable({ axis: "x" });
	
	$(document).bind("onApplicationReady", function(event) {
		$( "#div_toolbar" ).fadeIn(500);
	});

	
});

</script>

