<?php  
class ControllerStudioListProduct extends Controller {
	
	public function index() {
		
		$this->language->load('studio/product');
		
		$this->data['product_text_categories'] = $this->language->get('product_text_categories');
		$this->data['product_text_search'] = $this->language->get('product_text_search');
		$this->data['product_text_title'] = $this->language->get('product_text_title');
		$this->data['link_more_product'] = $this->url->link('studio/list_product/getMore');
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/image/loading.gif')) {
			$this->data['loading_image'] = 'catalog/view/theme/'.$this->config->get('config_template') . '/image/loading.gif';
		} else {
			$this->data['loading_image'] = 'image/loading.gif';
		}
		
		$this->data['product_keyword'] = '';
		$this->data['product_category'] = '';


		$this->load->model('catalog/category');
		$this->data['categories'] = array();
		$categories = $this->model_catalog_category->getCategories(0);
		foreach ($categories as $category) {
			if ($category['top']) {
				// Level 1
				$this->data['categories'][] = array(
					'id_category'     => $category['category_id'],
					'description'     => $category['name'],
					'children' => $this->getCategories($category['category_id'])
				);
			}
		}
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/list_product.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/list_product.tpl';
		} else {
			$this->template = 'default/template/studio/list_product.tpl';
		}

		
		$this->render();
		//$this->response->setOutput($this->render());
	}

	private function getCategories($parent_id) {
		$categories = array();

		$children = $this->model_catalog_category->getCategories($parent_id);
				
		foreach ($children as $child) {
			$categories[] = array(
				'id_category'     => $child['category_id'],
				'description'     => $child['name'],
				'children' => $this->getCategories($child['category_id'])
			);					
		}
		return $categories;
	}
	
	public function getMore() {
		
		$this->language->load('studio/product');
			
		$this->data['product_text_empty'] = $this->language->get('product_text_empty');	
		$this->data['product_text_show_more'] = $this->language->get('product_text_show_more');	

		$filters = array();
		
		//$filters['sort'] = "RAND()";
		$filters['order'] = "ASC";
		$filters['filter_printable'] = "1";

		//keyword
		if (!empty($this->request->request['product_keyword'])) {
      		$filters['filter_name']= $this->request->request['product_keyword'];
      		$filters['filter_tag']= $this->request->request['product_keyword'];
			$this->data['product_keyword'] = $this->request->request['product_keyword'];
		} else {
			$this->data['product_keyword'] = '';
		}	
		
		//filter category		
		if (!empty($this->request->request['product_category'])) {
      		$filters['filter_category_id'] = $this->request->request['product_category'];
			$this->data['product_category'] = $this->request->request['product_category'];
		} else {
			$this->data['product_category'] = '';
		}
		
		$this->load->model('opentshirts/product');
		$this->load->model('catalog/manufacturer');
		$this->load->model('opentshirts/product_color');
		$this->load->model('tool/image');
		
		$this->data['manufacturers'] = $this->model_catalog_manufacturer->getManufacturers();
		$this->data['colors'] = $this->model_opentshirts_product_color->getColors();
		
		$total = $this->model_opentshirts_product->getTotalProducts($filters);

		if (isset($this->request->request['product_page'])) {
      		$this->data['product_page'] = $this->request->request['product_page'];
		} else {
			$this->data['product_page'] = 1;
		}
		
		$page = $this->data['product_page'];
		$limit = 10;
		
		$pagination = new Pagination();
		$pagination->total = $total;
		$pagination->page = $page;
		$pagination->limit = $limit;
		
		$filters['start'] = ($page - 1) * $limit;
		$filters['limit'] = $limit;

		$this->data['products'] = array();
		$results = $this->model_opentshirts_product->getProducts($filters);
		
    	foreach ($results as $result) {
			
			
			if ($result['image']) {
				$image = $this->model_tool_image->resize($result['image'], 200, 200);
			} else {
				$image = false;
			}

			if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
				$price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')));
			} else {
				$price = false;
			}
			
			if ((float)$result['special']) {
				$special = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')));
			} else {
				$special = false;
			}	
			
			if ($this->config->get('config_tax')) {
				$tax = $this->currency->format((float)$result['special'] ? $result['special'] : $result['price']);
			} else {
				$tax = false;
			}				
			
			if ($this->config->get('config_review_status')) {
				$rating = (int)$result['rating'];
			} else {
				$rating = false;
			}
			
			$colors = $this->model_opentshirts_product->getColors($result['product_id']);
			
			/*$this->data['products'][] = array(
				'id_product'    => $result['product_id'],
				'name'      	=> $result['name'],
				'weight'      	=> $result['weight'],
				'description'   => $result['description'],
				'id_manufacturer'   => $result['id_manufacturer'],
				'colors'   => $colors,
				'thumb'      	=> $thumb
			);*/
			$this->data['products'][] = array(
				'product_id'  => $result['product_id'],
				'thumb'       => $image,
				'name'        => $result['name'],
				'description' => utf8_substr(strip_tags(html_entity_decode($result['description'], ENT_QUOTES, 'UTF-8')), 0, 250) . '..',
				'weight'      => $result['weight'],
				'weight_unit' => $this->weight->getUnit($result['weight_class_id']),
				'manufacturer'   => $result['manufacturer'],
				'price'       => $price,
				'colors'       => $colors,
				'special'     => $special,
				'tax'         => $tax,
				'rating'      => $result['rating'],
				'reviews'     => sprintf($this->language->get('text_reviews'), (int)$result['reviews']),
				'href'        => $this->url->link('product/product', 'product_id=' . $result['product_id'])
			);
		}

		$this->data['show_more'] = (bool)($pagination->getEnd()<$pagination->getTotal());
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/more_product.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/more_product.tpl';
		} else {
			$this->template = 'default/template/studio/more_product.tpl';
		}
		
		$this->response->setOutput($this->render());
	}
}
?>