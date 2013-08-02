<?php   
class ControllerStudioHeader extends Controller {
	protected function index() {
		
		if (isset($this->request->server['HTTPS']) && (($this->request->server['HTTPS'] == 'on') || ($this->request->server['HTTPS'] == '1'))) {
			$this->data['base'] = $this->config->get('config_ssl');
		} else {
			$this->data['base'] = $this->config->get('config_url');
		}
		
		$this->data['title'] = $this->document->getTitle();
		$this->data['description'] = $this->document->getDescription();
		$this->data['keywords'] = $this->document->getKeywords();
		$this->data['links'] = $this->document->getLinks();	 
		$this->data['styles'] = $this->document->getStyles();
		$this->data['scripts'] = $this->document->getScripts();
		$this->data['lang'] = $this->language->get('code');
		$this->data['direction'] = $this->language->get('direction');
		$this->data['google_analytics'] = html_entity_decode($this->config->get('config_google_analytics'), ENT_QUOTES, 'UTF-8');
		
		$this->language->load('studio/header');
		
		$this->data['theme'] = $this->config->get('config_theme');
		
		if (isset($this->request->server['HTTPS']) && (($this->request->server['HTTPS'] == 'on') || ($this->request->server['HTTPS'] == '1'))) {
			$server = HTTPS_SERVER . 'image/';
		} else {
			$server = HTTP_SERVER . 'image/';
		}	
				
		if ($this->config->get('config_icon') && file_exists(DIR_IMAGE . $this->config->get('config_icon'))) {
			$this->data['icon'] = $server . $this->config->get('config_icon');
		} else {
			$this->data['icon'] = '';
		}
		
		$this->data['name'] = $this->config->get('config_name');
		
		if ($this->config->get('ot_config_logo') && file_exists(DIR_IMAGE . $this->config->get('ot_config_logo'))) {
			$this->data['logo'] = $server . $this->config->get('ot_config_logo');
		} else {
			$this->data['logo'] = '';
		}
		
		$this->data['text_welcome'] = sprintf($this->language->get('text_welcome'), $this->url->link('account/login', '', 'SSL'), $this->url->link('account/register', '', 'SSL'));
		$this->data['text_logged'] = sprintf($this->language->get('text_logged'), $this->url->link('account/account', '', 'SSL'), $this->customer->getFirstName(), $this->url->link('account/logout', '', 'SSL'));
		$this->data['logged'] = $this->customer->isLogged();
		
		$this->data['action'] = $this->url->link('studio/home');

		if (!isset($this->request->get['route'])) {
			$this->data['redirect'] = $this->url->link('studio/home');
		} else {
			$data = $this->request->get;
			
			unset($data['_route_']);
			
			$route = $data['route'];
			
			unset($data['route']);
			
			$url = '';
			
			if ($data) {
				$url = '&' . urldecode(http_build_query($data, '', '&'));
			}			
			
			$this->data['redirect'] = $this->url->link($route, $url);
		}

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && isset($this->request->post['language_code'])) {

			$this->session->data['language'] = $this->request->post['language_code'];
		
			if (isset($this->request->post['redirect'])) {
				$this->redirect($this->request->post['redirect']);
			} else {
				$this->redirect($this->url->link('studio/home'));
			}
		}
				
		$this->data['text_language'] = $this->language->get('text_language');
		$this->data['language_code'] = $this->session->data['language'];
		
		$this->load->model('localisation/language');
		
		$this->data['languages'] = array();
		
		$results = $this->model_localisation_language->getLanguages();
		foreach ($results as $result) {
			if ($result['status']) {
				$this->data['languages'][] = array(
					'name'  => $result['name'],
					'code'  => $result['code'],
					'image' => $result['image']
				);	
			}
		}
		
		$this->data['menu'] = array();
		$home_button_link = $this->config->get('home_button_link');
		if(!empty($home_button_link)) {
			$this->data['menu'][] = array('link' => $this->config->get('home_button_link'), 'text' => $this->language->get('text_home'), 'separator' => false);
		} else {
			$this->data['menu'][] = array('link' => $this->url->link('common/home'), 'text' => $this->language->get('text_home'), 'separator' => false);
		}
		$this->data['menu'][] = array('link' => $this->url->link('account/account'), 'text' => $this->language->get('text_account'), 'separator' => $this->language->get('menu_separator'));
		$this->data['menu'][] = array('link' => $this->url->link('opentshirts/account/mydesigns'), 'text' => $this->language->get('text_my_designs'), 'separator' => $this->language->get('menu_separator'));
		$this->data['menu'][] = array('link' => $this->url->link('checkout/cart'), 'text' => $this->language->get('text_cart'), 'separator' => $this->language->get('menu_separator'));
		$this->data['menu'][] = array('link' => $this->url->link('checkout/checkout'), 'text' => $this->language->get('text_checkout'), 'separator' => $this->language->get('menu_separator'));
		$this->data['menu'][] = array('link' => $this->url->link('information/contact'), 'text' => $this->language->get('text_contact'), 'separator' => $this->language->get('menu_separator'));
				

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/header.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/header.tpl';
		} else {
			$this->template = 'default/template/studio/header.tpl';
		}

		$this->children = array(
			'studio/account_bar'
		);
		
    	$this->render();
	} 	
}
?>