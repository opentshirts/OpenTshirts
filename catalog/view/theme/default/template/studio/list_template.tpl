<style type="text/css">
#template_div_list 
{ 
	list-style-type: none; 
	margin: 10px; 
	padding:5px; 
	border-width:3px; 
	overflow:auto; 
	height:438px; 
}
#template_div_list li 
{ 
	margin: 7px; 
	padding: 1px; 
	float: left; 
	width: 147px; 
	height:150px; 
	text-align: center;  
	background:#FFF; 
	cursor:pointer; 
}
#template_div_list li .title 
{ 
	font-size:1.3em; 
	font-weight:bold;
}
</style>

<div id="template_list_dialog"  style="display:none">
	<form id="template_list_form" method="post" enctype="application/x-www-form-urlencoded">
	    <table width="100%">
	      <tr>
		<td nowrap width="50%" align="left">
		<?php if ($categories) { ?>
			<label><?php echo $template_text_categories; ?></label>
			<select style="width:200px;" class="ui-corner-all ui-widget-content" name="template_category" id="template_category" >
				<option value="">All</option>
				<?php showOptionRecursive($categories, $template_category, 0); ?>
			</select>
		<?php } ?>
		</td>
		<td width="50%" align="right"><label><?php echo $template_text_search; ?></label> <input type="text" name="template_keyword" id="template_keyword" style="width:300px;" value="<?php echo $template_keyword; ?>" class="ui-corner-all ui-widget-content" >
		</td>
	      </tr>
	    </table>
	</form>
	<ul id="template_div_list" class="ui-widget-content"></ul>
</div>
<script language="javascript" type="text/javascript">
$(function() {
	$( "#template_list_dialog" ).dialog({
		autoOpen: false,
		height: 560,
		width: 915,
		title: '<?php echo $template_text_title; ?>',
		modal: true
	});
	
	$("#template_keyword").keypress(function(event) {
		if ( event.which == 13 ) {
			event.preventDefault();//prevent send form
			$("#template_category").val("");
			templateLoadList(1);
		}
	});
	
	$("#template_category").change(function() {
		$("#template_keyword").val("");
		templateLoadList(1);
	});
	
});

function addTemplate(id) {
	studioAddTemplate(id);
	$( "#template_list_dialog" ).dialog("close");
}
function showTemplateList() {
	$( "#template_list_dialog" ).dialog("open");
	
	if($("#template_div_list").children().length==0) {//if is not load yet
		templateLoadList(1);
	}
}

function templateLoadList(page, linkToRemove)
{
	if ( linkToRemove !== undefined ) {
		$(linkToRemove).html('<img style="margin:8px;" src="<?php echo $loading_image; ?>" />');
	}

	$.ajax({
		type: "POST",
		url:  "index.php?route=studio/list_template/getMore",
		data: {
			template_page:page,
			template_category:$("#template_category").val(),
			template_keyword:$("#template_keyword").val()
		},
		success: function(msg){
			if(page===1) {
				$("#template_div_list").html(msg);
			} else {
				$("#template_div_list").append(msg);
			}
			if ( linkToRemove !== undefined ) {
				$(linkToRemove).remove();
			}			
		}
	});	
}
</script>
