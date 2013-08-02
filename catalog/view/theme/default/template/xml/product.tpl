<product>
	<?php if($error_warning) { ?>
	<error><?php echo $error_warning; ?></error>
	<?php } else { ?>
	<id_product><?php echo $product_id; ?></id_product>
	<name><?php echo $name; ?></name>
	<default_view><?php echo $default_view; ?></default_view>
	<default_region><?php echo $default_region; ?></default_region>
	<default_color><?php echo $default_color; ?></default_color>
	<colors>
		<?php foreach($colors as $id_product_color => $sizes) { ?>
		<color>
			<id_product_color><?php echo $id_product_color; ?></id_product_color>
			<sizes>
				<?php foreach($sizes as $id_product_size => $value) { ?>
				<size>
					<id_product_size><?php echo $id_product_size; ?></id_product_size>
				</size>
				<?php } ?>
			</sizes>
		</color>
		<?php } ?>
	</colors>
	<views>
		<?php foreach($views as $view) { ?>
		<view>
			<view_index><?php echo $view['view_index']; ?></view_index>
			<name><?php echo $view['name']; ?></name>
			<shade><?php echo $view['shade']; ?></shade>
			<underfill><?php echo $view['underfill']; ?></underfill>
			<regions_scale><?php echo $view['regions_scale']; ?></regions_scale>
			<regions>
				<?php foreach($view['regions'] as $region) { ?>
				<region>
					<region_index><?php echo $region['region_index']; ?></region_index>
					<name><?php echo $region['name']; ?></name>
					<x><?php echo $region['x']; ?></x>
					<y><?php echo $region['y']; ?></y>
					<width><?php echo $region['width']; ?></width>
					<height><?php echo $region['height']; ?></height>
					<mask><?php echo $region['mask']; ?></mask>
				</region>
				<?php } ?>
			</regions>
			<fills>
				<?php foreach($view['fills'] as $fill) { ?>
				<fill>
					<view_fill_index><?php echo $fill['view_fill_index']; ?></view_fill_index>
					<file><?php echo $fill['file']; ?></file>
					<image><?php echo $fill['image']; ?></image>
				</fill>
				<?php } ?>
			</fills>
		</view>
		<?php } ?>
	</views>
	<?php } ?>
</product>