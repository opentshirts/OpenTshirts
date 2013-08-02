<p><?php echo $welcome_text; ?></p>
<br />
<div align="right"><a id="btn_welcome_close"><?php echo $welcome_close; ?></a></div>
</div>
<script type="text/javascript" language="javascript">
$(function() {
	$( "#btn_welcome_close" ).button()
	.click(function() {
			closePopUp();
	});
	
	$(document).trigger('onLoginStateChange');
});
</script>
