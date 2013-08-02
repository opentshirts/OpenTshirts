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
      <div id="tabs" class="htabs"><?php echo $tab_data; ?></a></div>
      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
        <div id="tab-data">
          <table class="form">
          	<tr>
              <td><?php echo $entry_parent; ?></td>
              <td>
      				<select name="parent_category" class="ui-corner-all ui-widget-content form_input">
      				  <option value="" selected="selected"><?php echo $text_root; ?></option>
      				  <?php foreach ($categories as $category) { ?>
      					  <?php if ($category['id_category'] == $parent_category) { ?>
      					  <option value="<?php echo $category['id_category']; ?>" selected="selected"><?php echo $category['description']; ?></option>
      					  <?php } else { ?>
      					  <option value="<?php echo $category['id_category']; ?>"><?php echo $category['description']; ?></option>
      					  <?php } ?>
      				  <?php } ?>
      				</select>
              </td>
            </tr>
            <tr>
              <td><span class="required">*</span> <?php echo $entry_description; ?></td>
              <td><input type="text" name="description" value="<?php echo $description; ?>" />
                <?php if ($error_description) { ?>
                <span class="error"><?php echo $error_description; ?></span>
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
<?php echo $footer; ?>