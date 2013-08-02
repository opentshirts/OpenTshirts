<style>
li.layer {
	list-style:none;
}
</style>
<table class="list ui-widget-content">				  
	<tr>
		<td align="right" valign="top" nowrap="nowrap"><?php echo $entry_vector_file; ?> * </td>
		<td align="left" width="100%">
		<span id="text_vector_file"><?php echo $vector_file; ?></span>
		<input type="hidden" name="vector_file" id="vector_file" value="<?php echo $vector_file; ?>" /><br />
		<input id="vector_file_upload" name="vector_file_upload" type="file" /></a>
		<?php if ($error_vector_file) { ?>
		<span class="error"><?php echo $error_vector_file; ?></span>
		<?php } ?>
		</td>
	</tr>
	<tr>
		<td align="right" valign="top" nowrap="nowrap"><?php echo $entry_vector_file_2; ?></td>
		<td align="left" width="100%">
		<span id="text_vector_file_2"><?php echo $vector_file_2; ?></span>
		<input type="hidden" name="vector_file_2" id="vector_file_2" value="<?php echo $vector_file_2; ?>" /><br />
		<input id="vector_file_2_upload" name="vector_file_2_upload" type="file" /></a>
		</td>
	</tr>
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
		<td align="right" valign="top" nowrap="nowrap"><?php echo $entry_swf_file; ?> * </td>
		<td align="left">
		<span id="text_swf_file"><?php echo $swf_file; ?></span>
		<input type="hidden" name="swf_file" id="swf_file" value="<?php echo $swf_file; ?>" /><br />
		<input id="swf_file_upload" name="swf_file_upload" type="file" /></a>
		<?php if ($error_swf_file) { ?>
		<span class="error"><?php echo $error_swf_file; ?></span>
		<?php } ?>
		</td>
	</tr>
	<tr>
		<td align="right" valign="top" nowrap="nowrap">
		<div id="clipart_sample"></div>
		</td>
		<td align="left" style="vertical-align:top">
		<?php echo $text_layers; ?>
		<ul class="ui_layers">
			<?php foreach ($layer_name as $key => $name) { ?>
			<li class="layer">
			  <input type="text" name="layer_name[]" value="<?php echo $name; ?>">
			  <select style="background-color:#<?php if(isset($colors[$layer_id_design_color[$key]]["hexa"])) { echo $colors[$layer_id_design_color[$key]]["hexa"]; } else { echo "FFFFFF"; } ?>" name="layer_id_design_color[]" onchange="updateColor(this)">
				<option value="0" style="background-color:#FFF" ><?php echo $text_select; ?></option>
				<?php
				foreach($colors as $color) { ?>
				<option <?php if($layer_id_design_color[$key]==$color["id_design_color"]) { ?> selected="selected" <?php } ?> value="<?php echo $color["id_design_color"]; ?>" style="background-color:#<?php echo $color["hexa"]; ?>" hexa="<?php echo $color["hexa"]; ?>" ><?php echo $color["name"]; ?></option>
				<?php
				}
				?>
			  </select>
			</li>
			<?php } ?>
		</ul>
		
		<?php if ($error_layer_name) { ?>
		<span class="error"><?php echo $error_layer_name; ?></span>
		<?php } ?>
		
		<?php if ($error_layer_id_design_color) { ?>
		<span class="error"><?php echo $error_layer_id_design_color; ?></span>
		<?php } ?>
		
		<span id="child_not_sprite" style="display:none; padding: 10px; " class="ui-state-highlight"><?php echo $text_child_not_sprite; ?></span>
		<span class="ui-state-highlight" style="padding: 10px; " ><?php echo $text_full_color; ?></span>
		</td>
	</tr>
</table>
<script type="text/javascript">
var layerHTML = '<li class="layer">';
	layerHTML += '<input type="text" name="layer_name[]" value="Layer">';
	layerHTML += '<select style="background-color:#FFFFFF" name="layer_id_design_color[]" onchange="updateColor(this)">';
	layerHTML += '<option value="0" style="background-color:#FFF" ><?php echo $text_select; ?></option>';
	<?php
	foreach($colors as $color) { ?>
	layerHTML += '<option value="<?php echo $color["id_design_color"]; ?>" style="background-color:#<?php echo $color["hexa"]; ?>" hexa="<?php echo $color["hexa"]; ?>" ><?php echo $color["name"]; ?></option>';
	<?php
	}
	?>
	layerHTML += '</select>';


