<?php 
class ControllerXmlSetting extends Controller { 
	public function index() {
		
		$this->data['settings'] = array();
    	$this->data['settings'][] = array('name' => 'config_language', 'value' => $this->config->get('config_language'));
		
		$this->template = 'default/template/xml/setting.tpl';
		
		$this->response->addHeader("Content-type: text/xml");
		$this->response->setOutput($this->render());
  	}
}
?>