<style type="text/css">
.small_link {
	cursor:pointer;
	text-decoration:none;
}
.small_link:hover {
	text-decoration:underline;
}
</style>
<h2><?php echo $heading_title; ?></h2>
<p><?php echo $text_login; ?></p>
<form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="login">
	  <?php if ($success) { ?>
	  <div class="ui-state-highlight ui-corner-all" style="padding:5px; margin:5px; ">
	  <span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-info"></span><span><?php echo $success; ?></span></div>
	  <?php } ?>
	  <?php if ($error_warning) { ?>
	  <div class="ui-state-error ui-corner-all" style="padding:5px; margin:5px; ">
	  <span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span><span><?php echo $error_warning; ?></span></div>
	  <?php } ?>
	<div style="margin-top:10px" align="right">
		<label> <span><?php echo $entry_email; ?></span></label>
		<input type="text" name="email" class="ui-widget-content ui-corner-all" value="<?php echo $email; ?>">
		<span style="width:50px; display:inline-block;"></span>
		<label> <span><?php echo $entry_password; ?></span></label>
		<input type="password" name="password" class="ui-widget-content ui-corner-all" ><br />
		<a onclick="loadPopUp('<?php echo $forgotten; ?>')" class="small_link"  ><span><?php echo $text_forgotten; ?></span></a>
	</div>
	<div style="margin-top:10px" align="right" >
		<input type="submit" class="is_ml" ml_attr="value" id="form_login_button" ml_label="button_login" value="<?php echo $button_login; ?>">
	</div>
	<?php if ($redirect) { ?>
	<input type="hidden" name="redirect" value="<?php echo $redirect; ?>" />
	<?php } ?>
</form>
<br />
<a onclick="loadPopUp('<?php echo $register; ?>')" class="small_link"  ><span><?php echo $text_register; ?></span></a>

<script type="text/javascript"><!--
$('#login input').keydown(function(e) {
	if (e.keyCode == 13) {
		$('#login').submit();
	}
});

$('#login').submit(function(event) {
	/* stop form from submitting normally */
	event.preventDefault(); 
	loadPopUp('<?php echo $action; ?>', $('#login').serialize(), "POST");
	return false;
});

$( "#form_login_button" ).button();

//--></script>