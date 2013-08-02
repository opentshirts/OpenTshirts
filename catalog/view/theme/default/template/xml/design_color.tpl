<design_colors>
	<?php if($error_warning) { ?>
		<error><?php echo $error_warning; ?></error>
	<?php } else { ?>
		<?php foreach($colors as $color) { ?>
			<design_color>
				<id><?php echo $color['id_design_color']; ?></id>
				<name><?php echo $color['name']; ?></name>
				<hexa><?php echo $color['hexa']; ?></hexa>
				<alpha><?php echo $color['alpha']; ?></alpha>
				<isdefault><?php echo $color['isdefault']; ?></isdefault>
				<need_white_base><?php echo $color['need_white_base']; ?></need_white_base>
			</design_color>
		<?php } ?>
	<?php } ?>
</design_colors>