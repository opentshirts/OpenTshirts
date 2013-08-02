<style>
#delivery_date_mod {
	display:block; 
	line-height:55px; 
	background: url('image/data/delivery_date/03.png') repeat-x 0 0 scroll;
	font-family: Arial;
	font-size: 14pt;
	margin: 5px 0px;

}
#delivery_date_mod div{
	display:inline-block; 
	margin: 0;
	
}
#delivery_date_mod_dates a{
	font-family: Arial;
	font-size: 14pt;
	text-decoration: none;
	color: black;
}
#delivery_date_mod_dates a b {
	font-family: Arial;
	font-size: 14pt;
	text-decoration: none;
	color: black;
}
#delivery_date_mod_dates a:visited {
	text-decoration: none;
	color: black;
}

#delivery_date_mod_bg {
	position: absolute;
	left: 0px;
	right: 0px;
	width: 100%;
	min-width: 980px;
	z-index: -1;
	overflow: hidden;
	height: 55px;
}
#delivery_date_mod_bg_left {
	position: absolute;
	left: 0px;
	width: 50%;
	overflow: hidden;
	height: 55px;
	background: url('image/data/delivery_date/01.png') repeat-x scroll 0 0 transparent;
}
#delivery_date_mod_bg_right {
	position: absolute;
	right: 0px;
	width: 50%;
	overflow: hidden;
	height: 55px;
	background: url('image/data/delivery_date/03.png') repeat-x scroll 0 0 transparent;
}
</style>

<div id="delivery_date_mod_bg">
	<div id="delivery_date_mod_bg_left"></div>
	<div id="delivery_date_mod_bg_right"></div>
</div>

<div id="delivery_date_mod">
	<div id="order_today"  style="padding: 0px 5px; font-weight: bold; color: white; background: url('image/data/delivery_date/01.png') repeat-x 0 0 scroll;"><?php echo $text_order_today; ?></div><div 
	id="order_today_arrow"  style=" background: url('image/data/delivery_date/02.png') no-repeat 0 0; width:49px;">&nbsp;</div>
	<div id="delivery_date_mod_dates">
		<div id="rush_date"><a href="<?php echo $shipping_link; ?>"><img src="image/data/delivery_date/rush_icon.png" style="vertical-align:middle; margin: 0px 5px;" /><?php echo $text_rush_shipping; ?> <?php echo $rush_month; ?> <?php echo $rush_day; ?></a></div>
		<div id="free_date"><a href="<?php echo $shipping_link; ?>"><img src="image/data/delivery_date/free_icon.png" style="vertical-align:middle; margin: 0px -10px 0px 50px;" /><?php echo $text_free_shipping; ?> <?php echo $free_month; ?> <?php echo $free_day; ?></a></div>
	</div>
</div>
