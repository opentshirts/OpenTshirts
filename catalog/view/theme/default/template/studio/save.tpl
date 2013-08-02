<div style="padding:10px; text-align:left">
	<div id="div_save_design_form" style="display:none;">
		<span><?php echo $entry_design_name; ?></span>
		<input type="text" id="design_name" value="<?php echo $design_name; ?>" style="width:200px;">
		<div align="center" style="margin-top:10px">
			<input id="btn_save_design" type="button" value="<?php echo $text_save_design; ?>" >
		</div>
	</div>
	<div id="div_saving_design" style="display:none;">
		<div ><?php echo $text_saving_design; ?></div>
		<img src="<?php echo $loading_image; ?>" border="0" />
	</div>
	<div id="div_saving_successfully" style="display:none; width: 300px;">
		<div><?php echo $text_saved_successfully; ?></div>
	</div>
	<div id="div_saving_error" style="display:none;">
		<div><?php echo $text_saved_error; ?></div>
		<div id="save_error_info"></div>
	</div>
</div>
<script type="text/javascript" language="javascript">
$(function() {

	/*
	cannot bind here because it would be bundled each time is reloaded
	$(document).bind("onSaveDesignCompletedSuccessfully", function(event) {
		log("addToCart");
		$("#div_saving_design").hide();
		$("#div_saving_successfully").show();
			
		<?php if($add_after_save) { ?>
			addToCart();
		<?php } ?>
	});

	$(document).bind("onSaveDesignError", function(event, errorStr) {
		$("#div_saving_design").hide();
		$("#div_saving_error").show();
		$("#save_error_info").html("ERROR: " + errorStr);
	});
	*/
	
	$( "#btn_save_design" ).button().click(function() {
		saveDesignButtonClick();
	});
	
	//it might has been redirected to login. Refresh login state
	$(document).trigger('onLoginStateChange');

	<?php if($add_after_save) { ?>
		saveDesignButtonClick();
	<?php } else { ?>
		$("#div_save_design_form").show();
	<?php } ?>
});

function saveDesignButtonClick() {
	$("#div_saving_design").show();
	$("#div_save_design_form").hide();
	studioSetCompositionName($("#design_name").val());
	studioSaveComposition();
}

function onSaveDesignCompletedSuccessfullyHandler() {
	$("#div_saving_design").hide();
	$("#div_saving_successfully").show();
		
	<?php if($add_after_save) { ?>
		addToCart();
	<?php } ?>
}
function onSaveDesignErrorHandler() {
	$("#div_saving_design").hide();
	$("#div_saving_error").show();
	$("#save_error_info").html("ERROR: " + errorStr);
}
</script>
