<div id="popup_printing_methods" style="display:none;" <?php if ($autoselect) { ?> title="<?php echo $popup_title_autoselect; ?>" <?php } else { ?> title="<?php echo $popup_title; ?>" <?php } ?>>
	<div>
<?php if ($autoselect) { ?>
	<?php foreach ($quantities as $quantity_index => $quantity_value) { ?>
		<?php 
		$array = array();
		foreach ($printing_methods as $printing_method) {
			if($pm[$printing_method['code']][$quantity_index]!="") {
				$array[] = "'".$printing_method['code']."'";
			}
		}
		?>
		<div style="float:left; margin: 0px 20px 20px 0px;" align="center">
			<div class="button" style="height: 50px; width:200px; font-size: 20px; " onclick="showPrintingMethod([<?php echo implode(",",$array); ?>])" >
				<?php echo $descriptions[$quantity_index]; ?>
			</div>
		</div>
	<?php } ?>
<?php } ?>
	</div>
<?php if ($printing_methods) { ?>
	<div>
	<?php foreach ($printing_methods as $printing_method) { ?>
		<div style="float:left; height: 380px; width:300px; margin: 0px 20px 20px 0px;" align="center" id="printing_method_<?php echo $printing_method['code']; ?>">
			<div class="button" onclick="loadPrintingMethod('<?php echo $printing_method['code']; ?>')" >
				<img src="<?php echo $printing_method['image']; ?>" /><br />
				<?php echo $printing_method['title']; ?>
			</div>
			<div style="height: 130px; width:300px; margin: 20px 20px 20px 0px; overflow: auto;"><?php echo $printing_method['description']; ?></div>
		</div>
	<?php } ?>
	</div>
<?php } else { ?>
	<?php echo 'If you are the admin please go to Admin->Extensions->Opentshirts->Printing Method and enable at least one printing method. Otherwise customers wont be able to place orders.' ?>
<?php } ?>
</div>
<div id="printing_method_container"></div>
<input type="hidden" id="printing_method_studio_id">
<script type="text/javascript">
$(function() {

	$(document).bind("onStudioIdChange", function(event, studio_id) {
		$("#printing_method_studio_id").val(studio_id);

		<?php if (count($printing_methods) == 1) { ?>
			loadPrintingMethod('<?php echo $printing_methods[0]['code']; ?>');
		<?php } else { ?>
			$( "#popup_printing_methods" ).dialog('open');
		<?php } ?>
	});

	$( "#popup_printing_methods" ).dialog({
		autoOpen: false,
		height: "auto",
		width: "auto",
		modal: true/*,
		close: function(event, ui) {
			$("#popup_video_link").show();
		},
		open: function(event, ui) {
			$("#popup_video_link").hide();
		}*/

	});

	$(".button").button();

	<?php if ($autoselect) { ?>
		showPrintingMethod(); //hide all
	<?php } ?>
});
function loadPrintingMethod(code) {

	$.ajax({
		type: "POST",
		url: "index.php?route=printing_method/" + code,
		data: {studio_id:$("#printing_method_studio_id").val()},
		success: function(response) {
			$("#printing_method_container").html(response);
			$( "#popup_printing_methods" ).dialog('close');
		}
	});	
}

function showPrintingMethod(printing_methods) {
	if(printing_methods!= undefined && printing_methods.length==1) {
		loadPrintingMethod(printing_methods[0]);
		return;
	}

	<?php if ($printing_methods) { ?>
		<?php foreach ($printing_methods as $printing_method) { ?>
			$("#printing_method_<?php echo $printing_method['code']; ?>").hide();
		<?php } ?>
	<?php } ?>
	if(printing_methods) {
		for (var i = 0; i < printing_methods.length; i++) {
			$("#printing_method_" + printing_methods[i]).show();
		};
	}

	$( "#popup_printing_methods" ).dialog( "option", "position", 'center' );	

}
</script>