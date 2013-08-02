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
				<td align="right"><?php echo $entry_name; ?></td>
				<td align="left"><input type="text" name="name" value="<?php echo $name; ?>">
				<?php if ($error_name) { ?>
				<span class="error"><?php echo $error_name; ?></span>
				<?php } ?>
				</td>
			</tr>
			<tr>
				<td align="right"><?php echo $entry_code; ?></td>
				<td align="left"><input type="text" name="code" value="<?php echo $code; ?>" size="20" >
				</td>
			</tr>
			<tr>
				<td align="right"><?php echo $entry_status; ?></td>
				<td align="left">
				<select name="status">
				<?php foreach ($statuses as $item) { ?>
					  <?php if ($item['val'] === $status) { ?>
					  <option value="<?php echo $item['val']; ?>" selected="selected"><?php echo $item['description']; ?></option>
					  <?php } else { ?>
					  <option value="<?php echo $item['val']; ?>"><?php echo $item['description']; ?></option>
					  <?php } ?>
				  <?php } ?>
				</select>
				<?php if ($error_status) { ?>
				<span class="error"><?php echo $error_status; ?></span>
				<?php } ?>
				</td>
			</tr>
			<tr>
				<td align="right"><?php echo $entry_need_white_base; ?> </td>
				<td align="left">
					<input type="radio" value="1" name="need_white_base" <?php if ($need_white_base == '1') { ?> checked="checked" <?php } ?>><?php echo $text_yes; ?><br />
					<input type="radio" value="0" name="need_white_base" <?php if ($need_white_base == '0') { ?> checked="checked" <?php } ?>><?php echo $text_no; ?>
					</td>
			</tr>
			<tr>
				<td align="right"><?php echo $entry_hexa; ?> </td>
				<td align="left">
				<span class="jscolor_span" id="span_hexa"></span>
				<input class="ui-widget-content ui-corner-all jscolor_input" type="text" name="hexa" id="hexa" value="<?php echo $hexa; ?>" />
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
	
	
	new jscolor.color(document.getElementById('hexa'), {styleElement:'span_hexa'});
	
	//$("#hexa").val(value);
	//$("#span_hexa").css("backgroundColor", "#"+value); 

});
//--></script> 
<?php echo $footer; ?>