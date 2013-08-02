<?php
class ControllerProductColorSize extends Controller {
	private $error = array();

  	public function index() {

    	$this->getList();
  	}
	
  	public function color_size_tab() {
						
		$this->load->language('product/color_size');
		
		$this->data['entry_num_colors'] = $this->language->get('entry_num_colors');
		$this->data['text_no_results'] = $this->language->get('text_no_results');
		$this->data['text_default_color'] = $this->language->get('text_default_color');
		
		$this->load->model('product/color');
		$this->load->model('product/size');
		
		if (isset($this->request->get['product_id']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			$this->load->model('product/product');
			$product_info = $this->model_product_product->getProduct($this->request->get['product_id']);
			$product_info['color_size'] = $this->model_product_product->getColorsSizes($this->request->get['product_id']);
		}
		
		$this->data['sizes'] = $this->model_product_size->getSizes();
		$this->data['colors'] = $this->model_product_color->getColors();
		if (isset($this->request->get['product_id'])) {
			$this->load->model('product/product');
			$result = $this->model_product_product->getProduct($this->request->get['product_id']);
			if($result) {
				$colors_number = $result['colors_number'];
			}
		}

		if (isset($colors_number)) { 
			$this->data['colors_number_img'] = $this->model_tool_image->resize('colors/tshirt'.$colors_number.'.png', 16, 16);
		} else {
			$this->data['colors_number_img'] = false;
			
			$this->data['color_numbers_images'] = array();
			for($i=1; $i<=$this->config->get('config_max_product_color_combination'); $i++)
			{
				$this->data['color_numbers_images'][$i] = $this->model_tool_image->resize('colors/tshirt'.$i.'.png', 32, 32);
			}
		}

		if (isset($this->request->post['color_size'])) {
			$this->data['color_size'] = $this->request->post['color_size'];
		} elseif (!empty($product_info)) { 
			$this->data['color_size'] = $product_info['color_size'];
		} else {
			$this->data['color_size'] = array();
		}
		
		if (isset($this->request->post['default_color'])) {
			$this->data['default_color'] = $this->request->post['default_color'];
		} elseif (!empty($product_info['default_color'])) { 
			$this->data['default_color'] = $product_info['default_color'];
		} else {
			$this->data['default_color'] =  '';
		}
		
		if (isset($this->request->post['colors_number'])) {
			$this->data['colors_number'] = $this->request->post['colors_number'];
		} elseif (!empty($product_info['colors_number'])) { 
			$this->data['colors_number'] = $product_info['colors_number'];
		} else {
			$this->data['colors_number'] = '1';
		}
		
		
		
		if (isset($this->session->data['error_colors_number'])) {
			$this->data['error_colors_number'] = $this->session->data['error_colors_number'];
			unset($this->session->data['error_colors_number']);
		} else {
			$this->data['error_colors_number'] = '';
		}
		
		if (isset($this->session->data['error_color_size'])) {
			$this->data['error_color_size'] = $this->session->data['error_color_size'];
			unset($this->session->data['error_color_size']);
		} else {
			$this->data['error_color_size'] = '';
		}

		if (isset($this->session->data['error_default_color'])) {
			$this->data['error_default_color'] = $this->session->data['error_default_color'];
			unset($this->session->data['error_default_color']);
		} else {
			$this->data['error_default_color'] = '';
		}

		$this->template = 'product/color_size.tpl';
		
		$this->response->setOutput($this->render());
  	}
			
}
?>