$(document).ready(function() {
	var flashvars = {swf_file:"<?php echo $swf_file; ?>", clipart_dir:"<?php echo $clipart_dir; ?>"};
	var params = {wmode:"transparent", menu: "false", allowfullscreen:"true", allowScriptAccess:"always"};
	var attributes = {};
	swfobject.embedSWF("view/template/clipart/clipart_sample.swf", "clipart_sample", "300", "300", "10.0.0", '', flashvars, params, attributes);    


	 $('#vector_file_upload').uploadify({
		'uploader'  : 'view/javascript/uploadify/uploadify.swf',
		'script'    : 'index.php?route=clipart/clipart/upload_vector&token=<?php echo $token; ?>',
		'cancelImg' : 'view/javascript/uploadify/cancel.png',
		'scriptData'  : {session_id: "<?php echo session_id(); ?>"},
		'buttonText': '<?php echo $button_upload; ?>',
		'auto'      : true,
		'fileDataName' : 'file',
		'method'      : 'POST',
		'fileExt'     : '*.svg;*.cdr;*.ai;*.eps',
		'fileDesc'    : 'Vector Files',
		'onComplete'  : function(event, ID, fileObj, response, data) {
			var obj = jQuery.parseJSON( response );
			if(!obj.error) {
				$('#vector_file').val(obj.filename);
				$('#text_vector_file').text(obj.filename);
			} else {
				alert(obj.error);
			}
		},
		'onError'     : function (event,ID,fileObj,errorObj) {
		  alert(errorObj.type + ' Error: ' + errorObj.info);
		}
	});
	 $('#vector_file_2_upload').uploadify({
		'uploader'  : 'view/javascript/uploadify/uploadify.swf',
		'script'    : 'index.php?route=clipart/clipart/upload_vector&token=<?php echo $token; ?>',
		'cancelImg' : 'view/javascript/uploadify/cancel.png',
		'scriptData'  : {session_id: "<?php echo session_id(); ?>"},
		'buttonText': '<?php echo $button_upload; ?>',
		'auto'      : true,
		'fileDataName' : 'file',
		'method'      : 'POST',
		'fileExt'     : '*.svg;*.cdr;*.ai;*.eps',
		'fileDesc'    : 'Vector Files',
		'onComplete'  : function(event, ID, fileObj, response, data) {
			var obj = jQuery.parseJSON( response );
			if(!obj.error) {
				$('#vector_file_2').val(obj.filename);
				$('#text_vector_file_2').text(obj.filename);
			} else {
				alert(obj.error);
			}
		},
		'onError'     : function (event,ID,fileObj,errorObj) {
		  alert(errorObj.type + ' Error: ' + errorObj.info);
		}
	});
	 $('#image_file_upload').uploadify({
		'uploader'  : 'view/javascript/uploadify/uploadify.swf',
		'script'    : 'index.php?route=clipart/clipart/upload_image&token=<?php echo $token; ?>',
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
	 $('#swf_file_upload').uploadify({
		'uploader'  : 'view/javascript/uploadify/uploadify.swf',
		'script'    : 'index.php?route=clipart/clipart/upload_swf&token=<?php echo $token; ?>',
		'cancelImg' : 'view/javascript/uploadify/cancel.png',
		'scriptData'  : {session_id: "<?php echo session_id(); ?>"},
		'buttonText': '<?php echo $button_upload; ?>',
		'auto'      : true,
		'fileDataName' : 'file',
		'method'      : 'POST',
		'fileExt'     : '*.swf;',
		'fileDesc'    : 'SWF Files',
		'onComplete'  : function(event, ID, fileObj, response, data) {
			var obj = jQuery.parseJSON( response );
			if(!obj.error) {
				$('#swf_file').val(obj.filename);
				$('#text_swf_file').text(obj.filename);
				$('#child_not_sprite').hide();
				swfobject.getObjectById("clipart_sample").setSource(obj.filename);
			} else {
				alert(obj.error);
			}
		},
		'onError'     : function (event,ID,fileObj,errorObj) {
		  alert(errorObj.type + ' Error: ' + errorObj.info);
		}
	});
});
function onChildNotMC() {
	$('#child_not_sprite').show();
}
function onLayersChange(num) {
	var current = $('li.layer').length;
	var dif = num - current;
	if(dif>0) {
		for(var i=current+1; i<=num; i++) {
			$('ul.ui_layers').append(layerHTML);
		}
	} else {
		for(var i=current; i>num; i--) {
			$('li.layer:last').remove();
		}
	}
	/*if(num>2) {
		setFullColor()
	} else {
		clearFullColor()
	}*/
	tintClipart();
}
/*function setFullColor() {
	$('select[name="layer_id_design_color[]"]:first').attr('hexa','FFFFFF')
	$('select[name="layer_id_design_color[]"]:first').attr('disabled', true);
	
}
function clearFullColor() {
	$('select[name="layer_id_design_color[]"]:first').attr('disabled', false);
}*/
function updateColor(obj) {
	obj.style.backgroundColor = obj.options[obj.selectedIndex].style.backgroundColor;
	tintClipart();
}
function tintClipart() {
	$('select[name="layer_id_design_color[]"]').each(function(index) {
		var hexa = $(this).children("option:selected").attr("hexa");
		swfobject.getObjectById("clipart_sample").setLayerColor(index, hexa);
		
	});	
}
	
	
</script> 
