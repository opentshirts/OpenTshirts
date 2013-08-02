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
      <div id="tabs" class="htabs"><a href="#tab-data"><?php echo $tab_data; ?></a><a href="#tab-categories"><?php echo $tab_categories; ?></a><a href="#tab-appearance"><?php echo $tab_appearance; ?></a></div>
      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
        <div id="tab-data">
          <table class="form">
    			  <tr>
    				<td><span class="required">*</span> <?php echo $entry_name; ?></td>
    				<td><input type="text" name="name" value="<?php echo $name; ?>" >
    				<?php if ($error_name) { ?>
    				<span class="error"><?php echo $error_name; ?></span>
    				<?php } ?>
    				</td>
    			  </tr>
    			 <tr>
    				<td><?php echo $entry_status; ?></td>
    				<td><select name="status">
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
    				<td><?php echo $entry_keywords; ?></td>
    			    <td><input name="keywords" type="text" value="<?php echo $keywords; ?>"></td>
    			  </tr>
    			</table>
        </div>
        <div id="tab-categories">
          <?php echo $category_tab; ?>
        </div>
        <div id="tab-appearance">
          <?php echo $appearance_tab; ?>
        </div>
        
      </form>
    </div>
  </div>
</div>

<script type="text/javascript"><!--
$('#tabs a').tabs(); 
//--></script> 
<?php echo $footer; ?>