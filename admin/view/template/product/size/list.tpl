<?php echo $header; ?>
<style>
#sortable { list-style-type: none; margin: 0; padding: 0; width: 100%; }
#sortable li { margin: 0px; padding: 0px; cursor:move; }
.ui-state-highlight { height: 1.5em; line-height: 1.2em; }
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
		<input type="hidden" name="limit" class="ui-widget-content" value="<?php echo $limit; ?>" />		
		<table class="list" style="margin-bottom:0;">
		  <thead>
			<tr>
			  <td width="10" style="text-align: center;"><input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /></td>
			  <td width="200" class="left"><?php echo $column_id_product_size; ?></td>
			  <td width="300" class="left" width="90%"><?php if ($sort == 'description') { ?>
				<a href="<?php echo $sort_description; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_description; ?></a>
				<?php } else { ?>
				<a href="<?php echo $sort_description; ?>"><?php echo $column_description; ?></a>
				<?php } ?>
			  </td>
			  <td width="50" class="left"><?php echo $column_initials; ?></td>
			  <td width="100" class="left"><?php if ($sort == 'apply_additional_cost') { ?>
				<a href="<?php echo $sort_apply_additional_cost; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_apply_additional_cost; ?></a>
				<?php } else { ?>
				<a href="<?php echo $sort_apply_additional_cost; ?>"><?php echo $column_apply_additional_cost; ?></a>
				<?php } ?></td>
			  <td width="50" class="left"><?php if ($sort == 'sort') { ?>
				<a href="<?php echo $sort_sort; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_sort; ?></a>
				<?php } else { ?>
				<a href="<?php echo $sort_sort; ?>"><?php echo $column_sort; ?></a>
				<?php } ?></td>
			  <td class="right"><?php echo $column_action; ?></td>
			</tr>
		  </thead>
		  <tbody>
			<tr class="filter">
			  <td></td>
			  <td class="left"><input type="text" name="filter_id_product_size" class="ui-widget-content" value="<?php echo $filter_id_product_size; ?>" size="20" style="text-align: right;" /></td>
			  <td></td>
			  <td></td>
			  <td class="left"><select name="filter_apply_additional_cost" class="ui-widget-content" onchange="filter();">
			  <?php foreach ($apply_additional_cost_status as $status) { ?>
				  <?php if ($status['val'] === $filter_apply_additional_cost) { ?>
				  <option value="<?php echo $status['val']; ?>" selected="selected"><?php echo $status['description']; ?></option>
				  <?php } else { ?>
				  <option value="<?php echo $status['val']; ?>"><?php echo $status['description']; ?></option>
				  <?php } ?>
			  <?php } ?>
			</select>
			  <td></td>
			  <td></td>
			</tr>
			<?php if (!$sizes) { ?>
			<tr>
			  <td align="center" colspan="7"><?php echo $text_no_results; ?></td>
			</tr>
			<?php } ?>
		  </tbody>
		</table>
		
		<?php if ($sizes) { ?>
			<ul id="sortable">
			<?php foreach ($sizes as $size) { ?>
			<li>
			<input type="hidden" name="sorting[]" value="<?php echo $size['id_product_size']; ?>" />
			<table class="list" style="margin-bottom:0;">
			<tbody>
			<tr>
			  <td width="10" style="text-align: center;"><?php if ($size['selected']) { ?>
			<input type="checkbox" name="selected[]" value="<?php echo $size['id_product_size']; ?>" checked="checked" />
			<?php } else { ?>
			<input type="checkbox" name="selected[]" value="<?php echo $size['id_product_size']; ?>" />
			<?php } ?></td>
			  <td width="200" class="left"><span style="display:block; width:200px; overflow:hidden"><?php echo $size['id_product_size']; ?></span></td>
			  <td width="300" class="left"><?php echo $size['description']; ?></td>
			  <td width="50" class="left"><?php echo $size['initials']; ?></td>
			  <td width="100" class="left"><?php echo $size['apply_additional_cost']; ?></td>
			  <td width="50" class="left"><?php echo $size['sort']; ?></td>
			  <td class="right"><?php foreach ($size['action'] as $action) { ?>
			[ <a href="<?php echo $action['href']; ?>"><?php echo $action['text']; ?></a> ]
			<?php } ?></td>
			</tr>
			</tbody>
			</table>
			</li>
			<?php } ?>
			</ul>
			<div align="center" style="padding:10px;">
			<a onclick="$('#form').attr('action', '<?php echo $save_order; ?>'); $('#form').attr('target', '_self'); $('#form').submit();" class="button"><?php echo $button_save_order; ?></a>
			</div>
		<?php } ?>
      </form>
    </div>
  </div>
</div>
<script type="text/javascript"><!--
function filter() {
	url = 'index.php?route=product/size/_list&token=<?php echo $token; ?>';
	
	var filter_id_product_size = $('input[name=\'filter_id_product_size\']').attr('value');
	
	if (filter_id_product_size) {
		url += '&filter_id_product_size=' + encodeURIComponent(filter_id_product_size);
	}
	
	var filter_apply_additional_cost = $('select[name=\'filter_apply_additional_cost\']').val();
	
	if (filter_apply_additional_cost != '') {
		url += '&filter_apply_additional_cost=' + encodeURIComponent(filter_apply_additional_cost);
	}
			
	var limit = $('input[name=\'limit\']').attr('value');
	
	if (limit) {
		url += '&limit=' + encodeURIComponent(limit);
	}
				
	location = url;
}
//--></script>  
<script type="text/javascript"><!--
$(document).ready(function() {	
	$( "#sortable" ).sortable({
		placeholder: "ui-state-highlight"
	});

	$( "#sortable" ).disableSelection();

});
//--></script> 
<script type="text/javascript"><!--
$('#form input').keydown(function(e) {
	if (e.keyCode == 13) {
		filter();
	}
});
//--></script> 
<?php echo $footer; ?>