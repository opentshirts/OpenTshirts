<?php  
class ControllerStudioToolbar extends Controller {
	
	public function index() {
		
		$this->language->load('studio/toolbar');
		
		$this->data['toolbar_text_add_clipart'] = $this->language->get('toolbar_text_add_clipart');
		$this->data['toolbar_text_add_text'] = $this->language->get('toolbar_text_add_text');
		$this->data['toolbar_text_select_product'] = $this->language->get('toolbar_text_select_product');
		$this->data['toolbar_text_save'] = $this->language->get('toolbar_text_save');
		$this->data['toolbar_text_export_image'] = $this->language->get('toolbar_text_export_image');
		$this->data['toolbar_text_import_template'] = $this->language->get('toolbar_text_import_template');

		$this->load->library('user');
		$this->user = new User($this->registry);
		$this->data['show_export_image'] = $this->user->isLogged();
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/toolbar.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/toolbar.tpl';
		} else {
			$this->template = 'default/template/studio/toolbar.tpl';
		}
		
		$this->render();
	}

}
?>