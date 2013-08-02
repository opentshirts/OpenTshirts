<div id="view_<?php echo $view_index; ?>" class="ui-widget-content" style="overflow:auto; margin:5px; padding:5px; border-width:3px;">
	<input type="hidden" style="width:50px;" name="views[<?php echo $view_index; ?>][view_index]" value="<?php echo $view_index; ?>" />
	<input type="hidden" style="width:50px;" name="views[<?php echo $view_index; ?>][regions_scale]" value="<?php echo $regions_scale; ?>" />
	<div style="float:left">
		<table cellpadding="3" cellspacing="2" border="0">
			<tr>
				<td><?php echo $entry_name; ?><input type="text" name="views[<?php echo $view_index; ?>][name]" value="<?php echo $name; ?>" />
				<span style="float:right;" onclick="removeView(<?php echo $view_index; ?>)"><img src="view/image/delete.png" /><a style="vertical-align:top;"><?php echo $button_remove; ?></a></span>
				</td>
			</tr>
			<tr>
				<td><?php echo $text_scale; ?><span id="span_scale_<?php echo $view_index; ?>"><?php echo $regions_scale; ?></span></td>
			</tr>
			<tr>
				<td><?php echo $text_regions; ?><span style="float:right; display:none;" id="button_add_region_<?php echo $view_index; ?>" onclick="addRegion(<?php echo $view_index; ?>)"><img src="view/image/add.png" /><a style="vertical-align:top;"><?php echo $button_add_region; ?></a></span>
					<hr />
					<ul id="regions_<?php echo $view_index; ?>">
					<?php foreach($regions as $region) { ?>
						<?php echo $region; ?>
					<?php } ?>
					</ul>
				</td>
			</tr>
			<tr>
				<td><?php echo $text_view_setup; ?></td>
			</tr>
			<tr>
				<td>
					<table cellpadding="10" cellspacing="0">
						<tr>
							<td valign="top" class="ui-widget-content">
								<h2><?php echo $text_coloreable; ?></h2>
								<?php echo $text_coloreable_pros_cons; ?>
								<?php echo $text_shade; ?>
								<input type="hidden" name="views[<?php echo $view_index; ?>][shade]" value="<?php echo $shade; ?>" />
								<input type="hidden" id="shade_url_<?php echo $view_index; ?>" value="<?php echo $shade_url; ?>" />
								<table>
									<tr>
										<td><img id="thumb_shade_<?php echo $view_index; ?>" src="<?php echo $thumb_shade; ?>" /></td>
										<td><input id="shade_upload_<?php echo $view_index; ?>" type="file" />
											<a onclick="$('#thumb_shade_<?php echo $view_index; ?>').attr('src', '<?php echo $no_image; ?>'); $('input[name=\'views[<?php echo $view_index; ?>][shade]\']').attr('value', ''); swfobject.getObjectById('view_drawer_<?php echo $view_index; ?>').setShade('');">
												<?php echo $text_clear; ?></a></td>
									</tr>
								</table>
								<?php echo $text_fills; ?>
								<ul class="fill_container" style="margin: 0px; padding: 0px;" view_index="<?php echo $view_index; ?>" id="fills_<?php echo $view_index; ?>">
								<?php foreach($fills as $fill) { ?>
									<?php echo $fill; ?>
								<?php } ?>
								</ul>
							</td>
							<td valign="top" class="ui-widget-content">
								<h2><?php echo $text_underfill; ?></h2>
								<?php echo $text_no_coloreable_pros_cons; ?>
								<input type="hidden" name="views[<?php echo $view_index; ?>][underfill]" value="<?php echo $underfill; ?>" />
								<input type="hidden" id="underfill_url_<?php echo $view_index; ?>" value="<?php echo $underfill_url; ?>" />
								<table>
									<tr>
										<td><img id="thumb_underfill_<?php echo $view_index; ?>" src="<?php echo $thumb_underfill; ?>" /></td>
										<td><input id="underfill_upload_<?php echo $view_index; ?>" type="file" />
											<a onclick="$('#thumb_underfill_<?php echo $view_index; ?>').attr('src', '<?php echo $no_image; ?>'); $('input[name=\'views[<?php echo $view_index; ?>][underfill]\']').attr('value', ''); swfobject.getObjectById('view_drawer_<?php echo $view_index; ?>').setUnderfill('');">
												<?php echo $text_clear; ?></a></td>
									</tr>
								</table>
							</td>
					</table>	
				</td>
			</tr>

		</table>
	</div>
	<div style="float:right">
		<div id="view_drawer_<?php echo $view_index; ?>"></div>
	</div>
</div>

<script type="text/javascript">
$(document).ready(function() {
	var flashvars = {id_view:"<?php echo $view_index; ?>"};
	var params = {wmode:"transparent", menu: "false", allowfullscreen:"true", allowScriptAccess:"always"};
	var attributes = {};
	swfobject.embedSWF("view/template/product/drawer.swf", "view_drawer_<?php echo $view_index; ?>", "600", "800", "10.0.0", '', flashvars, params, attributes);    

	 $('#shade_upload_<?php echo $view_index; ?>').uploadify({
		'uploader'  : 'view/javascript/uploadify/uploadify.swf',
		'script'    : 'index.php?route=product/view/upload_shade&token=<?php echo $token; ?>',
		'cancelImg' : 'view/javascript/uploadify/cancel.png',
		'scriptData'  : {session_id: "<?php echo session_id(); ?>"},
		'buttonText': '<?php echo $button_shade; ?>',
		'auto'      : true,
		'fileDataName' : 'file',
		'method'      : 'POST',
		'fileExt'     : '*.jpg;*.png;*.gif;',
		'fileDesc'    : 'Image Files',
		'onComplete'  : function(event, ID, fileObj, response, data) {
			var obj = jQuery.parseJSON( response );
			if(!obj.error) {
				$('input[name=\'views[<?php echo $view_index; ?>][shade]\']').val(obj.filename);
				$('#shade_url_<?php echo $view_index; ?>').val(obj.image);
				$('#thumb_shade_<?php echo $view_index; ?>').attr('src', obj.thumb);
				swfobject.getObjectById("view_drawer_<?php echo $view_index; ?>").setShade(obj.image);
			} else {
				alert(obj.error);
			}
		},
		'onError'     : function (event,ID,fileObj,errorObj) {
		  alert(errorObj.type + ' Error: ' + errorObj.info);
		}
	});

	$('#underfill_upload_<?php echo $view_index; ?>').uploadify({
		'uploader'  : 'view/javascript/uploadify/uploadify.swf',
		'script'    : 'index.php?route=product/view/upload_shade&token=<?php echo $token; ?>',
		'cancelImg' : 'view/javascript/uploadify/cancel.png',
		'scriptData'  : {session_id: "<?php echo session_id(); ?>"},
		'buttonText': '<?php echo $button_underfill; ?>',
		'auto'      : true,
		'fileDataName' : 'file',
		'method'      : 'POST',
		'fileExt'     : '*.jpg;*.png;*.gif;',
		'fileDesc'    : 'Image Files',
		'onComplete'  : function(event, ID, fileObj, response, data) {
			var obj = jQuery.parseJSON( response );
			if(!obj.error) {
				$('input[name=\'views[<?php echo $view_index; ?>][underfill]\']').val(obj.filename);
				$('#underfill_url_<?php echo $view_index; ?>').val(obj.image);
				$('#thumb_underfill_<?php echo $view_index; ?>').attr('src', obj.thumb);
				swfobject.getObjectById("view_drawer_<?php echo $view_index; ?>").setUnderfill(obj.image);
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
