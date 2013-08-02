<?php echo $header; ?>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/product.png" alt="" /> <?php echo $heading_title; ?></h1>
    </div>
    <div class="content">
		<div id="success_msg" class="success" style="display:none;"><span id="success_msg_text"></span></div>
		<div id="error_msg" class="error" style="display:none;"><span id="error_msg_text"></span></div>

		<div class="content" align="left" style="padding:20px;">
		  <div style="float:right">
		  <table cellspacing="10" style="background: #F7F7F7; border: 1px solid #DDDDDD; padding: 10px; margin-bottom: 15px;">
		  <tr>
	        <td><?php echo $text_upload_max_filesize; ?></td>
	        <td><?php echo ini_get('upload_max_filesize'); ?></td>
	      </tr>
	      <tr>
	        <td><?php echo $text_post_max_size; ?></td>
	        <td><?php echo ini_get('post_max_size'); ?></td>
	      </tr>
	      <tr>
	        <td><?php echo $text_memory_limit; ?></td>
	        <td><?php echo ini_get('memory_limit'); ?></td>
	      </tr>
	      <tr>
	        <td><?php echo $text_max_execution_time; ?></td>
	        <td><?php echo ini_get('max_execution_time'); ?></td>
	      </tr>
		  </table>
		  </div>
		  <div id="loading" style="display:none;">
		  	<div style="float:left" style="text-align:left; margin:20px; padding:10px;"><?php echo $text_wait; ?></div>
			<img src="view/image/loading.gif" />
		</div>
		  <div style="clear:left; margin:10px; padding:10px;">
		  <input type="checkbox" name="overwrite" onchange="overwriteChange(this.checked)" />
		  <?php echo $text_overwrite; ?><br />
		  
	      <input id="upload" name="upload" type="file" />
		  </div>
		  <div><a target="_blank" href="http://module.opentshirts.com/getart"><img src="http://module.opentshirts.com/image/getart.jpg"></a></div>
	    </div>
    </div>
  </div>
</div>
<script type="text/javascript">
$(document).ready(function() {
	
	 $('#upload').uploadify({
		'uploader'  : 'view/javascript/uploadify/uploadify.swf',
		'script'    : 'index.php?route=content_pack/install/install&token=<?php echo $token; ?>',
		'cancelImg' : 'view/javascript/uploadify/cancel.png',
		'scriptData'  : {session_id: "<?php echo session_id(); ?>"},
		'buttonText': '<?php echo $button_upload; ?>',
		'auto'      : true,
		'method'      : 'POST',
		'fileExt'     : '*.zip;',
		'fileDesc'    : 'Zip Files',
		'onComplete'  : function(event, ID, fileObj, response, data) {
		  $('#success_msg_text').text(response);
		  $('#success_msg').show();
		  $('#loading').hide();
		},
		'onSelectOnce'  : function(event, data) {
			$('#loading').show();
			$('#error_msg').hide();
			$('#success_msg').hide();
		},
		'onCancel'  : function(event, ID, fileObj, data, remove, clearFast) {
			$('#loading').hide();
		},
		'onError'     : function (event,ID,fileObj,errorObj) {
		  $('#error_msg_text').text(errorObj.type + ' Error: ' + errorObj.info);
		  $('#error_msg').show();
		  $('#loading').hide();
		}
		
		
	});
});
function overwriteChange(value) {
	if(value) {
		$('#upload').uploadifySettings('scriptData',{overwrite:1, session_id: "<?php echo session_id(); ?>"}); 
	} else {
		$('#upload').uploadifySettings('scriptData',{overwrite:0, session_id: "<?php echo session_id(); ?>"}); 
	}
}
</script> 
<?php echo $footer; ?>