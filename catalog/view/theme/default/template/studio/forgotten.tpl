<div>
  <?php if ($error_warning) { ?>
  <div class="ui-state-error ui-corner-all is_ml" ml_label="error_warning" style="padding:5px; margin:5px; "><?php echo $error_warning; ?></div>
  <?php } ?>
  <div align="right"><a id="btn_forgotten_back" class="small_link"><span class="is_ml" ml_label="button_back"><?php echo $button_back; ?></span></a></div>
  <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="forgotten">
      <table class="form" cellspacing="10">
        <tr>
          <td><span class="is_ml" ml_label="entry_email"><?php echo $entry_email; ?></span></td>
          <td><input type="text" name="email" value="<?php echo $email; ?>" /></td>
        </tr>
      </table>
    <div align="right"><a id="btn_forgotten_continue"><span class="is_ml" ml_label="button_continue"><?php echo $button_continue; ?></span></a></div>
  </form>
</div>
<script type="text/javascript"><!--
//-->
$(function() {
	$('#forgotten').submit(function(event) {
		/* stop form from submitting normally */
		event.preventDefault(); 
		loadPopUp('<?php echo $action; ?>', $('#forgotten').serialize(), "POST" );
		return false;
	});
	$( "#btn_forgotten_continue" ).button()
	.click(function() {
		$('#forgotten').submit();
	});
	$( "#btn_forgotten_back" ).click(function() {
		loadPopUp('<?php echo $back; ?>' );
	});
});
</script>