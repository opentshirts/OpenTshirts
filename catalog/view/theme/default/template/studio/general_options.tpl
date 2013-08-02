<!-- /* temporary hide this panel*/
<style>
#div_general_options
{
	font-size: 0.7em;
	position:absolute; 
	top:340px;
	left: 6px;
	padding:5px;
}
#div_general_options a
{
	margin:2px;
}
</style>
<div id="div_general_options" class="ui-widget-content ui-corner-all" style="display:none; white-space:pre-line; cursor:move;">
	<a id="btn_general_options_select_all"><?php echo $general_options_text_select_all; ?></a>
	<a id="btn_general_options_clear_selection"><?php echo $general_options_text_clear_selection; ?></a>
	<a id="btn_general_options_duplicate"><?php echo $general_options_text_duplicate; ?></a>
	<a id="btn_general_options_fit_to_area"><?php echo $general_options_text_fit_to_area; ?></a>
	<a id="btn_general_options_undo"><?php echo $general_options_text_undo; ?></a>
	<a id="btn_general_options_redo"><?php echo $general_options_text_redo; ?></a>
</div>
<script type="text/javascript" language="javascript">
$(function() {

	$( "#btn_general_options_select_all" ).button({	icons: {primary: "ui-icon-arrow-4-diag"	}, text: true}).click(function() {studioSelectAll();});

	$( "#btn_general_options_clear_selection" ).button({icons: {primary: "ui-icon-cancel"},text: true}).click(function() {studioClearSelection();});
	
	$( "#btn_general_options_duplicate" ).button({icons: {primary: "ui-icon-copy"},text: true}).click(function() {studioDuplicate();});

	$( "#btn_general_options_fit_to_area" ).button({icons: {primary: "ui-icon-arrow-4-diag"	},text: true}).click(function() {studioFitToArea();});

	$( "#btn_general_options_undo" ).button({icons: {primary: "ui-icon-arrowreturnthick-1-w"	},text: true}).click(function() {studioUndo();});
	
	$( "#btn_general_options_redo" ).button({icons: {primary: "ui-icon-arrowreturnthick-1-e"	},text: true}).click(function() {studioRedo();});
	
	$( "#div_general_options" ).draggable();
	
	$(document).bind("onApplicationReady", function(event) {
		$( "#div_general_options" ).fadeIn(500);
	});

	
});

</script>
 -->