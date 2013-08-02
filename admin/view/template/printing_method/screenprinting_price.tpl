<style type="text/css">
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
  <div class="warning"><?php echo $error_quantities; ?></div>
  <?php } ?>
  <?php if ($error_price) { ?>
  <div class="warning"><?php echo $error_price; ?></div>
  <?php } ?>
  <?php if ($error_screen_charges) { ?>
  <div class="warning"><?php echo $error_screen_charges; ?></div>
  <?php } ?>
  <div class="box">
    <div align="center">
		<div style="margin:10px;"><?php echo $text_max_colors; ?> 
			<select name="max_colors" onchange="updateNumColors()">
			<?php for($i=1; $i<=$printing_colors_limit; $i++) { ?>
			<option value="<?php echo $i; ?>" <?php if($i==$max_colors) { ?> selected="selected" <?php } ?>><?php echo $i; ?></option>
			<?php } ?>
			</select>
			<?php echo $text_max_colors_help; ?>
		</div>

		<span style="float:right;">
			<img src="view/image/add.png" /><a onclick="addColumn()"><?php echo $text_add_quantity; ?></a> | 
			<?php echo $text_increment; ?> <input type="text" id="quantity_increment" value="12" style="width:25px;"  /><br />
			<?php //echo $text_decrement; ?><!-- <input type="text" id="price_decrement" value="2.5"  /><br /> -->
		</span>
		<div id="first_col" style=" width:130px; float:left">
			<div style="line-height:25px; white-space:nowrap" class="ui-widget-header"><?php echo $text_minimum_quantity; ?></div>
			<div style="line-height:25px; white-space:nowrap; background-color: yellowgreen;"><?php echo $text_screen_charge; ?></div>
			<?php foreach($price as $num_colors=>$array_quantity) { ?>
			<div style="line-height:25px;"><?php echo $num_colors; ?> <?php echo $text_colors; ?></div>
			<?php } ?>
		</div>
		<ul id="matrix_list">
		<?php if($quantities) { ?>
			<?php foreach($quantities as $index=>$quantity) { ?>
			<li class="ui-widget-content">
				<div style="position:relative;" class="ui-widget-header"><input type="text" style="width:25px;" name="quantities[]" value="<?php echo $quantity; ?>" title="quantity" /><a style="position:absolute; right:0; top:0; cursor:pointer;" class="ui-icon ui-icon-close" onclick="removeClick($(this).parents('li'));"></a></div>
				<div style="white-space:nowrap; background-color: yellowgreen;" class="price"><?php echo $symbol_left; ?> <input type="text" style="width:45px;" data="price" name="screen_charges[]" value="<?php echo $screen_charges[$index]; ?>" /> <?php echo $symbol_right; ?></div>
				<?php foreach($price as $num_colors=>$array_quantity) { ?>
					<div style="white-space:nowrap;" class="price"><?php echo $symbol_left; ?> <input type="text" style="width:45px;" data="price" name="price[<?php echo $num_colors; ?>][]" value="<?php echo $price[$num_colors][$index]; ?>" /> <?php echo $symbol_right; ?></div>
				<?php } ?>
			</li>
			<?php } ?>
		<?php } else { ?>
			<li class="ui-widget-content">
				<div style="position:relative;" class="ui-widget-header"><input type="text" style="width:25px;" name="quantities[]" value="0" title="quantity" /><a style="position:absolute; right:0; top:0; cursor:pointer;" class="ui-icon ui-icon-close" onclick="removeClick($(this).parents('li'));"></a></div>
				<div style="white-space:nowrap; background-color: yellowgreen;" class="price"><?php echo $symbol_left; ?> <input type="text" style="width:45px;" data="price" name="screen_charges[]" value="0" /> <?php echo $symbol_right; ?></div>
				<?php foreach($price as $num_colors=>$array_quantity) { ?>
					<div style="white-space:nowrap;" class="price"><?php echo $symbol_left; ?> <input type="text" style="width:45px;" data="price" name="price[<?php echo $num_colors; ?>][]" value="0" /> <?php echo $symbol_right; ?></div>
				<?php } ?>
			</li>
		<?php } ?>
    </div>
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
function updateNumColors()
{
	var num = $('select[name=\'max_colors\']').val();
	
	$("#matrix_list > li").each(function(index) {	
		var current = parseInt($(this).children('div.price').length) - 1;
		var dif = num - current;
		if(dif>0) {
			for(var i=current+1; i<=num; i++) {
				$(this).children('div.price:last').clone().appendTo(this).find('input[data=price]').attr('name','price['+ i +'][]');
			}
		} else {
			for(var i=current; i>num; i--) {
				$(this).children('div.price:last').remove();
			}
		}
	});
	
	var current = parseInt($("#first_col > div").length) - 2;
	var dif = num - current;
	if(dif>0) {
		for(var i=current+1; i<=num; i++) {
			$("#first_col > div:last").clone().appendTo($("#first_col")).html(i +' <?php echo $text_colors; ?>');
		}
	} else {
		for(var i=current; i>num; i--) {
			$("#first_col > div:last").remove();
		}
	}

}

$(document).ready(function() {
	$( "#matrix_list" ).sortable();
});
//--></script>