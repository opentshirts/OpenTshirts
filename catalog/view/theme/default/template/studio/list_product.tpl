<?php
if (!function_exists('showOptionRecursive')) {
	/**
	* print html options tags from a recursive array with id, description and children array properties
	*/
	function showOptionRecursive($array, $selected, $level) {
		foreach($array as $option) {
			?>
			<option value="<?php echo $option['id_category'];?>" <?php if($option['id_category']==$selected) { echo 'selected="selected"'; } ?> >
				<?php for($i=0; $i<$level; $i++) { echo "&nbsp;---&nbsp;"; } ?>
				<?php echo $option['description']; ?>
			</option>
			<?php
			
			showOptionRecursive($option['children'], $selected, $level + 1);
		}
	}
}
?>
<style type="text/css">
#product_div_list 
{ 
	list-style-type: none; 
	margin: 10px; 
	padding:5px; 
	border-width:3px; 
	overflow:auto; 
	height:438px; 
}
#product_div_list li 
{ 
	margin: 7px; 
	padding: 1px; 
	text-align: center;
}
#product_div_list li .title 
{ 
	font-size:1.3em; 
	font-weight:bold;
}
</style>

<div id="product_list_dialog"  style="display:none">
	<form id="product_list_form" method="post" enctype="application/x-www-form-urlencoded">
	    <table width="100%">
	      <tr>
		<td nowrap width="50%" align="left">
		<?php if ($categories) { ?>
			<label><?php echo $product_text_categories; ?></label>
			<select style="width:200px;" class="ui-corner-all ui-widget-content" name="product_category" id="product_category" >
				<option value="">All</option>
				<?php showOptionRecursive($categories, $product_category, 0); ?>
			</select>
		<?php } ?>
		</td>
		<td width="50%" align="right"><label><?php echo $product_text_search; ?></label> <input type="text" name="product_keyword" id="product_keyword" style="width:300px;" value="<?php echo $product_keyword; ?>" class="ui-corner-all ui-widget-content" >
		</td>
	      </tr>
	    </table>
	</form>
	<ul id="product_div_list" class="ui-widget-content"></ul>
</div>
<script language="javascript" type="text/javascript">
$(function() {
	$( "#product_list_dialog" ).dialog({
		autoOpen: false,
		height: 560,
		width: 904,
		title: '<?php echo $product_text_title; ?>',
		modal: true
	});
	
	$("#product_keyword").keypress(function(event) {
		if ( event.which == 13 ) {
			event.preventDefault();//prevent send form
			$("#product_category").val("");
			productLoadList(1);
		}
	});
	
	$("#product_category").change(function() {
		$("#product_keyword").val("");
		productLoadList(1);
	});
	
});

function setProduct(id) {
	studioSetProduct(id);
	$( "#product_list_dialog" ).dialog("close");
}

function showProductList() {
	$( "#product_list_dialog" ).dialog("open");
	
	if($("#product_div_list").children().length==0) {//if is not load yet
		productLoadList(1);
	}
}

function productLoadList(page, linkToRemove)
{
	if ( linkToRemove !== undefined ) {
		$(linkToRemove).html('<img style="margin:8px;" src="<?php echo $loading_image; ?>" />');
	}
	if(page===1) {
		$("#product_div_list").html('<img style="margin:8px;" src="<?php echo $loading_image; ?>" />');
	}

	$.ajax({
		type: "POST",
		url:  "index.php?route=studio/list_product/getMore",
		data: {
			product_page:page,
			product_category:$("#product_category").val(),
			product_keyword:$("#product_keyword").val()
		},
		success: function(msg){
			if(page===1) {
				$("#product_div_list").html(msg);
			} else {
				$("#product_div_list").append(msg);
			}
			if ( linkToRemove !== undefined ) {
				$(linkToRemove).remove();
			}			
		}
	});	
}
</script>
