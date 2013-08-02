<script language="javascript" type="text/javascript">
$(function() {		
	$(document).bind("onApplicationReady", function(event) {
		$( "#mod_customer" ).show();
		reloadAccountBar();
	});
	
	$(document).bind("onLoginStateChange", function(event) {
		reloadAccountBar();
	});

});
function reloadAccountBar()
{
	loadAjaxHtml("index.php?route=studio/account_bar/refresh", "#mod_customer")
}
</script>
<div id="mod_customer" style="display:none; float: right;"></div>