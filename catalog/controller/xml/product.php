<?php 
class ControllerXmlProduct extends Controller { 
	public function index() {
		
		$this->load->language('xml/xml');

		if (isset($this->request->get['id_product'])) {
			
			$this->request->get['product_id'] = $this->request->get['id_product'];
			$this->load->model('opentshirts/product');
			
			if($product = $this->model_opentshirts_product->getProduct($this->request->get['product_id']))
			{
				$this->load->model('opentshirts/product_view');
				$this->load->model('opentshirts/product_region');
				$this->load->model('opentshirts/product_fill');
				
				$views = array();
				$result = $this->model_opentshirts_product_view->getViews(array('product_id' => $this->request->get['product_id']));
				foreach ($result as $view) {
					$regions = array();
					foreach ($this->model_opentshirts_product_region->getRegions(array('product_id' => $this->request->get['product_id'], 'view_index' => $view['view_index'])) as $region) {
						$regions[] = array(
							'region_index'	=> $region['region_index'],
							'name'		=> $region['name'],
							'x'			=> $region['x'],
							'y'			=> $region['y'],
							'width'		=> $region['width'],
							'height'	=> $region['height'],
							'mask'	=> ($region['mask'])?'image/data/products/' . $region['mask']:''
						);
					}	
					$fills = array();
					foreach ($this->model_opentshirts_product_fill->getFills(array('product_id' => $this->request->get['product_id'], 'view_index' => $view['view_index'])) as $fill) {
						$fills[] = array(
							'view_fill_index'	=> $fill['view_fill_index'],
							'file'		=> $fill['file'],
							'image' =>  ($fill['file'])?'image/data/products/' . $fill['file']:''
						);
					}
					
					$views[] = array(
						'view_index'	=> $view['view_index'],
						'name'			=> $view['name'],
						'regions_scale'	=> $view['regions_scale'],
						'shade'			=> ($view['shade'])?'image/data/products/' . $view['shade']:'',
						'underfill'		=> ($view['underfill'])?'image/data/products/' . $view['underfill']:'',
						'regions'		=> $regions,
						'fills'			=> $fills
					);
				}	
				
				$colors = $this->model_opentshirts_product->getColorsSizes($this->request->get['product_id']);
				
				$product_info = array(
					'product_id'	=> $product['product_id'],
					'name'      	=> $product['name'],
					'default_view'  => $product['default_view'],
					'default_region'=> $product['default_region'],
					'default_color' => $product['default_color'],
					'views'      	=> $views,
					'colors'      	=> $colors,
				);
				
			} else {
				$error_warning = $this->language->get('wrong_id_product');
			}
		} else {
			$error_warning = $this->language->get('no_id_product');
		}
		
		if(isset($error_warning)) {
			$this->data['error_warning'] = $error_warning;
		} else {
			$this->data['error_warning'] = '';
		}
	
		if(isset($product_info)) {
			$this->data['product_id'] = $product_info['product_id'];
			$this->data['name'] = $product_info['name'];
			$this->data['default_view'] = $product_info['default_view'];
			$this->data['default_region'] = $product_info['default_region'];
			$this->data['default_color'] = $product_info['default_color'];
			$this->data['views'] = $product_info['views'];
			$this->data['colors'] = $product_info['colors'];
		} else {
			$this->data['product_id'] = '';
			$this->data['name'] = '';
			$this->data['default_view'] = '';
			$this->data['default_region'] = '';
			$this->data['default_color'] = '';
			$this->data['views'] = array();
			$this->data['colors'] = array();
		}
	
		$this->template = 'default/template/xml/product.tpl';
		
		$this->response->addHeader("Content-type: text/xml");
		$this->response->setOutput($this->render());
  	}
}
?>