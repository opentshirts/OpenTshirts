<div style="width:600px; display:inline-block; margin:6px;">
	<?php if ($success) { ?>
	<div class="ui-state-highlight ui-corner-all" style="padding:5px; margin:5px; ">
		<span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-info"></span>
		<span><?php echo $success; ?></span>
	</div>
	<div align="right">
		<a class="ui-state-default ui-corner-all" onmouseover="$(this).addClass('ui-state-hover')" onmouseout="$(this).removeClass('ui-state-hover')" style="display:inline-block; padding:8px; text-decoration:none;" href="<?php echo $continue; ?>"><?php echo $button_continue; ?></a>
	</div>
	<script type="text/javascript" language="javascript">
	$(function() {
		$(window).unbind('beforeunload');
	});
	</script>

	<?php } ?>
	<?php if ($error_warning) { ?>
	<div class="ui-state-error ui-corner-all" style="padding:5px; margin:5px; ">
		<span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
		<span><?php echo $error_warning; ?></span>
	</div>
	<?php } ?>
</div>
