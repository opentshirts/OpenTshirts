<?php 
class ControllerXmlClipart extends Controller { 
	public function index() {
		
		$this->load->language('xml/xml');

		if (isset($this->request->get['id_clipart'])) {
			
			$this->load->model('opentshirts/clipart');
			
			if($clipart = $this->model_opentshirts_clipart->getClipart($this->request->get['id_clipart']))
			{
				$this->load->model('opentshirts/layer');
				
				$layers = $this->model_opentshirts_layer->getLayers(array('id_clipart' => $this->request->get['id_clipart']));

				$clipart_info = array(
					'id_clipart'	=> $clipart['id_clipart'],
					'name'      	=> $clipart['name'],
					'swf_file'  => utf8_encode(htmlspecialchars("image/data/cliparts/".$clipart['swf_file'])),
					'layers'      	=> $layers
				);
				
			} else {
				$error_warning = $this->language->get('wrong_id_clipart');
			}
		} else {
			$error_warning = $this->language->get('no_id_clipart');
		}
		
		if(isset($error_warning)) {
			$this->data['error_warning'] = $error_warning;
		} else {
			$this->data['error_warning'] = '';
		}
	
		if(isset($clipart_info)) {
			$this->data['id_clipart'] = $clipart_info['id_clipart'];
			$this->data['name'] = $clipart_info['name'];
			$this->data['swf_file'] = $clipart_info['swf_file'];
			$this->data['layers'] = $clipart_info['layers'];
		} else {
			$this->data['id_clipart'] = '';
			$this->data['name'] = '';
			$this->data['swf_file'] = '';
			$this->data['layers'] = array();
		}
	
		$this->template = 'default/template/xml/clipart.tpl';
		
		$this->response->addHeader("Content-type: text/xml");
		$this->response->setOutput($this->render());
  	}
}
?>