<style type="text/css">
#upcharge_list {
	list-style:none;
	margin:0;
}
#matrix_list {
	list-style:none;
	margin:0;
}
#matrix_list li {
	float:left;
	width:80px;
	cursor:move;
}
#matrix_list li div {
	line-height:25px;
}
</style>
<?php if ($error_quantities) { ?>
<div class="ui-widget-content ui-state-error" style="padding: 5px; margin: 5px;"><?php echo $error_quantities; ?></div>
<?php } ?>
<?php if ($error_price) { ?>
<div class="ui-widget-content ui-state-error" style="padding: 5px; margin: 5px;"><?php echo $error_price; ?></div>
<?php } ?>
<div class="content" align="center">
<span style="float:right;">
	<img src="view/image/add.png" /><a onclick="addColumn()"><?php echo $text_add_quantity; ?></a> | 
	<?php echo $text_increment; ?> <input type="text" id="quantity_increment" value="12" style="width:25px;"  /><br />
	<?php //echo $text_decrement; ?><!-- <input type="text" id="price_decrement" value="2.5"  /><br /> -->
</span>
<div style=" width:100px; float:left">
	<div style="line-height:25px; white-space:nowrap"><?php echo $text_minimum_quantity; ?></div>
	<?php foreach($color_groups as $color_group) { ?>
	<div style="line-height:25px;"><?php echo $color_group["description"]; ?></div>
	<?php } ?>
</div>
<ul id="matrix_list">
<?php if($quantities) { ?>
	<?php foreach($quantities as $index=>$quantity) { ?>
	<li class="ui-widget-content">
		<div style="position:relative;"><input type="text" style="width:25px;" name="quantities[]" value="<?php echo $quantity; ?>" title="quantity" /><a style="position:absolute; right:0; top:0; cursor:pointer;" class="ui-icon ui-icon-close" onclick="removeClick($(this).parents('li'));"></a></div>
		<?php foreach($color_groups as $color_group) { ?>
			<div style="background-color:#<?php echo $color_group["color"]?>; white-space:nowrap;"><?php echo $symbol_left; ?> <input type="text" style="width:45px;" name="price[<?php echo $color_group["id_product_color_group"]; ?>][]" value="<?php echo $price[$color_group["id_product_color_group"]][$index]; ?>" /> <?php echo $symbol_right; ?></div>
		<?php } ?>
	</li>
	<?php } ?>
<?php } else { ?>
	<li class="ui-widget-content">
		<div style="position:relative;"><input type="text" style="width:25px;" class="ui-widget-content ui-corner-all" name="quantities[]" value="0" title="quantity" /><a style="position:absolute; right:0; top:0; cursor:pointer;" class="ui-icon ui-icon-close" onclick="removeClick($(this).parents('li'));"></a></div>
		<?php foreach($color_groups as $color_group) { ?>
			<div style="background-color:#<?php echo $color_group["color"]?>; white-space:nowrap;"><?php echo $symbol_left; ?> <input type="text" style="width:45px;" name="price[<?php echo $color_group["id_product_color_group"]; ?>][]" value="0" /> <?php echo $symbol_right; ?></div>
		<?php } ?>
	</li>
<?php } ?>
</ul>
<div style="clear:both;"></div>
<?php if ($error_upcharge) { ?>
<div class="ui-widget-content ui-state-error" style="padding: 5px; margin: 5px;"><?php echo $error_upcharge; ?></div>
<?php } ?>
<p><?php echo $text_upcharge; ?></p>
<ul id="upcharge_list">
<?php foreach($sizes_upcharge as $size) { ?>
	<li><?php echo $size['initials']; ?>: <?php echo $symbol_left; ?> <input type="text" style="width:50px;" data="upcharge" name="upcharge[<?php echo $size["id_product_size"]; ?>]" value="<?php if(isset($upcharge[$size["id_product_size"]])) { echo $upcharge[$size["id_product_size"]]; } else { echo '0'; } ?>"/> <?php echo $symbol_right; ?></li>
<?php } ?>
</ul>
</div>
<script type="text/javascript"><!--
function removeClick(li)
{
	if($("#matrix_list > li").length > 1) {
		li.slideUp(300, function() {
			$(this).remove();
		});
	}
}
function addColumn()
{
	var li = $("#matrix_list > li:last-child").clone();
	li.appendTo("#matrix_list").slideDown(300);
	var last_value = parseInt(li.find('input[name=\'quantities[]\']').val());
	if (!isNaN(last_value)) {
		li.find('input[name=\'quantities[]\']').val(last_value+parseInt($("#quantity_increment").val()));
	}
	//li.find('input[name=\'price[1][]\']').val(parseFloat(li.find('input[name=\'price[1][]\']').val())-parseFloat($("#price_decrement").val()));
}
$(document).ready(function() {	
	$( "#matrix_list" ).sortable();
	if($( "#matrix_list" ).children().length==0)
	{
		addColumn();
		addColumn();
		addColumn();
	}
});
//--></script> 

