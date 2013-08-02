<?php  
class ControllerStudioListClipart extends Controller {
	
	public function index() {
		
		$this->language->load('studio/clipart');
		
		$this->data['clipart_text_categories'] = $this->language->get('clipart_text_categories');
		$this->data['clipart_text_search'] = $this->language->get('clipart_text_search');
		$this->data['clipart_text_title'] = $this->language->get('clipart_text_title');
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/image/loading.gif')) {
			$this->data['loading_image'] = 'catalog/view/theme/'.$this->config->get('config_template') . '/image/loading.gif';
		} else {
			$this->data['loading_image'] = 'image/loading.gif';
		}
		
		$this->data['clipart_keyword'] = '';
		
		$this->load->model('opentshirts/clipart_category');	
		$categories = $this->model_opentshirts_clipart_category->getCategoriesByParentId();
		$this->data['clipart_category'] = '';
		$this->data['categories'] = $categories;
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/list_clipart.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/list_clipart.tpl';
		} else {
			$this->template = 'default/template/studio/list_clipart.tpl';
		}
		
		//$this->response->setOutput($this->render());
		$this->render();
	}
	
	public function getMore() {
		
		$this->language->load('studio/clipart');
			
		$this->data['clipart_text_empty'] = $this->language->get('clipart_text_empty');	
		$this->data['clipart_text_show_more'] = $this->language->get('clipart_text_show_more');	
		
		$filters = array();
		$filters['filter_status'] = 1;
		$filters['sort'] = 'RAND()';
		$filters['order'] = 'ASC';

		$filters_b = array();
		$filters_b['filter_status'] = 1;
		$filters_b['sort'] = 'RAND()';
		$filters_b['order'] = 'ASC';
		$filters_b['filter_from_customer'] = '0';

		//keyword
		if (!empty($this->request->request['clipart_keyword'])) {
      		$this->data['clipart_keyword'] = $this->request->request['clipart_keyword'];
			$filters['filter_keyword'] = $this->request->request['clipart_keyword'];
			$filters['sort'] = 'c.date_added';
			$filters_b['filter_keyword'] = $this->request->request['clipart_keyword'];
			$filters_b['sort'] = 'b.date_added';
		} else {
			$this->data['clipart_keyword'] = '';		
		}	
		
		//category
		$this->load->model('opentshirts/clipart_category');
		if (!empty($this->request->request['clipart_category'])) {
      		$this->data['clipart_category'] = $this->request->request['clipart_category'];
			$filters['filter_category'] = $this->request->request['clipart_category'];
			$filters['sort'] = 'c.date_added';
			$filters_b['filter_category'] = $this->request->request['clipart_category'];
			$filters_b['sort'] = 'b.date_added';
		} else {
			$this->data['clipart_category'] = '';
		}

		$this->data['categories'] = $this->model_opentshirts_clipart_category->getCategoriesByParentId();
		
		$this->load->model('opentshirts/clipart');
		$this->load->model('opentshirts/bitmap');
		
		$total  = $this->model_opentshirts_clipart->getTotalcliparts($filters);
		$total += $this->model_opentshirts_bitmap->getTotalbitmaps($filters_b);

		if (isset($this->request->request['clipart_page'])) {
      		$this->data['clipart_page'] = $this->request->request['clipart_page'];
		} else {
			$this->data['clipart_page'] = 1;
		}
		$page = $this->data['clipart_page'];
		$limit = 21;
		
		$pagination = new Pagination();
		$pagination->total = $total;
		$pagination->page = $page;
		$pagination->limit = $limit;
		
		$filters['start'] = ($page - 1) * $limit;
		$filters['limit'] = $limit;
		
		$results = $this->model_opentshirts_clipart->getCliparts($filters);

		$this->load->model('tool/image');
		$this->data['cliparts'] = array();
		foreach ($results as $result) {
			
			if($result['image_file'] && file_exists(DIR_IMAGE . 'data/cliparts/' . $result['image_file'])) {
				$thumb = $this->model_tool_image->resize('data/cliparts/' .$result['image_file'], 100, 100);
			} else {
				$thumb = $this->model_tool_image->resize('no_image.jpg', 100, 100);
			}
			
			$this->data['cliparts'][] = array(
				'id_clipart'    => $result['id_clipart'],
				'name'      	=> $result['name'],
				'thumb'      	=> 	$thumb
			);
		}


		$results_b = $this->model_opentshirts_bitmap->getBitmaps($filters_b);
		foreach ($results_b as $result) {
			
			if($result['image_file'] && file_exists(DIR_IMAGE . 'data/bitmaps/' . $result['image_file'])) {
				$thumb = $this->model_tool_image->resize('data/bitmaps/' .$result['image_file'], 100, 100);
			} else {
				continue;
			}

			foreach($result['colors'] as &$color) {
				$color = "'".$color."'";
			}
			
			$this->data['cliparts'][] = array(
				'id_bitmap'     => $result['id_bitmap'],
				'source'        => 'image/data/bitmaps/'.$result['image_file'],
				'name'      	=> $result['name'],
				'colors'      	=> implode(",", $result['colors']),
				'thumb'      	=> 	$thumb
			);
		}
		shuffle($this->data['cliparts']);

		$this->data['show_more'] = (bool)($pagination->getEnd()<$pagination->getTotal());
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/more_clipart.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/more_clipart.tpl';
		} else {
			$this->template = 'default/template/studio/more_clipart.tpl';
		}
		
		$this->response->setOutput($this->render());
	}
}
?>