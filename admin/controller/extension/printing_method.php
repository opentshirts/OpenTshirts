<?php
class ControllerExtensionPrintingMethod extends Controller {
	private $error = array();


	public function index() {
		$this->load->language('extension/printing_method');
		 
		$this->document->setTitle($this->language->get('heading_title')); 

  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('extension/printing_method', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);
		
		$this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['text_no_results'] = $this->language->get('text_no_results');
		$this->data['text_confirm'] = $this->language->get('text_confirm');

		$this->data['column_name'] = $this->language->get('column_name');
		$this->data['column_status'] = $this->language->get('column_status');
		$this->data['column_sort_order'] = $this->language->get('column_sort_order');
		$this->data['column_action'] = $this->language->get('column_action');

		$this->data['button_autoselect'] = $this->language->get('button_autoselect');

		$this->data['link_autoselect'] = $this->url->link('extension/printing_method/autoselect', 'token=' . $this->session->data['token'], 'SSL');

		if (isset($this->session->data['success'])) {
			$this->data['success'] = $this->session->data['success'];
		
			unset($this->session->data['success']);
		} else {
			$this->data['success'] = '';
		}

		if (isset($this->session->data['error'])) {
			$this->data['error'] = $this->session->data['error'];
		
			unset($this->session->data['error']);
		} else {
			$this->data['error'] = '';
		}

		$this->load->model('setting/extension');

		$extensions = $this->model_setting_extension->getInstalled('printing_method');
		
		foreach ($extensions as $key => $value) {
			if (!file_exists(DIR_APPLICATION . 'controller/printing_method/' . $value . '.php')) {
				$this->model_setting_extension->uninstall('printing_method', $value);
				
				unset($extensions[$key]);
			}
		}
		
		$this->data['extensions'] = array();
						
		$files = glob(DIR_APPLICATION . 'controller/printing_method/*.php');
		
		if ($files) {
			foreach ($files as $file) {
				$extension = basename($file, '.php');
				
				$this->load->language('printing_method/' . $extension);
	
				$action = array();
				
				if (!in_array($extension, $extensions)) {
					$action[] = array(
						'text' => $this->language->get('text_install'),
						'href' => $this->url->link('extension/printing_method/install', 'token=' . $this->session->data['token'] . '&extension=' . $extension, 'SSL')
					);
				} else {
					$action[] = array(
						'text' => $this->language->get('text_edit'),
						'href' => $this->url->link('printing_method/' . $extension . '', 'token=' . $this->session->data['token'], 'SSL')
					);
								
					$action[] = array(
						'text' => $this->language->get('text_uninstall'),
						'href' => $this->url->link('extension/printing_method/uninstall', 'token=' . $this->session->data['token'] . '&extension=' . $extension, 'SSL')
					);
				}
				
				
				
				$this->data['extensions'][] = array(
					'name'       => $this->language->get('heading_title'),
					'status'     => $this->config->get($extension . '_status') ? $this->language->get('text_enabled') : $this->language->get('text_disabled'),
					'sort_order' => $this->config->get($extension . '_sort_order'),
					'action'     => $action
				);
			}
		}

		$this->template = 'extension/printing_method.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}

	public function autoselect() {

		$this->load->language('printing_method/autoselect');
		 
		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('setting/setting'); 

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate_autoselect()) {

			$this->request->post['ot_enable_autoselect'] = !empty($this->request->post['enable_autoselect'])?1:0;
			unset($this->request->post['enable_autoselect']);
			$this->request->post['ot_quantities'] = $this->request->post['quantities'];
			unset($this->request->post['quantities']);
			$this->request->post['ot_descriptions'] = $this->request->post['descriptions'];
			unset($this->request->post['descriptions']);
			$this->request->post['ot_pm'] = $this->request->post['pm'];
			unset($this->request->post['pm']);
			$this->request->post['ot_title_text'] = $this->request->post['title_text'];
			unset($this->request->post['title_text']);

			$this->model_setting_setting->editSetting('opentshirts_autoselect', $this->request->post);

			$this->session->data['success'] = $this->language->get('text_success');
			
			$this->redirect($this->url->link('extension/printing_method', 'token=' . $this->session->data['token'], 'SSL'));
		}

  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_printing_methods'),
			'href'      => $this->url->link('extension/printing_method', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('extension/printing_method/autoselect', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);
		
		$this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['button_save'] = $this->language->get('button_save');
		$this->data['button_cancel'] = $this->language->get('button_cancel');

		$this->data['action'] = $this->url->link('extension/printing_method/autoselect', 'token=' . $this->session->data['token'], 'SSL');

		$this->data['cancel'] = $this->url->link('extension/printing_method', 'token=' . $this->session->data['token'], 'SSL');	
		

		$this->data['text_add_quantity'] = $this->language->get('text_add_quantity');
		$this->data['text_increment'] = $this->language->get('text_increment');
		$this->data['text_enable_autoselect'] = $this->language->get('text_enable_autoselect');
		$this->data['text_autoselect_help'] = $this->language->get('text_autoselect_help');
		$this->data['text_quantity_break'] = $this->language->get('text_quantity_break');
		$this->data['text_description'] = $this->language->get('text_description');
		$this->data['text_available_printing_methods'] = $this->language->get('text_available_printing_methods');
		$this->data['text_popup_title'] = $this->language->get('text_popup_title');

		
		
		$this->data['printing_methods'] = array();
						
		$files = glob(DIR_APPLICATION . 'controller/printing_method/*.php');
		
		if ($files) {
			foreach ($files as $file) {
				$extension = basename($file, '.php');
				
				$this->load->language('printing_method/' . $extension);
				
				$this->data['printing_methods'][] = array(
					'name'       => $this->language->get('heading_title'),
					'extension'  => $extension,
					'status'     => $this->config->get($extension . '_status'),
					'sort_order' => $this->config->get($extension . '_sort_order')
				);
			}
		}



		if($this->request->server['REQUEST_METHOD'] == 'POST') {
			$this->data['enable_autoselect'] = $this->request->post['enable_autoselect'];
		} elseif ($this->config->get('ot_enable_autoselect')!="") { 
			$this->data['enable_autoselect'] = $this->config->get('ot_enable_autoselect');
		} else {
			$this->data['enable_autoselect'] = 'on';
		}

		if (isset($this->request->post['quantities'])) {
			$this->data['quantities'] = $this->request->post['quantities'];
		} elseif ($this->config->get('ot_quantities')) { 
			$this->data['quantities'] = $this->config->get('ot_quantities');
		} else {
			$this->data['quantities'] = array('0','24');
		}

		if (isset($this->request->post['descriptions'])) {
			$this->data['descriptions'] = $this->request->post['descriptions'];
		} elseif ($this->config->get('ot_descriptions')) { 
			$this->data['descriptions'] = $this->config->get('ot_descriptions');
		} else {
			$this->data['descriptions'] = array('Less than 24','More than 24');
		}

		if (isset($this->request->post['title_text'])) {
			$this->data['title_text'] = $this->request->post['title_text'];
		} elseif ($this->config->get('ot_title_text')) { 
			$this->data['title_text'] = $this->config->get('ot_title_text');
		} else {
			$this->data['title_text'] = 'How many products will you need customized?';
		}

		

		if (isset($this->request->post['pm'])) {
			$this->data['pm'] = $this->request->post['pm'];
		} elseif ($this->config->get('ot_pm')) { 
			$this->data['pm'] = $this->config->get('ot_pm');
		} else {
			$this->data['pm'] = array();
			foreach ($this->data['printing_methods'] as $key => $value) {
				if($value['extension']=="screenprinting")
					$this->data['pm'][$value['extension']] = array('','checked');
				else
					$this->data['pm'][$value['extension']] = array('checked','');
			}
		}

		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}

 		if (isset($this->error['quantities'])) {
			$this->data['error_quantities'] = $this->error['quantities'];
		} else {
			$this->data['error_quantities'] = '';
		}

		$this->template = 'printing_method/autoselect.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}

	private function validate_autoselect() {
		if (!$this->user->hasPermission('modify', 'extension/printing_method')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if(!empty($this->request->post['enable_autoselect'])) {

			if(!isset($this->request->post['quantities']) || !is_array($this->request->post['quantities'])) {
				$this->error['quantities'] = $this->language->get('error_quantities');
			} else {
				foreach($this->request->post['quantities'] as $value) {
					if(!preg_match("/^[0-9]+$/",$value)) {
						$this->error['quantities'] = $this->language->get('error_quantities');
					}
				}
			}
			

			if ($this->error && !isset($this->error['warning'])) {
				$this->error['warning'] = $this->language->get('error_warning');
			}
					
			if (!$this->error) {
				return true;
			} else {
				return false;
			}

		} else {
			return true;
		}

	}
	
	public function install() {
		$this->load->language('extension/printing_method');
		
		if (!$this->user->hasPermission('modify', 'extension/printing_method')) {
			$this->session->data['error'] = $this->language->get('error_permission'); 
			
			$this->redirect($this->url->link('extension/printing_method', 'token=' . $this->session->data['token'], 'SSL'));
		} else {
			$this->load->model('setting/extension');
		
			$this->model_setting_extension->install('printing_method', $this->request->get['extension']);

			$this->load->model('user/user_group');
		
			$this->model_user_user_group->addPermission($this->user->getId(), 'access', 'printing_method/' . $this->request->get['extension']);
			$this->model_user_user_group->addPermission($this->user->getId(), 'modify', 'printing_method/' . $this->request->get['extension']);

			require_once(DIR_APPLICATION . 'controller/printing_method/' . $this->request->get['extension'] . '.php');
			
			$class = 'ControllerPrintingMethod' . str_replace('_', '', $this->request->get['extension']);
			$class = new $class($this->registry);
			
			if (method_exists($class, 'install')) {
				$class->install();
			}
			
			$this->redirect($this->url->link('extension/printing_method', 'token=' . $this->session->data['token'], 'SSL'));
		}
	}
	
	public function uninstall() {
		$this->load->language('extension/printing_method');
		
		if (!$this->user->hasPermission('modify', 'extension/printing_method')) {
			$this->session->data['error'] = $this->language->get('error_permission'); 
			
			$this->redirect($this->url->link('extension/printing_method', 'token=' . $this->session->data['token'], 'SSL'));
		} else {		
			$this->load->model('setting/extension');
			$this->load->model('setting/setting');
				
			$this->model_setting_extension->uninstall('printing_method', $this->request->get['extension']);
		
			$this->model_setting_setting->deleteSetting($this->request->get['extension']);
		
			require_once(DIR_APPLICATION . 'controller/printing_method/' . $this->request->get['extension'] . '.php');
			
			$class = 'ControllerPrintingMethod' . str_replace('_', '', $this->request->get['extension']);
			$class = new $class($this->registry);
			
			if (method_exists($class, 'uninstall')) {
				$class->uninstall();
			}
		
			$this->redirect($this->url->link('extension/printing_method', 'token=' . $this->session->data['token'], 'SSL'));	
		}			
	}
}
?>