<?php echo $header; ?>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/product.png" alt="" /> <?php echo $heading_title; ?></h1>
      <div class="buttons"><a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a><a onclick="location = '<?php echo $cancel; ?>';" class="button"><?php echo $button_cancel; ?></a></div>
    </div>
    <div class="content">
      <div id="tabs" class="htabs"><a href="#tab-data"><?php echo $tab_data; ?></a><a href="#tab-categories"><?php echo $tab_categories; ?></a></div>
      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
        <div id="tab-data">
			<table class="form">
			  <tr>
				<td><span class="required">*</span> <?php echo $entry_name; ?></td>
				<td><input type="text" name="name" value="<?php echo $name; ?>" >
				<?php if ($error_name) { ?>
				<span class="error"><?php echo $error_name; ?></span>
				<?php } ?>
				</td>
			  </tr>
			 <tr>
				<td><?php echo $entry_status; ?></td>
				<td><select name="status">
				  <?php foreach ($statuses as $item) { ?>
					  <?php if ($item['val'] === $status) { ?>
					  <option value="<?php echo $item['val']; ?>" selected="selected"><?php echo $item['description']; ?></option>
					  <?php } else { ?>
					  <option value="<?php echo $item['val']; ?>"><?php echo $item['description']; ?></option>
					  <?php } ?>
				  <?php } ?>
				</select>
				</td>
			 </tr>
			  <tr>
				<td><?php echo $entry_keywords; ?></td>
			    <td><input name="keywords" type="text" value="<?php echo $keywords; ?>"></td>
			  </tr>
			  <tr>
				<td></td>
				<td><img id="thumb" src="<?php echo $thumb; ?>" /></td>
			  </tr>
			  <tr>
				<td><?php echo $entry_ttf_file; ?></td>
				<td>
				<span id="text_ttf_file"><?php echo $ttf_file; ?></span>
				<input type="hidden" name="ttf_file" id="ttf_file" value="<?php echo $ttf_file; ?>" /><br />
			    <input id="ttf_file_upload" name="ttf_file_upload" type="file" />
				<?php if ($error_ttf_file) { ?>
				<span class="error"><?php echo $error_ttf_file; ?></span>
				<?php } ?>
			   </td>
			  </tr>
			  <tr>
				<td><?php echo $entry_swf_file; ?></td>
				<td>
				<span id="text_swf_file"><?php echo $swf_file; ?></span>
				<input type="hidden" name="swf_file" id="swf_file" value="<?php echo $swf_file; ?>" /><br />
			     <input id="swf_file_upload" name="swf_file_upload" type="file" /></a>
				<?php if ($error_swf_file) { ?>
				<span class="error"><?php echo $error_swf_file; ?></span>
				<?php } ?>
			   </td>
			  </tr>
			</table>
        </div>
        <div id="tab-categories">
          <?php echo $category_tab; ?>
        </div>        
      </form>
    </div>
  </div>
</div>

<script type="text/javascript"><!--
$('#tabs a').tabs(); 
//--></script> 
<script type="text/javascript">
$(document).ready(function() {
	 $('#ttf_file_upload').uploadify({
		'uploader'  : 'view/javascript/uploadify/uploadify.swf',
		'script'    : 'index.php?route=font/font/upload_ttf&token=<?php echo $token; ?>',
		'cancelImg' : 'view/javascript/uploadify/cancel.png',
		'scriptData'  : {session_id: "<?php echo session_id(); ?>"},
		'buttonText': '<?php echo $button_upload; ?>',
		'auto'      : true,
		'fileDataName' : 'file',
		'method'      : 'POST',
		'fileExt'     : '*.ttf;*.otf;',
		'fileDesc'    : 'Font Files',
		'onComplete'  : function(event, ID, fileObj, response, data) {
			var obj = jQuery.parseJSON( response );
			if(!obj.error) {
				$('#ttf_file').val(obj.filename);
				$('#text_ttf_file').text(obj.filename);
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
		'script'    : 'index.php?route=font/font/upload_swf&token=<?php echo $token; ?>',
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
<?php echo $footer; ?>