
<div id="price_drag_panel" style="padding:20px;" class="ui-widget-content ui-corner-all">
	<div align="center" id="img_quote_loading" style="position: absolute; top:100px; left: 115px;  display:none;"><img src="image/loading.gif" /><br /></div>
	<div id="price_div_to_fade">
		<div align="center" class="drag_handle ui-widget-content ui-corner-all" style="cursor:move">
			<div style="display:inline-block; margin: 10px; font-size:1.4em;"><image style="vertical-align: top;" src="image/cart_add.png" /></span><?php echo $text_quick_quote; ?></div>
		</div>
		<?php if(!$hide_matrix) { ///could be zero ?>
		<div align="center" style="padding:10px;">
			<div align="center"><?php echo $text_select_sizes_and_colors; ?></div>
			<a id="button_sizes_colors" class="button" style="white-space: nowrap;"><?php echo $text_sizes_and_colors; ?></a>
		</div>
		<?php } ?>
		<?php if(empty($error_warning) && $total_price!==false) { ///could be zero ?>
			<div style="padding: 5px;" class="ui-corner-all ui-widget-header ui-state-highlight" align="center">
				<div style="font-size:2em;line-height:35px; margin-bottom:5px;">
					<span><?php echo $total_price; ?></span>
				</div>
				<div>
					<a style="cursor:pointer; display:inline-block; padding:5px; background: #17f80d url(image/ui-bg_glass_75_17f80d_1x400.png) 50% 50% repeat-x; color: #000;" class="ui-widget-content ui-corner-all ui-state-default" onmouseover="$(this).addClass('ui-state-hover')" onmouseout="$(this).removeClass('ui-state-hover')"  onclick="saveDesign(true);" id="btn_add_cart" >
						<image style="vertical-align: top;" src="image/cart_add.png" />
						<span style="font-size:20px;"><?php echo $button_cart; ?></span>
					</a>
				</div>
			</div>
		<?php } ?>
	
	<?php if($error_warning) { ?>
		<div id="header_error" style="padding: 5px 30px 5px 5px;" class="ui-state-error ui-corner-all"  >
			<p align="left">
				<span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-info"></span>
				<span style="text-align:left; max-width:400px; display:block;"><?php echo $error_warning; ?></span>
			</p>
		</div>
	<?php } ?>

	<?php if(empty($error_warning)) : ?>
		<div style="margin-top: 10px; line-height: 25px;"> 
			<p><b><?php echo $text_quote_details; ?></b></p>
			<p style="white-space:nowrap;"> <span><?php echo $text_number_products; ?></span> <span><?php echo $amount_products; ?></span><br />
				<span><?php echo $text_price_per_product; ?></span> <span><?php echo $unit_price; ?></span><br />
				<span><?php echo $text_upcharge_larger_size; ?></span> <span><?php echo $product_upcharge_total; ?></span><br />
				<?php echo (isset($printing_html))?$printing_html:''; ?>
			</p>
		</div>
	<?php endif; ?>
	</div>
</div>

