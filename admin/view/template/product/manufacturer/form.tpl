<?php echo $header; ?>
<div>
  <table class="main_table">

  <tr>
    <td align="center" height="100%" valign="top" class="ui-widget">
    	<table height="100%"  width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
        	<td align="left" class="ui-widget">
                <ul class="breadcrumb ui-widget-content">
			<?php foreach ($breadcrumbs as $breadcrumb) { ?>
			<li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
			<?php } ?>
                </ul>
            </td>
        </tr>
        <tr>
          <td width="100%" valign="top" class="ui-widget-content" style="padding:5px;">
			<?php if ($error_warning) { ?>
			<div class="ui-state-error msg-padding"><?php echo $error_warning; ?></div>
			<?php } ?>
			<form action="<?php echo $action; ?>"  name="form_data" id="form_data" method="post" enctype="application/x-www-form-urlencoded">
				<input type="hidden" name="image" value="" />
				<div align="right" style="margin:10px;">
				<input type="button" class="button" value="<?php echo $button_save; ?>" onclick="$('#form_data').submit()"  /> <a href="<?php echo $cancel; ?>" class="button"><?php echo $button_cancel; ?></a>
				</div>
				<table border="0" width="100%" cellspacing="2" cellpadding="5" class="ui-widget-content">
				  <tr>
					<td align="right" style="margin:0 10px;" nowrap="nowrap"><?php echo $entry_name; ?></td>
					<td align="left"><input type="text" name="name" value="<?php echo $name; ?>" class="ui-corner-all ui-widget-content form_input" >
					<?php if ($error_name) { ?>
					<span class="ui-state-error ui-corner-all msg-padding"><?php echo $error_name; ?></span>
					<?php } ?>
					</td>
				  </tr>
				</table>
			</form>
		  </td>
        </tr>
      </table></td>
  </tr>
</table>
</div>
<?php echo $footer; ?>