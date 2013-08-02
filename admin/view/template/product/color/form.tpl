<?php echo $header; ?>
<style>
.jscolor_span {
	display: inline-block; 
	width:15px; height:15px; 
	border:solid 1px #333;
}
.jscolor_input {
	width:55px; margin-right:25px;
}
.color_picker_list {
	list-style:none;
	padding:0;
}
</style>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/product.png" alt="" /> <?php echo $heading_title; ?></h1>
      <div class="buttons"><a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a><a onclick="location = '<?php echo $cancel; ?>';" class="button"><?php echo $button_cancel; ?></a></div>
    </div>
    <div class="content">
      <div id="tabs" class="htabs"><?php echo $tab_data; ?></a></div>
      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
        <div id="tab-data">
          <table class="form">
            <tr>
              <td><span class="required">*</span> <?php echo $entry_name; ?></td>
              <td><input type="text" name="name" value="<?php echo $name; ?>" />
                <?php if ($error_name) { ?>
                <span class="error"><?php echo $error_name; ?></span>
                <?php } ?></td>
            </tr>
            <tr>
              <td><?php echo $entry_num_colors; ?></td>
              <td>
	          	<?php if ($editable_num_colors) { ?>
					<?php foreach($color_numbers_images as $i=>$image) { ?>
					<div align="center" style="float:left; width:36px; height:40px;">
						<?php echo $i; ?><input type="radio" <?php if($num_colors==$i) { ?> checked="checked" <?php } ?> name="num_colors" value="<?php echo $i; ?>" onclick="setNumColors(<?php echo $i; ?>)"  /><br />
						<img src="<?php echo $image; ?>" />
					</div>
					<?php } ?>
				<?php } else { ?>
						<?php echo $num_colors; ?><input type="hidden" name="num_colors" value="<?php echo $num_colors; ?>"  />
						<img src="<?php echo $color_numbers_images[$num_colors]; ?>" />
				<?php } ?>
			  </td>
            </tr>
            <tr>
				<td><?php echo $entry_color_group; ?></td>
				<td>
				<select name="id_product_color_group">
				  <?php foreach ($color_groups as $color_group) { ?>
					  <?php if ($color_group['id_product_color_group'] == $id_product_color_group) { ?>
					  <option value="<?php echo $color_group['id_product_color_group']; ?>" selected="selected"><?php echo $color_group['description']; ?></option>
					  <?php } else { ?>
					  <option value="<?php echo $color_group['id_product_color_group']; ?>"><?php echo $color_group['description']; ?></option>
					  <?php } ?>
				  <?php } ?>
				</select>
				</td>
			 </tr>
			  <tr>
				<td><?php echo $entry_need_white_base; ?> </td>
				<td>
					<input type="radio" value="1" name="need_white_base" <?php if ($need_white_base == '1') { ?> checked="checked" <?php } ?>><?php echo $text_yes; ?><br />
					<input type="radio" value="0" name="need_white_base" <?php if ($need_white_base == '0') { ?> checked="checked" <?php } ?>><?php echo $text_no; ?>
				</td>
			  </tr>
			  <tr>
				<td><?php echo $entry_hexa; ?> </td>
				<td>
				<ul class="color_picker_list">
				</ul>
				<?php if ($error_hexa) { ?>
				<span class="error"><?php echo $error_hexa; ?></span>
				<?php } ?></td>
			  </tr>
          </table>
        </div>
      </form>
    </div>
  </div>
</div>
<script type="text/javascript"><!--
$('#tabs a').tabs(); 
//--></script> 
<script type="text/javascript"><!--
$(document).ready(function() {	
	<?php foreach ($hexa as $hexa_value) { ?>
	  appendColorPicker('<?php echo $hexa_value; ?>');
  	<?php } ?>

});
function setNumColors(num) {
	var dif = num - $('ul.color_picker_list').children('li').length;
	if(dif<0) {
		for(var i=dif; i<0; i++) {
			removeLastColorPicker();
		}
	} else if(dif>0) {
		for(var i=0; i<dif; i++) {
			appendColorPicker('FFFFFF');
		}
	}
}

function appendColorPicker(value) {
	var i = Math.random()*100000000000000000;
	var html  = '<li>';
		html += 	'<span class="jscolor_span" id="span_hexa_' + i + '"></span> ';
		html += 	'<input class="ui-widget-content ui-corner-all jscolor_input" type="text" name="hexa[]" id="hexa_' + i + '" />';
		html += '</li>';
	$(html).appendTo('ul.color_picker_list');
	
	new jscolor.color(document.getElementById('hexa_'+i), {styleElement:'span_hexa_'+i});
	
	$("#hexa_"+i).val(value);
	$("#span_hexa_"+i).css("backgroundColor", "#"+value); 

}
function removeLastColorPicker() {
	$('ul.color_picker_list li:last-child').remove();
}
//--></script> 
<?php echo $footer; ?>