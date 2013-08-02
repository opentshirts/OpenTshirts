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
		  <form action="" method="post" enctype="multipart/form-data" id="form">
			  <?php if ($error_warning) { ?>
			  <div class="ui-state-error msg-padding"><?php echo $error_warning; ?></div>
			  <?php } ?>
			  <?php if ($success) { ?>
			  <div class="ui-state-highlight msg-padding"><?php echo $success; ?></div>
			  <?php } ?>
				<div>
					<div align="right" style="margin:5px;">
						<a href="<?php echo $add_manufacturer; ?>" class="button"><?php echo $button_add_manufacturer; ?></a>
						<a onclick="$('#form').attr('action', '<?php echo $delete; ?>'); $('#form').attr('target', '_self'); $('#form').submit();" class="button"><?php echo $button_delete; ?></a>
					</div>
					<table class="list" width="100%">
					  <thead>
						<tr>
						  <td width="1" style="text-align: center;"><input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /></td>
						  <td class="left" width="100%"><?php echo $column_name; ?></td>
						  <td class="right"><?php echo $column_action; ?></td>
						</tr>
					  </thead>
					  <tbody>
						<?php if ($manufacturers) { ?>
							<?php foreach ($manufacturers as $manufacturer) { ?>
							<tr>
							  <td style="text-align: center;"><?php if ($manufacturer['selected']) { ?>
							<input type="checkbox" name="selected[]" value="<?php echo $manufacturer['id_manufacturer']; ?>" checked="checked" />
							<?php } else { ?>
							<input type="checkbox" name="selected[]" value="<?php echo $manufacturer['id_manufacturer']; ?>" />
							<?php } ?></td>
							  <td class="left"><?php echo $manufacturer['name']; ?></td>
							  <td class="right"><?php foreach ($manufacturer['action'] as $action) { ?>
							[ <a href="<?php echo $action['href']; ?>"><?php echo $action['text']; ?></a> ]
							<?php } ?></td>
							</tr>
							<?php } ?>
						<?php } else { ?>
						<tr>
						  <td align="center" colspan="3"><?php echo $text_no_results; ?></td>
						</tr>
						<?php } ?>
					  </tbody>
					</table>
				</div>
			</form>
		  </td>
        </tr>
      </table></td>
  </tr>
</table>
</div>
<?php echo $footer; ?>