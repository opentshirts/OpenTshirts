<div>
  <h1><?php echo $heading_title; ?></h1>
  <?php echo $text_message; ?><br />
  <div align="right"><a id="btn_success_close"><span><?php echo $button_continue; ?></span></a></div>
</div>
<script type="text/javascript" language="javascript">
$(function() {
	
	$( "#btn_success_close" ).button()
	.click(function() {
		closePopUp();
	});
	
	$(document).trigger('onLoginStateChange');
});
</script>
