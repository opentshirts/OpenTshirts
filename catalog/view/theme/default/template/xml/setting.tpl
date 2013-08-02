<settings>
<?php foreach($settings as $setting) { ?>
	<<?php echo $setting['name']; ?>><?php echo $setting['value']; ?></<?php echo $setting['name']; ?>>
<?php } ?>
</settings>