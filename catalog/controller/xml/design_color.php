<?php 
class ControllerXmlDesignColor extends Controller { 
	public function index() {
		
		$this->load->language('xml/xml');

		$this->load->model('opentshirts/design_color');
		$this->data['colors'] = $this->model_opentshirts_design_color->getColors(array('filter_status'=>'1', 'sort' => 'sort', 'order' => 'ASC'));
	
		if(empty($this->data['colors'])) {
			$error_warning = $this->language->get('no_design_colors');
		}
		
		if(isset($error_warning)) {
			$this->data['error_warning'] = $error_warning;
		} else {
			$this->data['error_warning'] = '';
		}
		
		$this->template = 'default/template/xml/design_color.tpl';
		
		$this->response->addHeader("Content-type: text/xml");
		$this->response->setOutput($this->render());
  	}
}
?>