<?php foreach($views as $key=>$view) : ?>
<?php echo $text_colors_on; ?> <?php echo $view['name']; ?>: <?php echo $view['num_colors']; ?> <?php if(!empty($view['apply_white_base_array'])) : ?><span title="<?php echo $colors_text; ?>"><?php echo $text_apply_whitebase; ?></span><?php endif; ?><br />
<?php endforeach; ?>
<span><?php echo $text_printing_price; ?></span> <span><?php echo $printing_total; ?></span>