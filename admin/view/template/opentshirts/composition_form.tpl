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
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/product.png" alt="" /> <?php echo $heading_title; ?></h1>
      <div class="buttons"><a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a><a onclick="location = '<?php echo $cancel; ?>';" class="button"><?php echo $button_cancel; ?></a></div>
    </div>
    <div class="content">
      <div id="tabs" class="htabs"><a href="#tab-data"><?php echo $tab_data; ?></a><a href="#tab-categories"><?php echo $tab_categories; ?></a></div>
      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
        <div id="tab-data">
          <table class="form">
			  <tr>
				<td align="right" style="margin:0 10px;" nowrap="nowrap"><?php echo $entry_name; ?> * </td>
				<td align="left"><input type="text" name="name" value="<?php echo $name; ?>" class="ui-corner-all ui-widget-content form_input" >
				<?php if ($error_name) { ?>
				<span class="ui-state-error ui-corner-all msg-padding"><?php echo $error_name; ?></span>
				<?php } ?>
				</td>
			  </tr>
			 <tr>
				<td align="right" style="margin:0 10px;" nowrap="nowrap"><?php echo $entry_status; ?></td>
				<td align="left"><select name="status" class="ui-widget-content">
				  <?php foreach ($statuses as $item) { ?>
					  <?php if ($item['val'] === $status) { ?>
					  <option value="<?php echo $item['val']; ?>" selected="selected"><?php echo $item['description']; ?></option>
					  <?php } else { ?>
					  <option value="<?php echo $item['val']; ?>"><?php echo $item['description']; ?></option>
					  <?php } ?>
				  <?php } ?>
				</select>
				</td>
			 </tr>
			  <tr>
				<td align="right" valign="top" nowrap="nowrap"><?php echo $entry_keywords; ?></td>
			   <td align="left"><input name="keywords" type="text" value="<?php echo $keywords; ?>"  class="ui-corner-all ui-widget-content form_input" ></td>
			  </tr>
			  <tr>
				<td colspan="2">
				  <a class="ui-widget-content" style="border-width: 0 0 1px 0; padding:3px; margin:1px; " id="a" href="<?php echo $images[0]['original']; ?>" target="_new"><img border="0" id="img" src="<?php echo $images[0]['large']; ?>" /></a>
				  <ul style="list-style:none; padding:0">
				  <?php foreach ($images as $image) { ?>
					<li class="ui-widget-content" style="float:left; cursor:pointer; margin:2px;  " onclick="$('#img').attr('src','<?php echo $image['original']; ?>'); $('#a').attr('href','<?php echo $image['large']; ?>'); "><img src="<?php echo $image['thumb']; ?>" /></li>
					<?php } ?>
				  </ul>					
				</td>
			  </tr>
			</table>
        </div>
        <div id="tab-categories">
          <?php echo $category_tab; ?>
        </div>        
      </form>
    </div>
  </div>
</div>
<script type="text/javascript"><!--
$(document).ready(function() {	
	$('#tabs a').tabs(); 

});
//--></script> 
<?php echo $footer; ?>