<?php
class ControllerProductPrice extends Controller {
	private $error = array();
	
  	public function price_tab() {
		
		$this->load->language('product/price');
		
		$this->load->model('product/color');
		$this->load->model('product/size');

		$this->data['price'] = array();
		if (isset($this->request->get['product_id']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			$this->load->model('product/product');
			$price = $this->model_product_product->getPrice($this->request->get['product_id']);
			
			$quantities = $this->model_product_product->getQuantities($this->request->get['product_id']);
			$upcharge = $this->model_product_product->getUpcharge($this->request->get['product_id']);
			
		}
		
		$this->data['text_add_quantity'] = $this->language->get('text_add_quantity');
		$this->data['color_groups'] = $this->model_product_color->getColorGroups();
		$this->data['sizes_upcharge'] = $this->model_product_size->getSizes(array('filter_apply_additional_cost' => '1', 'sort' => 'sort, description'));
		
		$this->data['symbol_right'] = $this->currency->getSymbolRight();
		$this->data['symbol_left'] = $this->currency->getSymbolLeft();
		$this->data['text_minimum_quantity'] = $this->language->get('text_minimum_quantity');
		$this->data['text_upcharge'] = $this->language->get('text_upcharge');
		$this->data['text_increment'] = $this->language->get('text_increment');


		if (isset($this->request->post['price'])) {
			$this->data['price'] = $this->request->post['price'];
		} elseif (!empty($price)) { 
			$this->data['price'] = $price;
		} else {
			$this->data['price'] = array();
		}

		if (isset($this->request->post['quantities'])) {
			$this->data['quantities'] = $this->request->post['quantities'];
		} elseif (!empty($quantities)) { 
			$this->data['quantities'] = $quantities;
		} else {
			$this->data['quantities'] = array();
		}
		
		if (isset($this->request->post['upcharge'])) {
			$this->data['upcharge'] = $this->request->post['upcharge'];
		} elseif (!empty($upcharge)) { 
			$this->data['upcharge'] = $upcharge;
		} else {
			$this->data['upcharge'] = array();
		}
		
		if (isset($this->session->data['error_quantities'])) {
			$this->data['error_quantities'] = $this->session->data['error_quantities'];
			unset($this->session->data['error_quantities']);
		} else {
			$this->data['error_quantities'] = '';
		}

		if (isset($this->session->data['error_upcharge'])) {
			$this->data['error_upcharge'] = $this->session->data['error_upcharge'];
			unset($this->session->data['error_upcharge']);
		} else {
			$this->data['error_upcharge'] = '';
		}

		if (isset($this->session->data['error_price'])) {
			$this->data['error_price'] = $this->session->data['error_price'];
			unset($this->session->data['error_price']);
		} else {
			$this->data['error_price'] = '';
		}

		$this->template = 'product/price.tpl';
		
		$this->response->setOutput($this->render());
  	}
			
}
?>