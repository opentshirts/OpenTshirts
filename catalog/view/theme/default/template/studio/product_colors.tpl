<?php if($product_colors) : ?>
<div align="center">
	<div id="product_color_container_tab" align="center" onclick="$(this).parent().next().toggle(); $(this).children('span').toggleClass('ui-icon-circle-triangle-s ui-icon-circle-triangle-n'); " class="ui-widget-content ui-corner-tl ui-corner-tr" style=" pointer-events: auto; cursor: pointer; padding: 5px 15px; display: inline-block; border-width: 1px 1px 0px 1px; top: 1px; white-space: nowrap; position: relative; " ><?php echo $text_product_colors; ?><span style="display: inline-block; margin: 0 0 0 10px;" class="ui-icon ui-icon-circle-triangle-s"></span></div>
</div>
	<div align="center">
	<div class="ui-widget-content ui-corner-tr ui-corner-bl ui-corner-br" style="overflow: auto; display: inline-block; pointer-events: auto;">
		<ul>
		<?php foreach($product_colors as $id_product_color) : ?>
		<li title="<?php echo $all_colors[$id_product_color]['name']; ?>">
			<table width="100%" height="100%" onclick="studioChangeProductColor('<?php echo $id_product_color; ?>')" cellpadding="0" cellspacing="0" class="ui-widget-content">
				<tr style="cursor:pointer; ">
				<?php foreach($all_colors[$id_product_color]['hexa'] as $hexa) : ?>
					<td style="background-color:#<?php echo $hexa; ?>;">&nbsp;</td>
				<?php endforeach; ?>
				</tr>
			</table>
		</li>
		<?php endforeach; ?>
		</ul>
	</div>
	</div>

<?php endif; ?>