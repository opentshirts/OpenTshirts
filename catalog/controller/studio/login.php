<?php 
class ControllerStudioLogin extends Controller {
	private $error = array();
	
	public function index() {

		if ($this->customer->isLogged()) {  
			$this->redirect($this->url->link('studio/login/welcome', '', 'SSL')); 
		}
	
		$this->language->load('studio/login');
		
		$this->data['heading_title'] = $this->language->get('heading_title');
		$this->data['text_login'] = $this->language->get('text_login');
		$this->data['text_register'] = $this->language->get('text_register');
		$this->data['text_forgotten'] = $this->language->get('text_forgotten');
		$this->data['entry_email'] = $this->language->get('entry_email');
		$this->data['entry_password'] = $this->language->get('entry_password');
		$this->data['error_login'] = $this->language->get('error_login');
		$this->data['button_login'] = $this->language->get('button_login');

									
		if (isset($this->request->post['email']) && isset($this->request->post['password']) && $this->validate()) {
			// Added strpos check to pass McAfee PCI compliance test (http://forum.opencart.com/viewtopic.php?f=10&t=12043&p=151494#p151295)
			if (isset($this->request->post['redirect']) && (strpos($this->request->post['redirect'], HTTP_SERVER) !== false || strpos($this->request->post['redirect'], HTTPS_SERVER) !== false)) {
				$this->redirect(str_replace('&amp;', '&', $this->request->post['redirect']));
			} else {
				$this->redirect($this->url->link('studio/login/welcome', '', 'SSL')); 
			}
		}

		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}
		
		if (isset($this->request->post['email'])) {
			$this->data['email'] = $this->request->post['email'];
		} else {
			$this->data['email'] = '';
		}
		
		$this->data['action'] = $this->url->link('studio/login', '', 'SSL');
		$this->data['register'] = $this->url->link('studio/register', '', 'SSL');
		$this->data['forgotten'] = $this->url->link('studio/forgotten', '', 'SSL');

    	// Added strpos check to pass McAfee PCI compliance test (http://forum.opencart.com/viewtopic.php?f=10&t=12043&p=151494#p151295)
		if (isset($this->request->post['redirect']) && (strpos($this->request->post['redirect'], HTTP_SERVER) !== false || strpos($this->request->post['redirect'], HTTPS_SERVER) !== false)) {
			$this->data['redirect'] = $this->request->post['redirect'];
		} elseif (isset($this->session->data['redirect'])) {
      		$this->data['redirect'] = $this->session->data['redirect'];
			unset($this->session->data['redirect']);		  	
    	} else {
			$this->data['redirect'] = '';
		}

		if (isset($this->session->data['success'])) {
    		$this->data['success'] = $this->session->data['success'];
			unset($this->session->data['success']);
		} else {
			$this->data['success'] = '';
		}

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/login.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/login.tpl';
		} else {
			$this->template = 'default/template/studio/login.tpl';
		}
		
						
		$this->response->setOutput($this->render());
  	}
  
  	private function validate() {
		if (!$this->customer->login($this->request->post['email'], $this->request->post['password'])) {
			$this->error['warning'] = $this->language->get('error_login');
		}
		
		if (!$this->error) {
			return true;
		} else {
			return false;
		}  	
  	}
	
	public function welcome() {
		
		$this->language->load('studio/login');
		
		if ($this->customer->isLogged()) {  
      		$this->data['welcome_close'] = $this->language->get('welcome_close');
			$this->data['welcome_text'] = sprintf($this->language->get('welcome_text'), $this->customer->getFirstName() . ' ' . $this->customer->getLastName());

	
			if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/welcome.tpl')) {
				$this->template = $this->config->get('config_template') . '/template/studio/welcome.tpl';
			} else {
				$this->template = 'default/template/studio/welcome.tpl';
			}
			
							
			$this->response->setOutput($this->render());
    		}
		
  	}
}
?>