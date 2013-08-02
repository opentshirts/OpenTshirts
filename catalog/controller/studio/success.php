<?php 
class ControllerStudioSuccess extends Controller {  
	public function index() {
		
    	$this->language->load('studio/success');

    	$this->data['heading_title'] = $this->language->get('heading_title');
		
		$this->data['text_message'] = sprintf($this->language->get('text_message'), $this->url->link('information/contact'));
		
    	$this->data['button_continue'] = $this->language->get('button_continue');
		
		//$this->data['continue'] = $this->url->link('account/account', '', 'SSL');

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/success.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/success.tpl';
		} else {
			$this->template = 'default/template/studio/success.tpl';
		}
						
		$this->response->setOutput($this->render());				
  	}
}
?>