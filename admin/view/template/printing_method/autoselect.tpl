<?php echo $header; ?>
<style type="text/css">
#matrix_list {
	list-style:none;
	margin:0;
	padding: 10px 0 0 0;
	border: 0;
}
#matrix_list li {
	float:left;
	cursor:move;
	padding: 10px;
}
#matrix_list li div {
	line-height:35px;
	text-align: left; 
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
      <h1><img src="view/image/setting.png" alt="" /> <?php echo $heading_title; ?></h1>
      <div class="buttons"><a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a><a onclick="location = '<?php echo $cancel; ?>';" class="button"><?php echo $button_cancel; ?></a></div>
    </div>
    <div class="content">
      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
        <div id="tab-general" class="page">
          <table class="form">
            <tr>
              <td>
                <div class="box">
                	<div>	
                		<span style="float:left;">
                			<input type="checkbox" name="enable_autoselect" <?php if($enable_autoselect) { ?> checked <?php } ?> /><?php echo $text_enable_autoselect; ?> <br />
                			<div class="ui-widget-content ui-state-highlight" style="padding: 10px; margin: 10px 0px;">
                				<?php echo $text_autoselect_help; ?>
                			</div>
                		</span>  
                		<span style="float:right;">
                			<a onclick="addColumn()"><img src="view/image/add.png" /><?php echo $text_add_quantity; ?></a> <!-- | 
                			<?php echo $text_increment; ?> <input type="text" id="quantity_increment" class="ui-widget-content ui-corner-all" value="12" style="width:25px;"  /><br /> -->
                		</span>         
                	                            
                        <div style="padding-top: 10px;">

                        	<?php echo $text_popup_title; ?> <input class="ui-widget-content ui-corner-all" type="text" name="title_text" value="<?php echo $title_text; ?>"  style="width:400px;  font-size: 20px;">
                        	<?php if ($error_quantities) { ?>
                        	<div class="warning"><?php echo $error_quantities; ?></div>
                        	<?php } ?>
                			<ul id="matrix_list">
                			<?php if($quantities) { ?>
                				<?php foreach($quantities as $quantity_index=>$quantity) { ?>
                				<li class="ui-widget-content">
                					<div style="position:relative; padding: 5px 20px 5px 5px; display: none;" class="ui-widget-header"><?php echo $text_quantity_break; ?> <input type="number" style="width:100px; font-size: 20px;" class="ui-widget-content ui-corner-all" name="quantities[]" value="<?php echo $quantity; ?>" title="quantity" /><a style="position:absolute; right:0; top:0; cursor:pointer;" class="ui-icon ui-icon-close" onclick="removeClick($(this).parents('li'));"></a></div>
                					<div style="position:relative; padding: 5px 20px 5px 5px;" class="ui-widget-header"><?php echo $text_description; ?> <input  class="ui-widget-content ui-corner-all" type="text" name="descriptions[]" value="<?php echo $descriptions[$quantity_index]; ?>"  style="width:200px; font-size: 20px;"><a style="position:absolute; right:0; top:0; cursor:pointer;" class="ui-icon ui-icon-close" onclick="removeClick($(this).parents('li'));"></a></div>
                					<div><?php echo $text_available_printing_methods; ?></div>
                					<?php foreach($printing_methods as $printing_method) { ?>
                						<div style="white-space:nowrap;" >
                							<span><input type="checkbox" onchange="$(this).next('input').val($(this).attr('checked'))" <?php if($pm[$printing_method['extension']][$quantity_index]) { ?> checked <?php } ?> /><?php echo $printing_method['name']; ?>
                								<input type="hidden" name="pm[<?php echo $printing_method['extension']; ?>][]" <?php if($pm[$printing_method['extension']][$quantity_index]) { ?> value="checked" <?php } ?>  >
                							</span>
                						</div>
                					<?php } ?>
                				</li>
                				<?php } ?>
                			<?php } ?>
                			</ul>            
                        </div>

                	</div>
                </div>
              </td>
            </tr>
          </table>
        </div>
      </form>
    </div>
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
	/*var last_value = parseInt(li.find('input[name=\'quantities[]\']').val());
	if (!isNaN(last_value)) {
		li.find('input[name=\'quantities[]\']').val(last_value+parseInt($("#quantity_increment").val()));
	}*/
}

function validFloat(number)
{
    return (/^([0-9])*[.]?[0-9]*$/.test(number));
}

$(document).ready(function() {	
    $( "#matrix_list" ).sortable();
});
//--></script> 
<?php echo $footer; ?> 