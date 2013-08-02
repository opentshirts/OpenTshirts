<?php
class ControllerOpentshirtsOrder extends Controller {
	
	public function artwork() {
		$this->load->model('sale/order');

		if (isset($this->request->get['order_id'])) {
			$order_id = $this->request->get['order_id'];
		} else {
			$order_id = 0;
		}

		$order_info = $this->model_sale_order->getOrder($order_id);

		if ($order_info) {
			$this->load->language('opentshirts/order');

			$this->data['text_png'] = $this->language->get('text_png');
			$this->data['text_assets'] = $this->language->get('text_assets');

			$this->load->model('opentshirts/composition_order');
			$this->load->model('opentshirts/composition');
			$this->load->model('opentshirts/design');
			$this->load->model('opentshirts/design_element');
			$this->load->model('catalog/product');
			$this->load->model('tool/image');
			$compositions = $this->model_opentshirts_composition_order->getOrderCompositions($order_id);

			$this->data['compositions'] = array();
			if($compositions) {
				foreach ($compositions as $value) {

					$composition_info = $this->model_opentshirts_composition->getComposition($value['id_composition']);
				
					$designs = array();
					$results = $this->model_opentshirts_design->getDesigns(array("filter_id_composition" => $composition_info['id_composition']));
					foreach ($results as $result) {
						
						if (file_exists(DIR_IMAGE . 'data/designs/design_' . $result['id_design']. '/snapshot.png')) {
							$image['thumb'] = $this->model_tool_image->resize('data/designs/design_' . $result['id_design']. '/snapshot.png', 60, 60);
						} else {
							$image['thumb'] = $this->model_tool_image->resize('no_image.jpg', 60, 60);
						}
		
						if (file_exists(DIR_IMAGE . 'data/designs/design_' . $result['id_design']. '/snapshot.png')) {
							$image['large'] = $this->model_tool_image->resize('data/designs/design_' . $result['id_design']. '/snapshot.png', 300, 300);
						} else {
							$image['large'] = $this->model_tool_image->resize('no_image.jpg', 300, 300);
						}
		
						if (file_exists(DIR_IMAGE . 'data/designs/design_' . $result['id_design']. '/snapshot.png')) {
							$image['original'] = HTTPS_CATALOG . 'image/data/designs/design_' . $result['id_design']. '/snapshot.png';
						} else {
							$image['original'] = '';
						}

						if (file_exists(DIR_IMAGE . 'data/designs/design_' . $result['id_design']. '/design_image.png')) {
							$image['png'] = HTTPS_CATALOG . 'image/data/designs/design_' . $result['id_design']. '/design_image.png';
						} else {
							$image['png'] = '';
						}

						$designs[] = array(
							'id_design'    => $result['id_design'],
							'images'    => $image,
							'design_elements'    => $this->model_opentshirts_design_element->getDesignElements(array("filter_id_design" => $result['id_design']))
						);
						
					}
					
					$product_result = $this->model_catalog_product->getProduct($composition_info['product_id']);
					$product_info['name'] = $product_result['name'];
					$product_info['link'] = $this->url->link('catalog/product/', 'token=' . $this->session->data['token'] . '&filter_name=' . $product_result['name'] , 'SSL');
					
					$this->data['comps'][] = array(
						'id_composition'    => $composition_info['id_composition'],
						'name'    	   		=> $composition_info['name'],
						'product'	 		=> $product_info,
						'designs'			=> $designs
					);

				}
			} else {
				$this->data['text_no_artwork'] = $this->language->get('text_no_artwork');
			}
			
			$this->template = 'opentshirts/order_artwork.tpl';			
			$this->response->setOutput($this->render());
		} 
	}
}
?>