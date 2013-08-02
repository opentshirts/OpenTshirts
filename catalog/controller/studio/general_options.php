<?php  
class ControllerStudioGeneralOptions extends Controller {
	
	public function index() {
		
		$this->language->load('studio/general_options');
		
		$this->data['general_options_text_select_all'] = $this->language->get('general_options_text_select_all');
		$this->data['general_options_text_clear_selection'] = $this->language->get('general_options_text_clear_selection');
		$this->data['general_options_text_duplicate'] = $this->language->get('general_options_text_duplicate');
		$this->data['general_options_text_undo'] = $this->language->get('general_options_text_undo');
		$this->data['general_options_text_redo'] = $this->language->get('general_options_text_redo');
		$this->data['general_options_text_fit_to_area'] = $this->language->get('general_options_text_fit_to_area');
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/general_options.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/general_options.tpl';
		} else {
			$this->template = 'default/template/studio/general_options.tpl';
		}
		
		$this->render();
		//$this->response->setOutput($this->render());
	}
	

}
?>