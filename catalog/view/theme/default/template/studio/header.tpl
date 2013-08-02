<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="<?php echo $direction; ?>" lang="<?php echo $lang; ?>" xml:lang="<?php echo $lang; ?>">
<head>
<title><?php echo $title; ?></title>
<!--<base href="<?php echo $base; ?>" />-->
<meta name="google" value="notranslate" />  
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<?php if ($description) { ?>
<meta name="description" content="<?php echo $description; ?>" />
<?php } ?>
<?php if ($keywords) { ?>
<meta name="keywords" content="<?php echo $keywords; ?>" />
<?php } ?>
<?php if ($icon) { ?>
<link href="<?php echo $icon; ?>" rel="icon" />
<?php } ?>
<?php foreach ($links as $link) { ?>
<link href="<?php echo $link['href']; ?>" rel="<?php echo $link['rel']; ?>" />
<?php } ?>

<script type="text/javascript" src="catalog/view/javascript/jquery/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/minified/jquery.ui.core.min.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/minified/jquery.ui.widget.min.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/minified/jquery.ui.position.min.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/minified/jquery.ui.mouse.min.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/minified/jquery.ui.draggable.min.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/minified/jquery.ui.resizable.min.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/minified/jquery.ui.button.min.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/minified/jquery.ui.dialog.min.js"></script>
<script type="text/javascript" src="catalog/view/javascript/swfobject/swfobject.js"></script>
<script type="text/javascript" src="catalog/view/javascript/uploadify/jquery.uploadify.v2.1.4.min.js"></script>
<script type="text/javascript"><!--
function loadAjaxHtml(url, container, data, method)	{
	if( data === undefined ) {
		data = null;
	}
	
	if( method === undefined ) {
		method = "GET";
	}
	
	$.ajax({
		type: method,
		url: url,
		data: data,
		success: function(response) {
			$(container).html(response);
		}
	});	
}
//--></script> 
<script type="text/javascript"><!--
$(document).ready(function(){
	$('.button').button();
});
//--></script>

<?php foreach ($scripts as $script) { ?>
<script type="text/javascript" src="<?php echo $script; ?>"></script>
<?php } ?>

<link rel="stylesheet" type="text/css" href="catalog/view/theme/default/stylesheet/<?php echo $theme; ?>/jquery.ui.all.css" />
<link rel="stylesheet" type="text/css" href="catalog/view/theme/default/stylesheet/style.css" />
<link rel="stylesheet" type="text/css" href="catalog/view/javascript/uploadify/uploadify.css" />
<?php foreach ($styles as $style) { ?>
<link rel="<?php echo $style['rel']; ?>" type="text/css" href="<?php echo $style['href']; ?>" media="<?php echo $style['media']; ?>" />
<?php } ?>

<?php echo $google_analytics; ?>
</head>
<body class="ui-widget-content">
<div id="logo" style="position:absolute; bottom:10px; right:10px; z-index: -1;">
<?php if ($logo) { ?>
	<img  border="0" src="<?php echo $logo; ?>" title="<?php echo $name; ?>" alt="<?php echo $name; ?>" />
<?php } ?>
</div>
<div id="header" class="ui-widget-header ui-state-default" style="margin:0px; padding:5px; overflow:auto; border-width: 0 0 1px 0; font-weight: normal;">
	
	
	<!-- <div id="welcome">
	<?php if (!$logged) { ?>
	<?php echo $text_welcome; ?>
	<?php } else { ?>
	<?php echo $text_logged; ?>
	<?php } ?>
	</div> -->
	
	<?php echo $account_bar; ?>
	<?php /*if (count($languages) > 1) { ?>
	  <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" style="position:absolute; left:400px; top:15px; ">
	    <div id="language"><!--<?php echo $text_language; ?><br />-->
	      <?php foreach ($languages as $language) { ?>
	      &nbsp;<img style="cursor:pointer;" src="image/flags/<?php echo $language['image']; ?>" alt="<?php echo $language['name']; ?>" title="<?php echo $language['name']; ?>" onclick="$('input[name=\'language_code\']').attr('value', '<?php echo $language['code']; ?>').submit(); $(this).parent().parent().submit();" />
	      <?php } ?>
	      <input type="hidden" name="language_code" value="" />
	      <input type="hidden" name="redirect" value="<?php echo $redirect; ?>" />
	    </div>
	  </form>
	<?php }*/ ?>
	
	<div id="menu" align="left">
	<?php foreach ($menu as $menu_item) : ?>
	      <?php echo $menu_item['separator']; ?><a href="<?php echo $menu_item['link']; ?>"><?php echo $menu_item['text']; ?></a>
	<?php endforeach; ?>
	</div>
</div>
<!-- <div id="notification" style="margin:10px;"></div> -->
<div id="popup"></div>
