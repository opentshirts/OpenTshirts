<style type="text/css">
ul.colors {
	list-style: none; 
	padding: 0; margin: 10px 0;
}
	
ul.colors li {
	float:left; 
	margin: 5px;
}
ul.colors li > div {
	cursor: pointer;
}
ul.colors li > div > span {
	position: relative;
	bottom: 12px;
	display: inline;
	margin: 8px;
}
ul.colors li > div > div {
	width: 24px; 
	height:24px; 
	display: inline-block;
	margin: 5px;
}
</style>
<table class="list">				  
	<tr>
		<td align="right" valign="top" nowrap="nowrap"><?php echo $entry_image_file; ?> * </td>
		<td align="left">
		<span id="text_image_file"><?php echo $image_file; ?></span>
		<input type="hidden" name="image_file" id="image_file" value="<?php echo $image_file; ?>" /><br />
		<input id="image_file_upload" name="image_file_upload" type="file" /></a>
		<img id="thumb" src="<?php echo $thumb; ?>" />
		<?php if ($error_image_file) { ?>
		<span class="error"><?php echo $error_image_file; ?></span>
		<?php } ?>
		</td>
	</tr>
	<tr>
		<td align="right" valign="top" nowrap="nowrap"><?php echo $entry_colors; ?> * </td>
		<td>
			<h2><?php echo $text_selected_colors; ?><span id="num_selected_colors"><?php echo count($colors); ?></span></h2>
			<?php if ($error_colors) { ?>
			<span class="error"><?php echo $error_colors; ?></span>
			<?php } ?>
			<ul class="colors">
				<?php foreach ($design_colors as $color_detail) { ?>
					<li><div class="ui-wdget-content ui-corner-all ui-state-default <?php if(in_array($color_detail['id_design_color'], $colors)) { ?> ui-state-highlight <?php } ?> " onclick="$(this).toggleClass('ui-state-highlight'); updateSelectedColors();"><div class="ui-wdget-content ui-corner-all" style="background-color: #<?php echo $color_detail['hexa'] ?>; " title="<?php echo $color_detail['name'] ?>" color="<?php echo $color_detail['id_design_color'] ?>" ></div><span><?php echo $color_detail['name'] ?></span></div></li>
				<?php } ?>
			</ul>
			<div id="colors_field_container">
				<?php foreach ($colors as $color) { ?>
				<input type="hidden" name="colors[]" value="<?php echo $color ?>">
				<?php } ?>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
function updateSelectedColors() {
	$("#colors_field_container").html('');
	var num_sel = 0;
	$('ul.colors').find('div.ui-state-highlight').each(function (i) {
		$("#colors_field_container").append('<input type="hidden" name="colors[]" value="' + $(this).children('div').attr('color') + '">');
		num_sel++;
	});
	$('#num_selected_colors').text(num_sel);
}
$(document).ready(function() {
	
	 $('#image_file_upload').uploadify({
		'uploader'  : 'view/javascript/uploadify/uploadify.swf',
		'script'    : 'index.php?route=bitmap/bitmap/upload_image&token=<?php echo $token; ?>',
		'cancelImg' : 'view/javascript/uploadify/cancel.png',
		'scriptData'  : {session_id: "<?php echo session_id(); ?>"},
		'buttonText': '<?php echo $button_upload; ?>',
		'auto'      : true,
		'fileDataName' : 'file',
		'method'      : 'POST',
		'fileExt'     : '*.jpg;*.png;*.gif',
		'fileDesc'    : 'Image Files',
		'onComplete'  : function(event, ID, fileObj, response, data) {
			var obj = jQuery.parseJSON( response );
			if(!obj.error) {
				$('#image_file').val(obj.filename);
				$('#text_image_file').text(obj.filename);
				$('#thumb').attr('src', obj.file);
			} else {
				alert(obj.error);
			}
		},
		'onError'     : function (event,ID,fileObj,errorObj) {
		  alert(errorObj.type + ' Error: ' + errorObj.info);
		}
	});
});	
</script> 
