<style type="text/css">
#matrix_list {
	list-style:none;
	margin:0;
	padding: 0;
	border: 0;
}
#matrix_list li {
	float:left;
	width:100px;
	cursor:move;
}
#matrix_list li div {
	line-height:35px;
}
div.row {
	line-height:35px; 
	text-align: right; 
	padding-right: 5px;
	height: 35px;
}
</style>
<?php if ($error_quantities) { ?>
<div class="warning"><?php echo $error_quantities; ?></div>
<?php } ?>
<?php if ($error_price) { ?>
<div class="warning"><?php echo $error_price; ?></div>
<?php } ?>
<?php if ($error_areas) { ?>
<div class="warning"><?php echo $error_areas; ?></div>
<?php } ?>
<div class="box">
	<div align="center">	
		<span style="float:right;">
			<a onclick="addColumn()"><img src="view/image/add.png" /><?php echo $text_add_quantity; ?></a> | 
			<?php echo $text_increment; ?> <input type="text" id="quantity_increment" class="ui-widget-content ui-corner-all" value="12" style="width:25px;"  /><br />
			<?php //echo $text_decrement; ?><!-- <input type="text" id="price_decrement" value="2.5"  /><br /> -->
		</span>
        <span style="float:left;">
            <?php echo $text_areas; ?> <input type="text" id="area_size" size="10" class="ui-widget-content ui-corner-all" /> <?php echo $length_unit; ?><sup>2</sup> <a onclick="addRow($('#area_size').val())"><img src="view/image/add.png" /><?php echo $text_add_area; ?></a> <span style="font-size: .8em"><?php echo $text_sort; ?></span>
        </span>            
	                            
        <div style="clear: both; padding-top: 10px;">               
			<div id="first_col" style=" width:200px; float:left">
				<div class="ui-widget-header" style="margin: 1px 0px 3px 0px; line-height:35px; text-align: right; padding-right: 5px; height: 35px;"><?php echo $text_minimum_quantity; ?> </div>
				<?php foreach($areas as $area) { ?>
	                        <div class="row"><?php if($area>0) { ?><a onclick="removeRow($(this).parent())"><img src="view/image/delete.png" /></a><?php } ?> <?php echo $text_areas; ?> <span><?php echo $area; ?></span> <?php echo $length_unit; ?><sup>2</sup></div>
				<?php } ?>
			</div>
			<ul id="matrix_list">
			<?php if($quantities) { ?>
				<?php foreach($quantities as $index=>$quantity) { ?>
				<li class="ui-widget-content">
					<div style="position:relative;" class="ui-widget-header"><input type="text" style="width:65px;" class="ui-widget-content ui-corner-all" name="quantities[]" value="<?php echo $quantity; ?>" title="quantity" /><a style="position:absolute; right:0; top:0; cursor:pointer;" class="ui-icon ui-icon-close" onclick="removeClick($(this).parents('li'));"></a></div>
					<?php foreach($price as $area=>$array_quantity) { ?>
						<div style="white-space:nowrap; text-align: center" class="price row">
							<span><?php echo $symbol_left; ?> <input type="text" style="width:45px; text-align: right" class="ui-widget-content ui-corner-all" data="price" name="price[<?php echo $area; ?>][]" value="<?php echo $price[$area][$index]; ?>" /> <?php echo $symbol_right; ?></span>
						</div>
					<?php } ?>
				</li>
				<?php } ?>
			<?php } ?>
			</ul>            
        </div>

	</div>
</div>
<div id="dialog_error_row" style="display:none"  class="ui-widget ui-state-error">
<div class="warning"><?php echo $text_error_row; ?></div>
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
}

function addRow(area) {
    if(area=="" || !validFloat(area)) {
        $( "#dialog_error_row" ).dialog('open');
        return;
    }
    $("#matrix_list > li").each(function(index) {	
		var new_div = $(this).children('div.price:last').clone();
		new_div.appendTo(this);
		new_div.find('input[data=price]').attr('name','price['+ area +'][]');
	});

    var row_html  = '<div class="row">';
    	row_html += '<a onclick="removeRow($(this).parent())"><img src="view/image/delete.png" /></a> ';
    	row_html += '<?php echo $text_areas; ?> <span></span> <?php echo $length_unit; ?><sup>2</sup>';
    	row_html += '</div>';

	var new_div = $(row_html);
        new_div.appendTo($("#first_col"));
        new_div.find('span').html(area);	
}

function removeRow(mydiv) {
        var index_remove = false;
        $("#first_col > div.row").each(function(index) {
                if($(this).get(0)===mydiv.get(0)) {
                    index_remove = index;
                }
		});
        
        if(index_remove!==false) {
            $("#matrix_list > li").each(function(index) {	
                    $(this).children('div.price:eq(' + index_remove + ')').slideUp(300, function() {$(this).remove();});
            });
            
            $("#first_col > div.row:eq(" + index_remove + ")").slideUp(300, function() {$(this).remove();});
        }
}
function validFloat(number)
{
    return (/^([0-9])*[.]?[0-9]*$/.test(number));
}

$(document).ready(function() {	
    $( "#matrix_list" ).sortable();
    $( "#dialog_error_row" ).dialog({
			height: "auto",
			width: "auto",
			autoOpen: false,
			modal: true,
			minHeight: 30,
			minWidth: 30
		});

});
//--></script> 