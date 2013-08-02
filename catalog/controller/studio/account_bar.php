<?php  
class ControllerStudioAccountBar extends Controller {
	
	public function index() {
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/account_bar.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/account_bar.tpl';
		} else {
			$this->template = 'default/template/studio/account_bar.tpl';
		}
		
		$this->render();
	}

	public function refresh() {
		
		$this->language->load('studio/account_bar');
		if(($this->config->get('config_use_ssl') || $this->config->get('config_secure')) && !isset($this->request->server['HTTPS'])) {
			$this->data['text_welcome'] = sprintf($this->language->get('text_welcome_ssl'), $this->url->link('account/account', '', 'SSL'), $this->url->link('account/account', '', 'SSL'));
			$this->data['text_logged'] = sprintf($this->language->get('text_logged_ssl'), $this->url->link('account/account', '', 'SSL'), $this->customer->getFirstName(), $this->url->link('studio/logout', '', 'SSL'));
		} else {
			$this->data['text_welcome'] = sprintf($this->language->get('text_welcome'), $this->url->link('studio/login', '', 'SSL'), $this->url->link('studio/register', '', 'SSL'));
			$this->data['text_logged'] = sprintf($this->language->get('text_logged'), $this->url->link('account/account', '', 'SSL'), $this->customer->getFirstName(), $this->url->link('studio/logout', '', 'SSL'));
		}

		$this->data['logged'] = $this->customer->isLogged();
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/account_bar_refresh.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/account_bar_refresh.tpl';
		} else {
			$this->template = 'default/template/studio/account_bar_refresh.tpl';
		}
		
		$this->response->setOutput($this->render());
	}
	

}
?>