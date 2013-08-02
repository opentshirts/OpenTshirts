<span style="float:right;">
	<a onclick="$('li.category').children('input[type=checkbox]').attr('checked',true);"><?php echo $text_select_all; ?></a> |
	<a onclick="$('li.category').children('input[type=checkbox]').attr('checked',false);"><?php echo $text_unselect_all; ?></a> |
	<a onclick="$('#cat_autoselect').click()"><?php echo $text_autoselect_parent; ?></a><input type="checkbox" id="cat_autoselect" checked="checked" />
</span>
<ul class="categories" style="font-size:10px; text-align:left">
	<li><span><?php echo $text_root; ?></span></span>
	<?php showCategoriesRecursive($categories, $selected_categories); ?>
	</li>
</ul>
<script type="text/javascript"><!--
$(document).ready(function() {	
    $('li.category > ul').each(function(i) {
        var parent_li = $(this).parent('li');
        var sub_ul = $(this).remove();
        parent_li.children('span').wrapInner('<a/>').find('a').click(function() {
            sub_ul.slideToggle(300);
			$(this).toggleClass('collapse');
			$(this).toggleClass('expand');
        }).addClass('expand');
        parent_li.append(sub_ul);
    });
	$('li.category').each(function(i) {
		
        $(this).children('input[type=checkbox]').click(function() {
			if($('#cat_autoselect').attr('checked')) {
	            $(this).parents('li.category').children('input[type=checkbox]').attr('checked', $(this).attr('checked'));
			}
        });
    });

    // Hide all lists except the outermost.
    //$('ul.categories ul').hide();
});
//--></script> 

