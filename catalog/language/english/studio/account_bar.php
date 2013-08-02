<?php
// Text
$_['text_welcome']  = 'Welcome visitor you can <a href="#" onclick="loadPopUp(\'%s\');">login</a> or <a href="#" onclick="loadPopUp(\'%s\');">create an account</a>.';
$_['text_logged']   = 'Welcome <a href="%s">%s</a> <b>(</b> <a href="#" onclick="loadPopUp(\'%s\');">Logout</a> <b>)</b>';

//ajax call are not available from no secure domain (http) to secure domain (https)
$_['text_welcome_ssl']  = 'Welcome visitor you can <a href="%s" target="_blank">login</a> or <a href="%s" target="_blank">create an account</a>.';
$_['text_logged_ssl']   = 'Welcome <a href="%s">%s</a> <b>(</b> <a href="%s" target="_blank">Logout</a> <b>)</b>';

?>