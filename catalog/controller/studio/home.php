<?php  
class ControllerStudioHome extends Controller {
	public function index() {
		
		$this->language->load('studio/home');
		
		$this->document->setTitle($this->config->get('config_title'));
		$this->document->setDescription($this->config->get('config_meta_description'));
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/studio.swf')) {
			$this->data['studio_swf'] = 'catalog/view/theme/'.$this->config->get('config_template') . '/template/studio/studio.swf';
		} else {
			$this->data['studio_swf'] = 'catalog/view/theme/default/template/studio/studio.swf';
		}
		
		$this->data['idc'] = false;
		if (isset($this->request->get['idc']) && $this->customer->isLogged()) {
			$this->load->model('opentshirts/composition');
			$filters = array();
			$filters['filter_editable'] = 1; //validate editable status
			$filters['filter_id_composition'] = $this->request->get['idc'];
			$filters['filter_id_author'] = $this->customer->getId();
			$total = $this->model_opentshirts_composition->getTotalCompositions($filters);
			if($total>=1) {
				$this->data['idc'] = $this->request->get['idc'];
			} else {
				$this->data['idc_error'] = $this->language->get('idc_error');
			}
    	}
		
		$this->data['import_idc'] = false;
		if (isset($this->request->get['import_idc'])) {
			$this->load->model('opentshirts/composition');
			$filters = array();
			$filters['filter_id_composition'] = $this->request->get['import_idc'];
			$total = $this->model_opentshirts_composition->getTotalCompositions($filters);
			if($total>=1) {
				$this->data['import_idc'] = $this->request->get['import_idc'];
			}
    	}
		
		$this->data['default_product'] = false;
		if($this->data['import_idc']===false && $this->data['idc']===false && isset($this->request->get['product_id']))
		{
			$this->load->model('opentshirts/product');
			$total = $this->model_opentshirts_product->getTotalProductsByID($this->request->get['product_id']);
			if($total>=1) {
				$this->data['default_product'] = $this->request->get['product_id'];
			}
		}
		
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/image/loading.gif')) {
			$this->data['loading_image'] = 'catalog/view/theme/'.$this->config->get('config_template') . '/image/loading.gif';
		} else {
			$this->data['loading_image'] = 'image/loading.gif';
		}

		$this->data['text_loading'] = $this->language->get('text_loading');

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/home.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/home.tpl';
		} else {
			$this->template = 'default/template/studio/home.tpl';
		}
		
		$video_tutorial_embed = $this->config->get('video_tutorial_embed');
		if (empty($video_tutorial_embed)) {
			$this->data['video_tutorial_embed'] = '';
		} else {
			$this->data['video_tutorial_embed'] = $this->config->get('video_tutorial_embed');
		}
		
		$this->children = array(
			'studio/product_colors',
			'studio/price/price_container',
			'studio/save/save_container',
			'printing_method/modules/get_printing_methods',
			'studio/list_clipart',
			'studio/list_template',
			'studio/list_product',
			'studio/toolbar',
			'studio/zoom',
			'studio/footer',
			'studio/header',
			'studio/general_options'
		);
										
		$this->response->setOutput($this->render());
	}
}
?>