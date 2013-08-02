<clipart>
	<?php if($error_warning) { ?>
	<error><?php echo $error_warning; ?></error>
	<?php } else { ?>
	<id_clipart><?php echo $id_clipart; ?></id_clipart>
	<name><?php echo $name; ?></name>
	<swf_file><?php echo $swf_file; ?></swf_file>
	<layers>
		<?php foreach($layers as $layer) { ?>
		<layer>
			<sorting><?php echo $layer['sorting']; ?></sorting>
			<name><?php echo $layer['name']; ?></name>
			<design_color><?php echo $layer['id_design_color']; ?></design_color>
		</layer>
		<?php } ?>
	</layers>
	<?php } ?>
</clipart>