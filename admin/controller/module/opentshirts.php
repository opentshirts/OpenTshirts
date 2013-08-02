<?php
class ControllerModuleOpentshirts extends Controller {
	private $error = array(); 
	 
	public function index() {   
		$this->load->language('module/opentshirts');

		$this->document->setTitle($this->language->get('heading_title'));
		
		$this->load->model('setting/setting');
				
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			$this->model_setting_setting->editSetting('opentshirts', $this->request->post);		
			
			$this->session->data['success'] = $this->language->get('text_success');
						
			$this->redirect($this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'));
		}
				
		$this->data['heading_title'] = $this->language->get('heading_title');


		$this->data['text_image_manager'] = $this->language->get('text_image_manager');
		$this->data['text_browse'] = $this->language->get('text_browse');
		$this->data['text_clear'] = $this->language->get('text_clear');	

		$this->data['entry_logo'] = $this->language->get('entry_logo');
		$this->data['entry_template'] = $this->language->get('entry_template');
		$this->data['entry_theme'] = $this->language->get('entry_theme');
		$this->data['entry_video_tutorial_link'] = $this->language->get('entry_video_tutorial_link');
		$this->data['entry_home_button_link'] = $this->language->get('entry_home_button_link');
		$this->data['entry_printing_colors_limit'] = $this->language->get('entry_printing_colors_limit');

		$this->data['tab_data'] = $this->language->get('tab_data'); 
		$this->data['tab_upgrade'] = $this->language->get('tab_upgrade'); 
		$this->data['tab_business_center'] = $this->language->get('tab_business_center'); 
		$this->data['tab_about'] = $this->language->get('tab_about'); 

		$this->data['button_cancel'] = $this->language->get('button_cancel');
		$this->data['button_save'] = $this->language->get('button_save');

 		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}

  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_module'),
			'href'      => $this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);
		
   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('module/opentshirts', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);
		
		$this->data['action'] = $this->url->link('module/opentshirts', 'token=' . $this->session->data['token'], 'SSL');
		
		$this->data['cancel'] = $this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL');
		
		$this->data['token'] = $this->session->data['token'];

		if (isset($this->request->post['ot_config_logo'])) {
			$this->data['ot_config_logo'] = $this->request->post['ot_config_logo'];
		} else {
			$this->data['ot_config_logo'] = $this->config->get('ot_config_logo');			
		}

		$this->load->model('tool/image');

		if ($this->config->get('ot_config_logo') && file_exists(DIR_IMAGE . $this->config->get('ot_config_logo')) && is_file(DIR_IMAGE . $this->config->get('ot_config_logo'))) {
			$this->data['ot_logo'] = $this->model_tool_image->resize($this->config->get('ot_config_logo'), 370, 70);		
		} else {
			$this->data['ot_logo'] = $this->model_tool_image->resize('no_image.jpg', 370, 70);
		}

		$this->data['no_image'] = $this->model_tool_image->resize('no_image.jpg', 370, 70);

		if (isset($this->request->post['video_tutorial_embed'])) {
			$this->data['video_tutorial_embed'] = $this->request->post['video_tutorial_embed'];
		} else {
			$this->data['video_tutorial_embed'] = $this->config->get('video_tutorial_embed');			
		}

		if (isset($this->request->post['home_button_link'])) {
			$this->data['home_button_link'] = $this->request->post['home_button_link'];
		} else {
			$this->data['home_button_link'] = $this->config->get('home_button_link');			
		}

		if (isset($this->request->post['printing_colors_limit'])) {
			$this->data['printing_colors_limit'] = $this->request->post['printing_colors_limit'];
		} else if($this->config->get('printing_colors_limit')) {
			$this->data['printing_colors_limit'] = $this->config->get('printing_colors_limit');			
		} else {
			$this->data['printing_colors_limit'] = 5;	
		}

		$this->data['config_template'] = $this->config->get('config_template');
		
		$this->data['themes'] = array();
		
		$directories = glob(DIR_CATALOG . 'view/theme/default/stylesheet/*', GLOB_ONLYDIR);
		
		foreach ($directories as $directory) {
			$this->data['themes'][] = basename($directory);			
		}	

		if (!$directories) {
			//$this->data['themes'][] = $this->language->get('text_none');	
			$this->data['themes_warning'] = $this->language->get('themes_warning');	
		}
		
		if (isset($this->request->post['config_theme'])) {
			$this->data['config_theme'] = $this->request->post['config_theme'];
		} else {
			$this->data['config_theme'] = $this->config->get('config_theme');
		}

		if (isset($this->request->get['tab']) && $this->request->get['tab']=="upgrade") {
			$this->data['show_upgrade_tab'] = true;	
		} else {
			$this->data['show_upgrade_tab'] = false;	
		}				

		if (isset($this->request->get['tab']) && $this->request->get['tab']=="about") {
			$this->data['show_about_tab'] = true;	
		} else {
			$this->data['show_about_tab'] = false;	
		}	

		if (isset($this->request->get['tab']) && $this->request->get['tab']=="business") {
			$this->data['show_business_tab'] = true;	
		} else {
			$this->data['show_business_tab'] = false;	
		}				

		$this->template = 'module/opentshirts.tpl';

		$this->children = array(
			'common/header',
			'common/footer',
			'module/opentshirts/upgrade_tab',
		);

		$this->response->setOutput($this->render());
	}
	
	private function validate() {
		if (!$this->user->hasPermission('modify', 'module/opentshirts')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
		
		if (!$this->error) {
			return true;
		} else {
			return false;
		}	
	}

	public function theme_thumb() {
		$template = basename($this->request->get['template']);
		$theme = basename($this->request->get['theme']);
		
		if (file_exists(DIR_IMAGE . 'templates/' . $template . '/' . $theme . '.png')) {
			$image = HTTP_CATALOG . 'image/templates/' . $template . '/' . $theme . '.png';
		} else {
			$image = HTTP_CATALOG . 'image/no_image.jpg';
		}
		
		$this->response->setOutput('<img src="' . $image . '" alt="" title="" style="border: 1px solid #EEEEEE;" />');
	}		

	
	public function uninstall() {		
		$this->load->model('opentshirts/install');
		
		$this->model_opentshirts_install->uninstall();

	}
	public function install() {

		$this->load->model('opentshirts/install');
		
		$this->model_opentshirts_install->install();

	}

	public function upgrade_tab() {

		$this->load->language('module/opentshirts');

		$this->data['button_upgrade'] = $this->language->get('button_upgrade');

		$this->data['upgrade'] = $this->url->link('module/opentshirts/upgrade', 'token=' . $this->session->data['token'] , 'SSL');

		if (isset($this->session->data['success_upgrade'])) {
			$this->data['success'] = $this->session->data['success_upgrade'];
		
			unset($this->session->data['success_upgrade']);
		} else {
			$this->data['success'] = '';
		}



		$this->template = 'opentshirts/upgrade_tab.tpl';

		$this->response->setOutput($this->render());
	}

	public function upgrade() {

		$this->load->language('module/opentshirts');

		$file = DIR_APPLICATION . 'model/opentshirts/upgrade.sql';

		if (!file_exists($file)) { 
			die('Could not load sql file: ' . $file); 
		}
		
		if ($sql = file($file)) {

			$this->load->model('opentshirts/upgrade');

			$this->model_opentshirts_upgrade->mysql($sql);

			$this->session->data['success_upgrade'] = $this->language->get('text_success_upgrade');

			$this->redirect($this->url->link('module/opentshirts', 'token=' . $this->session->data['token'] . '&tab=upgrade', 'SSL'));
		} else {
			die('Could not read sql file: ' . $file); 
		}

	}
}
?>