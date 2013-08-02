<?php if ($templates) { ?>
	<?php foreach ($templates as $template) { ?>
	<li class="ui-widget-content ui-corner-all" title="<?php echo $template['name']; ?>" onclick="addTemplate('<?php echo $template['id_template']; ?>');" >
		<table height="100%" width="100%" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td align="center" valign="middle" ><img src="<?php echo $template['image']; ?>" border="0"></td>
			</tr>
		</table>
	</li>
	<?php } ?>
	<?php if($show_more) { ?>
	<div class="ui-widget-content ui-corner-all" style="clear:both; text-align:center;">
	    <div onclick="templateLoadList(<?php echo ($template_page+1); ?>, $(this).parent())" style="cursor:pointer; padding:8px;">
		<span><?php echo $template_text_show_more; ?></span>
	    </div>
	</div>
	<?php } ?>
<?php } else { ?>
	<div><?php echo $template_text_empty; ?></div>
<?php } ?>