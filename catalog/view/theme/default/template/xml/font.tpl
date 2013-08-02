<fonts>
	<?php if($error_warning) { ?>
		<error><?php echo $error_warning; ?></error>
	<?php } else { ?>
		<?php foreach($fonts as $font) { ?>
			<font>
				<id><?php echo $font['id_font']; ?></id>
				<name><?php echo $font['name']; ?></name>
				<swf_file><?php echo $font['swf_file']; ?></swf_file>
				<preview><?php echo $font['preview']; ?></preview>
			</font>
		<?php } ?>
	<?php } ?>
</fonts>