<div id="promp_colors_sizes" style="display:none;" title="<?php echo $text_dialog_title; ?>"  >
	<div align="left" style="padding:0px" >
		<form id="prices_form" method="post" action="index.php?route=studio/price"  >	
			<div align="center">
				<a style="margin-bottom:.5em;" id="btn_recalculate_pricing"><?php echo $button_recalculate; ?></a>
			</div>
			<!-- add submit button only to enable send form by pressing enter key  -->
			<input type="submit" style="display:none" />
			<input type="hidden" value="<?php echo $price_studio_id; ?>" name="price_studio_id" id="price_studio_id" />
			<div id="price_color_size_matrix_container" style="padding:10px;" align="center"  class="ui-widget-content ui-corner-all">
				<table cellpadding="5" cellspacing="0" style="margin:1px; ">
					<tr style="font-weight:bold; position:relative; display: block;">
						<td width="185"></td>
						<td width="60"></td>
						<?php foreach($product_sizes_header as $size_header) : ?>
						<td align="center" valign="top" width="60"><?php echo $size_header['name']; ?>
							<?php if($size_header['upcharge']) : ?>
							<br /><span style="font-size:10px;"><?php echo $size_header['upcharge']; ?></span></td>
							<?php endif; ?>
						<?php endforeach; ?>
					</tr>
				</table>
				<div style="display: block; height: 300px; overflow: auto;">
				<table cellpadding="5" cellspacing="0" style="margin:1px; ">
					<?php $repeat_header_counting = 0; ?>
					<?php foreach($product_colors as $id_product_color) : ?>
					<tr height="20">
						<td width="200" style="margin: 0px 5px 0px 5px; font-size:12px" align="left" valign="top" nowrap="nowrap"><?php echo $all_colors[$id_product_color]['name']; ?></td>
						<td width="60" height="20"  align="center" valign="top">
							<table width="100%" height="100%" onclick="studioChangeProductColor('<?php echo $id_product_color; ?>')" cellpadding="0" cellspacing="0" class="ui-widget-content">
								<tr style="cursor:pointer; ">
								<?php foreach($all_colors[$id_product_color]['hexa'] as $hexa) : ?>
									<td style="background-color:#<?php echo $hexa; ?>;">&nbsp;</td>
								<?php endforeach; ?>
								</tr>
							</table>
						</td>
						<?php foreach($product_sizes as $id_product_size) : ?>
						<td align="center" valign="top" width="60">
						<?php if($matrix_color_size_quantity[$id_product_color][$id_product_size]!==false) : ?>
							<input class="ui-widget-content ui-corner-all" size="4" type="text" title="<?php echo $all_sizes[$id_product_size]['initials'] ?>" data="quantity" name="quantity_s_c[<?php echo $id_product_color; ?>][<?php echo $id_product_size; ?>]" value="<?php echo $matrix_color_size_quantity[$id_product_color][$id_product_size]; ?>"  />
						<?php else : ?>
							<input class="ui-widget-content ui-corner-all ui-state-disabled" size="4" type="text" disabled="disabled" />
						<?php endif; ?>
						</td>
						<?php endforeach; ?>
					</tr>
					<?php endforeach; ?>
				</table>
			</div>
			</div>
		</form>
	</div>
</div>


<script type="text/javascript">
//called from save.tpl
function addToCart()
{	
	success = function(data) {
		if(data.redirect) {
			location.href = data.redirect;
			return;
		}
		$("#popup_container").html(data.output);
		$( "#popup_dialog" ).dialog( "option", "position", 'center' );
	}
	loadPopUp('index.php?route=studio/price/add_to_cart', $('#prices_form').serialize(), "POST",  success, "json");
}

function sendPricesForm() {
	var serialized_vars = $("#prices_form").serialize();
	$( '#promp_colors_sizes' ).remove(); 
	loadAjaxHtml('index.php?route=studio/price', "#price_container", serialized_vars, "POST");
}


var my_price_global_timeout;

$(function() {
	$( ".button" ).button();

	$( "#btn_recalculate_pricing" ).button({icons: {primary: "ui-icon-circle-plus"}}).click(function() {
	  
	  $( "#prices_form" ).submit();
	});

	$( "#button_sizes_colors" ).button({icons: {primary: "ui-icon-circle-plus"}}).click(function() {
	  $( '#promp_colors_sizes' ).dialog('destroy'); 
	  $( '#promp_colors_sizes' ).dialog({
			autoOpen: true,
			height: 'auto',
			width: 'auto',
			minHeight: 50,
			minWidth: 200,
			modal: true
		});
	});

	
	$( "#prices_form" ).submit(function(event) {

		event.preventDefault(); 	

		clearTimeout(my_price_global_timeout);
		my_price_global_timeout = setTimeout(sendPricesForm,1500);

		$("#price_div_to_fade").fadeTo('fast', 0.2);

		$( '#promp_colors_sizes' ).dialog('close');

		$("#img_quote_loading").show();

		$("#btn_recalculate_pricing").button( "option", "disabled", true );
		$("#button_sizes_colors").button( "option", "disabled", true );
		$("#btn_add_cart").hide();

		return false;
	});

	/*
	cannot bind here because it would be bundled each time is reloaded
	$(document).bind("onStudioIdChange", function(event, studio_id) {
		$("#price_studio_id").val(studio_id);	
		$( "#prices_form" ).submit();
	});

	$(document).bind("onProductChanged", function(event) {
		//show panel
		$( "#price_container" ).show();
		$( "#prices_form" ).submit();
	});

	$(document).bind("onPriceChange", function(event) {
		$( "#prices_form" ).submit();
	});
	*/
	$( "#price_container" ).css({
		top: 37, 
		left: $(window).width() - $( "#price_container" ).outerWidth()
	});
	

});
</script> 
