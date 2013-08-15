<?php 
class ControllerXmlXml extends Controller { 

	public function index() {

		if (isset($_SERVER['HTTPS']) && (($_SERVER['HTTPS'] == 'on') || ($_SERVER['HTTPS'] == '1'))) {
			$store_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store WHERE REPLACE(`ssl`, 'www.', '') = '" . $this->db->escape('https://' . str_replace('www.', '', $_SERVER['HTTP_HOST']) . rtrim(dirname($_SERVER['PHP_SELF']), '/.\\') . '/') . "'");
			if ($store_query->num_rows) {
				$server = $store_query->row['ssl'];
			} else {
				$server = HTTPS_SERVER;
			}

		} else {
			$store_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "store WHERE REPLACE(`url`, 'www.', '') = '" . $this->db->escape('http://' . str_replace('www.', '', $_SERVER['HTTP_HOST']) . rtrim(dirname($_SERVER['PHP_SELF']), '/.\\') . '/') . "'");
			if ($store_query->num_rows) {
				$server = $store_query->row['url'];
			} else {
				$server = HTTP_SERVER;
			}
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