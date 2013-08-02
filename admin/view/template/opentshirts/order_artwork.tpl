<?php if(isset($text_no_artwork)) { ?>
<div><?php echo $text_no_artwork; ?></div>
<?php } ?>
<?php if(!empty($comps)) { ?>
	<?php foreach ($comps as $comp) : ?>
		<h3><a href="<?php echo $comp['product']['link']; ?>"><?php echo $comp['product']['name']; ?></a></h3>
		<div style="overflow:auto">
		<?php foreach ($comp['designs'] as $design) : ?>
		<div align="left" class="ui-widget-content" style="float:left; margin:5px; padding:2px;"><a href="<?php echo $design['images']['original']; ?>" target="_new"><img border="0" src="<?php echo $design['images']['large']; ?>" /></a><br />
			<a href="<?php echo $design['images']['png']; ?>" target="_new"><?php echo $text_png; ?></a><br />
		<?php if(!empty($design['design_elements'])) : ?>
			<?php echo $text_assets; ?>
			<ul>
				<?php foreach ($design['design_elements'] as $design_element) : ?>
					<?php foreach ($design_element['source'] as $source) : ?>
					<li><a href="<?php echo $source['link']; ?>" target="_new"><?php echo $source['description']; ?></a></li>
					<?php endforeach; ?>
				<?php endforeach; ?>
			</ul>
		<?php endif; ?>	
		</div>			
		<?php endforeach; ?>
		<div style="clear:both"></div>
		</div>
		<hr />
	<?php endforeach; ?>
<?php } ?>