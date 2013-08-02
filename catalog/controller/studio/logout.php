<?php 
class ControllerStudioLogout extends Controller {
	public function index() {

		if ($this->customer->isLogged()) {  
		    $this->customer->logout();
			$this->cart->clear();
			
			unset($this->session->data['shipping_address_id']);
			unset($this->session->data['shipping_address']);
			unset($this->session->data['shipping_method']);
			unset($this->session->data['shipping_methods']);
			unset($this->session->data['payment_address_id']);
			unset($this->session->data['payment_address']);
			unset($this->session->data['payment_method']);
			unset($this->session->data['payment_methods']);
			unset($this->session->data['comment']);
			unset($this->session->data['order_id']);

      		$this->redirect($this->url->link('studio/logout', '', 'SSL'));
    	}
		
		$this->language->load('studio/logout');
	
		$this->data['text_logout_successfully'] = $this->language->get('text_logout_successfully');

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/logout.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/logout.tpl';
		} else {
			$this->template = 'default/template/studio/logout.tpl';
		}
		
						
		$this->response->setOutput($this->render());
  	}
  
}
?>