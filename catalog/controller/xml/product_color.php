<?php 
class ControllerXmlProductColor extends Controller { 
	public function index() {
		
		$this->load->language('xml/xml');
		
		$this->load->model('opentshirts/product_color');
		$this->data['colors'] = $this->model_opentshirts_product_color->getColors();
	
		if(empty($this->data['colors'])) {
			$error_warning = $this->language->get('no_product_colors');
		}
		
		if(isset($error_warning)) {
			$this->data['error_warning'] = $error_warning;
		} else {
			$this->data['error_warning'] = '';
		}
	
		$this->template = 'default/template/xml/product_color.tpl';
		
		$this->response->addHeader("Content-type: text/xml");
		$this->response->setOutput($this->render());
  	}
}
?>