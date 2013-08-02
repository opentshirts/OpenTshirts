<?php
ini_set('memory_limit', '47M');

if (isset($GLOBALS["HTTP_RAW_POST_DATA"]))
{
	// get bytearray
	$png = $GLOBALS["HTTP_RAW_POST_DATA"];
	// add headers for download dialog-box
	header('Content-Type: image/png');
	header("Content-Disposition: attachment; filename=".$_GET['name']);
	echo $png;
}
?>