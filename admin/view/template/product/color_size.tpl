<table class="form">
	<tr>
		<td><span class="required">*</span> <?php echo $entry_num_colors; ?></td>
		<td>
		<?php if($colors_number_img) { ?>
				<?php echo $colors_number; ?><img src="<?php echo $colors_number_img; ?>" />
				<input type="hidden" name="colors_number" value="<?php echo $colors_number; ?>" />

		<?php } else { ?>
			<?php foreach($color_numbers_images as $i=>$image) { ?>
			<div align="center" style="float:left; width:36px; height:40px;">
				<?php echo $i; ?><input type="radio" <?php if($colors_number==$i) { ?> checked="checked" <?php } ?> name="colors_number" class="ui-corner-all ui-widget-content" value="<?php echo $i; ?>" onclick="setNumColors(<?php echo $i; ?>)"  /><br />
				<img src="<?php echo $image; ?>" />
			</div>
			<?php } ?>
			<?php if ($error_colors_number) { ?>
			<span class="error"><?php echo $error_colors_number; ?></span>
			<?php } ?>
		<?php } ?>
		</td>  
	</tr>
</table>

<?php if ($error_color_size) { ?>
<span class="ui-widget-content ui-state-error" style="padding: 5px; margin: 5px;"><?php echo $error_color_size; ?></span>
<?php } ?>
<?php if ($error_default_color) { ?>
<span class="ui-widget-content ui-state-error" style="padding: 5px; margin: 5px;"><?php echo $error_default_color; ?></span>
<?php } ?>
<div  style="max-height:500px; overflow: auto;">
<table class="form">
	<thead>
		<tr>
		<td></td>
		<td align="center"><?php echo $text_default_color; ?></td>
		<?php foreach ($sizes as $product_size) { ?>
			<td align="center"><a onclick="$('input[type=checkbox][product_size=<?php echo $product_size['id_product_size']; ?>]').click();"><?php echo $product_size['description']; ?></a></td>
		<?php } ?>
		</tr>
	</thead>
	<div>
	<tbody>
	<?php foreach ($colors as $product_color) { ?>
	<tr num_colors="<?php echo $product_color['num_colors']; ?>">
	<td>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td><a onclick="$('input[type=checkbox][product_color=<?php echo $product_color['id_product_color']; ?>]').click();"><?php echo $product_color['name']; ?></a></td>
			<td style="background:none;width:75px;">
				<table height="100%" cellpadding="0" cellspacing="0" style="width:75px; border: solid 1px #000">
			        <tr>
			        	<?php foreach($product_color["hexa"] as $hexa) { ?>
						<td style="background-color:#<?php echo $hexa; ?>;">&nbsp;</td>
			            <?php } ?>
			        </tr>
		        </table>
		    </td>
		</tr>
	</table>
	</td>
	<td align="center">
		<input type="radio" name="default_color" value="<?php echo $product_color['id_product_color']; ?>" <?php if($default_color==$product_color['id_product_color']) { ?> checked="checked"  <?php } ?> />
	</td>
	<?php foreach ($sizes as $product_size) { ?>
	<td align="center"><?php echo $product_size['initials']; ?><input type="checkbox" name="color_size[<?php echo $product_color['id_product_color']; ?>][<?php echo $product_size['id_product_size']; ?>]" <?php if(isset($color_size[$product_color['id_product_color']][$product_size['id_product_size']])) { ?> checked="checked" <?php } ?> product_color="<?php echo $product_color['id_product_color']; ?>"  product_size="<?php echo $product_size['id_product_size']; ?>" value="<?php echo $product_color['id_product_color']; ?>_<?php echo $product_size['id_product_size']; ?>"  /></td>
	<?php } ?>
	</tr>
	<?php } ?>
	</tbody>
	</div>
</table>
</div>

<script type="text/javascript">
function setNumColors(num) {
	$('tr[num_colors]').hide(); 
	$('tr[num_colors=' + num + ']').show();
	$('ul.fill_container').each(function(index) {
		var dif = num - $(this).children('.fill').length;
		var view_index = $(this).attr('view_index');
		if(dif<0) {
			for(var i=dif; i<0; i++) {
				removeFill($(this).attr('view_index'));
			}
		} else if(dif>0) {
			for(var i=0; i<dif; i++) {
				addFill($(this).attr('view_index'));
			}
		}
	});
}
$(document).ready(function() {
	setNumColors(<?php echo $colors_number; ?>);
});
</script>
