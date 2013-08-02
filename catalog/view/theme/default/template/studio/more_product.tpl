<?php if ($products) { ?>
	<?php foreach ($products as $product) { ?>
	<li class="ui-widget-content ui-corner-all" >
		<table height="100%" width="100%" cellspacing="0" cellpadding="5" border="0">
			<tr>
				<td align="center" valign="top" rowspan="3" ><div class="ui-widget-content ui-corner-all" style="background:#FFF; padding:5px; "><a href="#" onclick="setProduct('<?php echo $product['product_id']; ?>');"><img src="<?php echo $product['thumb']; ?>" border="0"></a></div></td>
				<td align="left" valign="top">
				<a href="#" onclick="setProduct('<?php echo $product['product_id']; ?>');"><strong><?php echo $product['name']; ?></strong></a>
				<?php echo $product['manufacturer']; ?>
				- <?php echo $product['weight']; ?> <?php echo $product['weight_unit']; ?></td>
			</tr>
			<tr>
				<td align="left" valign="top"><?php echo $product['description']; ?></td>
			</tr>
			<tr>
				<td align="left" valign="top" width="100%">
				<?php foreach ($product['colors'] as $id_product_color) { ?>
					<div title="<?php echo $colors[$id_product_color]['name']; ?>" style="width:40px; height:20px; float:left; margin:3px;" onclick="setProduct('<?php echo $product['product_id']; ?>'); studioChangeProductColor('<?php echo $colors[$id_product_color]['id_product_color']; ?>')" >
						<table width="100%" height="100%" class="ui-widget-content" style="cursor:pointer"  cellpadding="0" cellspacing="0">
							<tr>
							<?php foreach($colors[$id_product_color]['hexa'] as $hexa) : ?>
								<td style="background-color:#<?php echo $hexa; ?>;">&nbsp;</td>
							<?php endforeach; ?>
							</tr>
						</table>
					</div>
				<?php } ?>
				</td>
			</tr>
		</table>
	</li>
	<?php } ?>
	<?php if($show_more) { ?>
	<div class="ui-widget ui-corner-all ui-widget-header ui-state-hover" style="clear:both; text-align:center; margin: 10px 7px 20px 7px; ">
	    <div onclick="productLoadList(<?php echo ($product_page+1); ?>, $(this).parent())" style="cursor:pointer; padding:8px;">
		<span><?php echo $product_text_show_more; ?></span>
	    </div>
	</div>
	<?php } ?>
<?php } else { ?>
	<div><?php echo $product_text_empty; ?></div>
<?php } ?>