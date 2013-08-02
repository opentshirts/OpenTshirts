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
#clipart_div_list 
{ 
	list-style-type: none; 
	margin: 10px; 
	padding:5px; 
	border-width:3px; 
	overflow:auto; 
	height:438px; 
}
#clipart_div_list li 
{ 
	margin: 7px; 
	padding: 1px; 
	float: left; 
	width: 100px; 
	height:100px; 
	text-align: center;  
	background:#FFF; 
	cursor:pointer; 
}
#clipart_div_list li .title 
{ 
	font-size:1.3em; 
	font-weight:bold;
}
</style>

<div id="clipart_list_dialog"  style="display:none">
	<form id="clipart_list_form" method="post" enctype="application/x-www-form-urlencoded">
	    <table width="100%">
	      <tr>
		<td nowrap width="50%" align="left">
		<?php if ($categories) { ?>
			<label><?php echo $clipart_text_categories; ?></label>
			<select style="width:200px;" class="ui-corner-all ui-widget-content" name="clipart_category" id="clipart_category" >
				<option value="">All</option>
				<?php showOptionRecursive($categories, $clipart_category, 0); ?>
			</select>
		<?php } ?>
		</td>
		<td width="50%" align="right"><label><?php echo $clipart_text_search; ?></label> <input type="text" name="clipart_keyword" id="clipart_keyword" style="width:300px;" value="<?php echo $clipart_keyword; ?>" class="ui-corner-all ui-widget-content" >
		</td>
	      </tr>
	    </table>
	</form>
	<ul id="clipart_div_list" class="ui-widget-content"></ul>
</div>
<script language="javascript" type="text/javascript">
$(function() {
	$( "#clipart_list_dialog" ).dialog({
		autoOpen: false,
		height: 560,
		width: 915,
		title: '<?php echo $clipart_text_title; ?>',
		modal: true
	});
	
	$("#clipart_keyword").keypress(function(event) {
		if ( event.which == 13 ) {
			event.preventDefault();//prevent send form
			$("#clipart_category").val("");
			clipartLoadList(1);
		}
	});
	
	$("#clipart_category").change(function() {
		$("#clipart_keyword").val("");
		clipartLoadList(1);
	});
	
});

function addBitmap(id, source, used_colors) {
	studioAddBitmap(id, source, used_colors);
	$( "#clipart_list_dialog" ).dialog("close");
}
function addClipart(id) {
	studioAddClipart(id);
	$( "#clipart_list_dialog" ).dialog("close");
}
function showClipartList() {
	$( "#clipart_list_dialog" ).dialog("open");
	
	if($("#clipart_div_list").children().length==0) {//if is not load yet
		clipartLoadList(1);
	}
}

function clipartLoadList(page, linkToRemove)
{
	if ( linkToRemove !== undefined ) {
		$(linkToRemove).html('<img style="margin:8px;" src="<?php echo $loading_image; ?>" />');
	}
	if(page===1) {
		$("#clipart_div_list").html('<img style="margin:8px;" src="<?php echo $loading_image; ?>" />');
	}

	$.ajax({
		type: "POST",
		url:  "index.php?route=studio/list_clipart/getMore",
		data: {
			clipart_page:page,
			clipart_category:$("#clipart_category").val(),
			clipart_keyword:$("#clipart_keyword").val()
		},
		success: function(msg){
			if(page===1) {
				$("#clipart_div_list").html(msg);
			} else {
				$("#clipart_div_list").append(msg);
			}
			if ( linkToRemove !== undefined ) {
				$(linkToRemove).remove();
			}			
		}
	});	
}
</script>
