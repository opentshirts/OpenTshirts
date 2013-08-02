<?php  
class ControllerStudioProductColors extends Controller {
	private $error = array();

	public function index() {
	
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/product_colors_cont.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/product_colors_cont.tpl';
		} else {
			$this->template = 'default/template/studio/product_colors_cont.tpl';
		}

		$this->children = array(
			'studio/product_colors/color_list'
		);

		$this->response->setOutput($this->render());
	}

	public function color_list() {

		$this->language->load('studio/product_colors');

		$this->data['product_colors'] = array();

		$this->data['text_product_colors'] = $this->language->get('text_product_colors');

		if($this->validateProductID()) {

			$this->load->model('opentshirts/product_color');
			$this->data['all_colors'] = $this->model_opentshirts_product_color->getColors();

			$this->load->model('opentshirts/product');
			//get distinct products colors availables for this product
			$this->data['product_colors'] = $this->model_opentshirts_product->getColors($this->request->post['product_id']);

		}
	
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/product_colors.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/product_colors.tpl';
		} else {
			$this->template = 'default/template/studio/product_colors.tpl';
		}

		$this->response->setOutput($this->render());
	}

	private function validateProductID() {
		//if price_studio_id is empty
		if (empty($this->request->post['product_id'])) {
			return false;
		}
		return true;
	}


}
?>