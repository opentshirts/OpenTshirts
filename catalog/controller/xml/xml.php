<?php 
class ControllerXmlXml extends Controller { 

	public function index() {

		if (isset($this->request->server['HTTPS']) && (($this->request->server['HTTPS'] == 'on') || ($this->request->server['HTTPS'] == '1'))) {
			$server = HTTPS_SERVER;
		} else {
			$server = HTTP_SERVER;
		}

		if (!isset($this->session->data['studio_data'])) {
      		$this->session->data['studio_data'] = array();
    	}

    	//create unique ID to identify studio instance
    	$studio_id = mt_rand();
		$this->session->data['studio_data'][$studio_id] = array(
  			'studio_id' => $studio_id,
  			'date' => date("Y-m-d H:i:s")
  		);

  		$this->data['studio_data'] = $this->session->data['studio_data'][$studio_id];

		$this->data['gateway'] = $server . 'amfphp/php/';

		$this->template = 'default/template/xml/index.tpl';
		
		$this->response->addHeader("Content-type: text/xml");
		$this->response->setOutput($this->render());
  	}
}
?>