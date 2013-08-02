<?php echo $header; ?>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>
  <?php if ($success) { ?>
  <div class="success"><?php echo $success; ?></div>
  <?php } ?>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/product.png" alt="" /> <?php echo $heading_title; ?></h1>
      <div class="buttons"><a onclick="location = '<?php echo $insert; ?>'" class="button"><?php echo $button_insert; ?></a><a onclick="$('form').submit();" class="button"><?php echo $button_delete; ?></a></div>
    </div>
    <div class="content">
      <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
		<div class="pagination"><?php echo $pagination; ?></div>
		<div style="padding:10px 0px; "><?php echo $text_limit; ?><input type="text" name="limit" class="ui-widget-content" value="<?php echo $limit; ?>" /></div>
		<table class="list">
		  <thead>
			<tr>
			  <td width="1" style="text-align: center;"><input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /></td>
			  <td class="left"><?php echo $column_id_product_color; ?></td>
			  <td class="left" width="40%"><?php if ($sort == 'pc.name') { ?>
				<a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_name; ?></a>
				<?php } else { ?>
				<a href="<?php echo $sort_name; ?>"><?php echo $column_name; ?></a>
				<?php } ?>
			  </td>
			  <td class="right"><?php if ($sort == 'pc.num_colors') { ?>
				<a href="<?php echo $sort_num_colors; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_num_colors; ?></a>
				<?php } else { ?>
				<a href="<?php echo $sort_num_colors; ?>"><?php echo $column_num_colors; ?></a>
				<?php } ?></td>
			  <td class="left"><?php echo $column_hexa; ?></td>
			  <td class="left"><?php echo $column_need_white_base; ?></td>
			  <td class="left"><?php if ($sort == 'pc.id_product_color_group') { ?>
				<a href="<?php echo $sort_id_product_color_group; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_id_product_color_group; ?></a>
				<?php } else { ?>
				<a href="<?php echo $sort_id_product_color_group; ?>"><?php echo $column_id_product_color_group; ?></a>
				<?php } ?></td>
			  <td class="right"><?php echo $column_action; ?></td>
			</tr>
		  </thead>
		  <tbody>
			<tr class="filter">
			  <td></td>
			  <td class="left"><input type="text" name="filter_id_product_color" value="<?php echo $filter_id_product_color; ?>" size="20" /></td>
			  <td></td>
			  <td class="right"><input type="text" name="filter_num_colors" value="<?php echo $filter_num_colors; ?>" /></td>
			  <td></td>
			  <td></td>
			  <td><input type="text" name="filter_id_product_color_group" value="<?php echo $filter_id_product_color_group; ?>" /></td>
			  <td></td>
			</tr>
			<?php if ($colors) { ?>
				<?php foreach ($colors as $color) { ?>
				<tr>
				  <td style="text-align: center;"><?php if ($color['selected']) { ?>
					<input type="checkbox" name="selected[]" value="<?php echo $color['id_product_color']; ?>" checked="checked" />
					<?php } else { ?>
					<input type="checkbox" name="selected[]" value="<?php echo $color['id_product_color']; ?>" />
					<?php } ?></td>
				  <td class="left"><?php echo $color['id_product_color']; ?></td>
				  <td class="left"><?php echo $color['name']; ?></td>
				  <td class="right"><?php echo $color['num_colors']; ?></td>
				  <td class="left">
					<table  style="width:75px; height:10px;"  cellpadding="0" cellspacing="0">
					<tr><?php foreach($color["hexa"] as $hexa) { ?>
						<td style="background-color:#<?php echo $hexa; ?>;">&nbsp;</td>
						<?php } ?>
					</tr>
					</table>
				  </td>
				  <td class="left"><?php echo $color['need_white_base']; ?></td>
				  <td class="left" style="background-color:#<?php echo $color_groups[$color['id_product_color_group']]['color']; ?>"><?php echo $color_groups[$color['id_product_color_group']]['description']; ?></td>
				  <td class="right"><?php foreach ($color['action'] as $action) { ?>
				[ <a href="<?php echo $action['href']; ?>"><?php echo $action['text']; ?></a> ]
				<?php } ?></td>
				</tr>
				<?php } ?>
			<?php } else { ?>
			<tr>
			  <td align="center" colspan="7"><?php echo $text_no_results; ?></td>
			</tr>
			<?php } ?>
		  </tbody>
		</table>
      </form>
      <div class="pagination"><?php echo $pagination; ?></div>
    </div>
  </div>
</div>
<script type="text/javascript"><!--
function filter() {
	url = 'index.php?route=product/color/_list&token=<?php echo $token; ?>';
	
	var filter_id_product_color = $('input[name=\'filter_id_product_color\']').attr('value');
	
	if (filter_id_product_color) {
		url += '&filter_id_product_color=' + encodeURIComponent(filter_id_product_color);
	}
	
	var filter_num_colors = $('input[name=\'filter_num_colors\']').val();
	
	if (filter_num_colors != '') {
		url += '&filter_num_colors=' + encodeURIComponent(filter_num_colors);
	}
	
	var filter_id_product_color_group = $('input[name=\'filter_id_product_color_group\']').val();
	
	if (filter_id_product_color_group != '') {
		url += '&filter_id_product_color_group=' + encodeURIComponent(filter_id_product_color_group);
	}
		
	var limit = $('input[name=\'limit\']').attr('value');
	
	if (limit) {
		url += '&limit=' + encodeURIComponent(limit);
	}
				
	location = url;
}
//--></script>  
<script type="text/javascript"><!--
$('#form input').keydown(function(e) {
	if (e.keyCode == 13) {
		filter();
	}
});
//--></script> 
<?php echo $footer; ?>