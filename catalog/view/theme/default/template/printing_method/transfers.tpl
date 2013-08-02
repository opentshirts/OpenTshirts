<?php foreach($views as $key=>$view) : ?>
	<?php if(!empty($view['num_elements'])) : ?>
		<?php echo $text_print_on; ?> <?php echo $view['name']; ?><br />
	<?php endif; ?>
<?php endforeach; ?>
<span><?php echo $text_printing_price; ?></span> <span><?php echo $printing_total; ?></span>