<div class="ui-widget-content ui-state-highlight" style="padding: 10px; margin: 10px;">
<?php echo $text_help_colors; ?>
</div>
<table class="list" style="margin-bottom:0;">
  <thead>
	<tr>
	  <td width="50" style="text-align: center;"><input type="checkbox" onclick="$('input[name*=\'data[transfers_colors]\']').attr('checked', this.checked);" /></td>
	  <?php /*<td width="300" class="right"><?php echo $column_id_design_color; ?></td>*/?>
	  <td class="left"><?php echo $column_name; ?></td>
	  <td width="200" class="left"><?php echo $column_code; ?></td>
	  <td width="100" class="left"><?php echo $column_hexa; ?></td>
	  <td width="100" class="left"><?php echo $column_status; ?></td>
	</tr>
  </thead>
  <tbody>
	<?php if (!$colors) { ?>
	<tr>
	  <td align="center" colspan="5"><?php echo $text_no_results; ?></td>
	</tr>
	<?php } else { ?>
		<?php foreach ($colors as $color) { ?>
		<tr>
			<td width="50" style="text-align: center;">
			<?php if (!$color['isdefault']) { ?>
				<?php if ($color['selected']) { ?>
				<input type="checkbox" name="data[transfers_colors][]" value="<?php echo $color['id_design_color']; ?>" checked="checked" />
				<?php } else { ?>
				<input type="checkbox" name="data[transfers_colors][]" value="<?php echo $color['id_design_color']; ?>" />
				<?php } ?>
			<?php } ?>
			</td>
			<?php /*<td width="300" class="right"><?php echo $color['id_design_color']; ?></td> */?>
			<td><?php if ($color['isdefault']) { ?><?php echo $text_default; ?> <?php } ?><?php echo $color['name']; ?></td>
			<td width="200" class="left"><?php echo $color['code']; ?></td>
			<td width="100" class="center"><span title="<?php echo $color['hexa']; ?>" class="ui-widget-content" style="display:block; width:20px; height:20px; background: #<?php echo $color['hexa']; ?>">&nbsp;</span></td>
			<td width="100" class="left"><?php echo $color['status']; ?></td>
		</tr>
		<?php } ?>
	<?php } ?>
  </tbody>
</table>
