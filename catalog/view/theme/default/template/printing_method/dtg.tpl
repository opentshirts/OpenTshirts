<?php foreach($views as $key=>$view) : ?>
	<?php if(!empty($view['num_elements'])) : ?>
		<?php echo $text_print_on; ?> <?php echo $view['name']; ?>
		<?php if(!empty($view['apply_white_base_1_array'])) : ?><span title="<?php echo $colors_text_1; ?>"><?php echo $text_apply_whitebase_1; ?></span><?php endif; ?>
		<?php if(!empty($view['apply_white_base_2_array'])) : ?><span title="<?php echo $colors_text_2; ?>"><?php echo $text_apply_whitebase_2; ?></span><?php endif; ?><br />
	<?php endif; ?>
<?php endforeach; ?>
<span><?php echo $text_printing_price; ?></span> <span><?php echo $printing_total; ?></span>