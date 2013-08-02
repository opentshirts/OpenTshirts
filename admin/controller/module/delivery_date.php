<?php
class ControllerModuleDeliveryDate extends Controller {
	private $error = array(); 
	
	public function index() {   
		$this->load->language('module/delivery_date');

		$this->document->setTitle($this->language->get('heading_title'));
		
		$this->load->model('setting/setting');
				
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			$this->model_setting_setting->editSetting('delivery_date', $this->request->post);
			
			$this->session->data['success'] = $this->language->get('text_success');
						
			$this->redirect($this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'));
		}
				
		$this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['text_enabled'] = $this->language->get('text_enabled');
		$this->data['text_disabled'] = $this->language->get('text_disabled');
		$this->data['text_content_top'] = $this->language->get('text_content_top');
		$this->data['text_content_bottom'] = $this->language->get('text_content_bottom');		
		$this->data['text_column_left'] = $this->language->get('text_column_left');
		$this->data['text_column_right'] = $this->language->get('text_column_right');
		$this->data['text_sunday'] = $this->language->get('text_sunday');
		$this->data['text_saturday'] = $this->language->get('text_saturday');
		$this->data['text_monday'] = $this->language->get('text_monday');
		$this->data['text_tuesday'] = $this->language->get('text_tuesday');
		$this->data['text_wednesday'] = $this->language->get('text_wednesday');
		$this->data['text_thursday'] = $this->language->get('text_thursday');
		$this->data['text_friday'] = $this->language->get('text_friday');
		$this->data['text_holiday'] = $this->language->get('text_holiday');
		
		$this->data['entry_skip_days'] = $this->language->get('entry_skip_days');
		$this->data['entry_shipping_link'] = $this->language->get('entry_shipping_link');
		$this->data['entry_days_rush'] = $this->language->get('entry_days_rush');
		$this->data['entry_days_free'] = $this->language->get('entry_days_free');
		$this->data['entry_layout'] = $this->language->get('entry_layout');
		$this->data['entry_position'] = $this->language->get('entry_position');
		$this->data['entry_status'] = $this->language->get('entry_status');
		$this->data['entry_sort_order'] = $this->language->get('entry_sort_order');
		$this->data['entry_holiday_day'] = $this->language->get('entry_holiday_day');
		$this->data['entry_holiday_month'] = $this->language->get('entry_holiday_month');
		$this->data['entry_reason'] = $this->language->get('entry_reason');
		$this->data['entry_rush_title'] = $this->language->get('entry_rush_title');
		$this->data['entry_free_title'] = $this->language->get('entry_free_title');
		
		$this->data['button_save'] = $this->language->get('button_save');
		$this->data['button_cancel'] = $this->language->get('button_cancel');
		$this->data['button_add_module'] = $this->language->get('button_add_module');
		$this->data['button_remove'] = $this->language->get('button_remove');
		
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
			'href'      => $this->url->link('module/delivery_date', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);
		
		$this->data['action'] = $this->url->link('module/delivery_date', 'token=' . $this->session->data['token'], 'SSL');
		
		$this->data['cancel'] = $this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL');

		$this->data['modules'] = array();
		
		if (isset($this->request->post['delivery_date_module'])) {
			$this->data['modules'] = $this->request->post['delivery_date_module'];
		} elseif ($this->config->get('delivery_date_module')) { 
			$this->data['modules'] = $this->config->get('delivery_date_module');
		}

		$this->data['delivery_date_skip'] = array();
		if (isset($this->request->post['delivery_date_skip'])) {
			$this->data['delivery_date_skip'] = $this->request->post['delivery_date_skip'];
		} elseif ($this->config->get('delivery_date_skip')) { 
			$this->data['delivery_date_skip'] = $this->config->get('delivery_date_skip');
		}
		
		$this->data['delivery_date_holidays'] = array();
		if (isset($this->request->post['delivery_date_holidays'])) {
			$this->data['delivery_date_holidays'] = $this->request->post['delivery_date_holidays'];
		} elseif ($this->config->get('delivery_date_holidays')) { 
			$this->data['delivery_date_holidays'] = $this->config->get('delivery_date_holidays');
		}

		
		if (isset($this->request->post['delivery_date_rush_title'])) {
			$this->data['delivery_date_rush_title'] = $this->request->post['delivery_date_rush_title'];
		} elseif ($this->config->get('delivery_date_rush_title')) { 
			$this->data['delivery_date_rush_title'] = $this->config->get('delivery_date_rush_title');
		} else {
			$this->data['delivery_date_rush_title'] = '<b><i>Rush</i></b> Shipping by';
		}

		if (isset($this->request->post['delivery_date_free_title'])) {
			$this->data['delivery_date_free_title'] = $this->request->post['delivery_date_free_title'];
		} elseif ($this->config->get('delivery_date_free_title')) { 
			$this->data['delivery_date_free_title'] = $this->config->get('delivery_date_free_title');
		} else {
			$this->data['delivery_date_free_title'] = '<b><i>Free</i></b> Shipping by';
		}
						
		$this->load->model('design/layout');
		
		$this->data['layouts'] = $this->model_design_layout->getLayouts();

		$this->template = 'module/delivery_date.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}
	
	private function validate() {
		if (!$this->user->hasPermission('modify', 'module/delivery_date')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}	
						
		if (!$this->error) {
			return true;
		} else {
			return false;
		}	
	}
}
?>