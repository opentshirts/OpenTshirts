<application>
	<studioId><?php echo $studio_data['studio_id']; ?></studioId>
	<gateway><?php echo $gateway; ?></gateway>
	<designColors api_link='index.php?route=xml/design_color'></designColors>
	<products api_link='index.php?route=xml/product&amp;id_product='></products>
	<productColors api_link='index.php?route=xml/product_color'></productColors>
	<cliparts api_link='index.php?route=xml/clipart&amp;id_clipart='></cliparts>
	<settings api_link='index.php?route=xml/setting'></settings>
	<language api_link='index.php?route=xml/language'></language>
	<fonts api_link='index.php?route=xml/font'></fonts>
</application>