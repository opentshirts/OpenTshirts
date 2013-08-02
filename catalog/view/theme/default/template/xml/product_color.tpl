<productColors>
	<?php if($error_warning) { ?>
		<error><?php echo $error_warning; ?></error>
	<?php } else { ?>
		<?php foreach($colors as $color) { ?>
			<color>
				<id><?php echo $color['id_product_color']; ?></id>
				<name><?php echo $color['name']; ?></name>
				<id_product_color_group><?php echo $color['id_product_color_group']; ?></id_product_color_group>
				<need_white_base><?php echo $color['need_white_base']; ?></need_white_base>
				<hexa_values>
				<?php foreach($color['hexa'] as $hexa) { ?>
					<hexa><?php echo $hexa; ?></hexa>
				<?php } ?>
				</hexa_values>
			</color>
		<?php } ?>
	<?php } ?>
</productColors>
