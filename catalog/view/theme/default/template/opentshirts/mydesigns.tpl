<?php echo $header; ?><?php echo $column_left; ?><?php echo $column_right; ?>
<div id="content"><?php echo $content_top; ?>
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <h1><?php echo $heading_title; ?></h1>
	<div align="center" style="margin:10px;">
		<select class="ui-widget-content ui-corner-all" onchange="filter_design_change(this.value)">
		<option value=""><?php echo $text_all; ?></option>
		<option value="saved_designs"><?php echo $text_templates; ?></option>
		<option value="ordered_designs"><?php echo $text_ordered; ?></option>
		</select>
	</div>
    <div class="content">
	  <div id="saved_designs">
		  <h2><?php echo $text_templates; ?></h2>
		  <ul style="list-style:none; overflow:auto;">
			<?php if ($templates) { ?>
				<?php foreach ($templates  as $template) { ?>
				<li class="ui-widget-content" style="float:left; padding:5px; margin:5px; ">
				<div align="center"><strong><?php echo $template['name']; ?></strong></div>
				<table><tr>
					<?php foreach ($template['images'] as $images) { ?>
						<td>
						<img src="<?php echo $images['large']; ?>" border="0" title="<?php echo $template['name']; ?>" alt="<?php echo $template['name']; ?>" /><br />
						</td>
					<?php } ?>
				</tr></table>
				<?php if ($template['link_edit']) { ?>
				<a style="margin:5px;" class="button" href="<?php echo $template['link_edit']; ?>"><?php echo $text_edit_design; ?></a><br />
				<?php } ?>
				<a style="margin:5px;" class="button" href="<?php echo $template['link_import']; ?>"><?php echo $text_new_design; ?></a><br />
				<?php if ($template['link_remove']) { ?>
				<a style="margin:5px;" class="button remove ui-state-error" href="<?php echo $template['link_remove']; ?>"><?php echo $text_remove; ?></a><br />
				<?php } ?>
				</li>
				<?php } ?>
			<?php } else { ?>
			<li><?php echo $text_empty_templates; ?></li>
			<?php } ?>
		  </ul>
	  </div>
	  <div id="ordered_designs">
		  <h2><?php echo $text_ordered; ?></h2>
		  <ul style="list-style:none; overflow:auto;">
			<?php if ($ordered) { ?>
				<?php foreach ($ordered  as $template) { ?>
				<li class="ui-widget-content" style="float:left; padding:5px; margin:5px; ">
				<div align="center"><strong><?php echo $template['name']; ?></strong></div>
				<table><tr>
					<?php foreach ($template['images'] as $images) { ?>
						<td>
						<img src="<?php echo $images['large']; ?>" border="0" title="<?php echo $template['name']; ?>" alt="<?php echo $template['name']; ?>" /><br />
						</td>
					<?php } ?>
				</tr></table>
				<a style="margin:5px;" class="button" href="<?php echo $template['link_import']; ?>"><?php echo $text_new_design; ?></a><br />
				</li>
				<?php } ?>
			<?php } else { ?>
			<li><?php echo $text_empty_ordered; ?></li>
			<?php } ?>
		  </ul>
	  </div>

	  <div id="promp_remove" style="display:none;" title="<?php echo $text_remove; ?>">
		  <input id="promp_remove_redirect" type="hidden" value="" />
		  <span><?php echo $text_promp_delete; ?></span><br /><br />
		  <div align="right"><a class="button" onclick="location.href=$('#promp_remove_redirect').val()"><?php echo $button_remove; ?></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class="button" onclick="$('#promp_remove').dialog('close')"><?php echo $button_cancel; ?></a></div>
	  </div>
    </div>
    <div class="buttons">
      <div class="right"><a href="<?php echo $continue; ?>" class="button"><?php echo $button_continue; ?></a></div>
    </div>
  <?php echo $content_bottom; ?></div>
  <script type="text/javascript"><!--
$(document).ready(function(){
	$('#promp_remove').dialog({
		autoOpen: false,
		height: "auto",
		width: "auto",
		minHeight: 50,
		minWidth: 200,
		modal: true,
		close: function(event, ui) {
			$("#promp_remove_redirect").val('');
		}
	});
	
   $('a.remove').click(function(){
        if ($(this).attr('href') != null ) {
			$('#promp_remove_redirect').val($(this).attr('href'));
			$('#promp_remove').dialog('open');
			return false;
        }
    });


});
function filter_design_change(value) {
	if(value=="") {
		$('#saved_designs').show();
		$('#ordered_designs').show();
	} else if(value=="saved_designs") {
		$('#saved_designs').show();
		$('#ordered_designs').hide();
	} else if(value=="ordered_designs") {
		$('#saved_designs').hide();
		$('#ordered_designs').show();
	}
}
//--></script>
<?php echo $footer; ?>