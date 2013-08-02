<?php 
class ControllerPrintingMethodScreenprinting extends Controller {
	private $error = array(); 
	 
	public function index() { 
		$this->load->language('printing_method/screenprinting');

		$this->document->setTitle($this->language->get('heading_title'));
		
		$this->load->model('setting/setting');
				
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			$this->model_setting_setting->editSetting('screenprinting', $this->request->post['data']);

			$this->load->model('printing_method/screenprinting');
			
			$this->model_printing_method_screenprinting->savePrice($this->request->post);

			$this->session->data['success'] = $this->language->get('text_success');
			
			$this->redirect($this->url->link('extension/printing_method', 'token=' . $this->session->data['token'], 'SSL'));
		}
		
		$this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['text_enabled'] = $this->language->get('text_enabled');
		$this->data['text_disabled'] = $this->language->get('text_disabled');

		$this->data['text_price_tab'] = $this->language->get('text_price_tab');
		$this->data['text_colors_tab'] = $this->language->get('text_colors_tab');

		$this->data['entry_description'] = $this->language->get('entry_description');
		$this->data['entry_status'] = $this->language->get('entry_status');
		$this->data['entry_sort_order'] = $this->language->get('entry_sort_order');
		
		$this->data['button_save'] = $this->language->get('button_save');
		$this->data['button_cancel'] = $this->language->get('button_cancel');		

  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      =>  $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_printing_method'),
			'href'      => $this->url->link('extension/printing_method', 'token=' . $this->session->data['token'], 'SSL'),       		
      		'separator' => ' :: '
   		);
		
   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('printing_method/screenprinting', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);
		
		$this->data['action'] = $this->url->link('printing_method/screenprinting', 'token=' . $this->session->data['token'], 'SSL');

		$this->data['cancel'] = $this->url->link('extension/printing_method', 'token=' . $this->session->data['token'], 'SSL');	
				
		if (isset($this->request->post['data']['screenprinting_status'])) {
			$this->data['data']['screenprinting_status'] = $this->request->post['data']['screenprinting_status'];
		} else {
			$this->data['data']['screenprinting_status'] = $this->config->get('screenprinting_status');
		}
		
		if (isset($this->request->post['data']['screenprinting_sort_order'])) {
			$this->data['data']['screenprinting_sort_order'] = $this->request->post['data']['screenprinting_sort_order'];
		} else {
			$this->data['data']['screenprinting_sort_order'] = $this->config->get('screenprinting_sort_order');
		}

		if (isset($this->request->post['data']['screenprinting_description'])) {
			$this->data['data']['screenprinting_description'] = $this->request->post['data']['screenprinting_description'];
		} elseif ($this->config->get('screenprinting_description')) {
			$this->data['data']['screenprinting_description'] = $this->config->get('screenprinting_description');
		} else {
			$this->data['data']['screenprinting_description'] = $this->language->get('default_description');
		}

		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}

		if (isset($this->session->data['success'])) {
			$this->data['success'] = $this->session->data['success'];

			unset($this->session->data['success']);
		} else {
			$this->data['success'] = '';
		}
						
		$this->template = 'printing_method/screenprinting.tpl';
		$this->children = array(
			'common/header',
			'printing_method/screenprinting/price_tab',
			'printing_method/screenprinting/colors_tab',
			'common/footer'
		);
			
		$this->response->setOutput($this->render());
	}

	public function price_tab() {

		$this->load->language('printing_method/screenprinting');

		$this->load->model('printing_method/screenprinting');

		$price = $this->model_printing_method_screenprinting->getPrice();
		$quantities = $this->model_printing_method_screenprinting->getQuantities();
		$max_colors = $this->model_printing_method_screenprinting->getMaxColors();
		$screen_charges = $this->model_printing_method_screenprinting->getScreenCharges();
		
		$this->data['text_add_quantity'] = $this->language->get('text_add_quantity');
		
		$this->data['symbol_right'] = $this->currency->getSymbolRight();
		$this->data['symbol_left'] = $this->currency->getSymbolLeft();
		$this->data['text_minimum_quantity'] = $this->language->get('text_minimum_quantity');
		$this->data['text_increment'] = $this->language->get('text_increment');
		$this->data['text_colors'] = $this->language->get('text_colors');
		$this->data['text_max_colors'] = $this->language->get('text_max_colors');
		$this->data['text_screen_charge'] = $this->language->get('text_screen_charge');
		$this->data['text_max_colors_help'] = $this->language->get('text_max_colors_help');
		

		if (isset($this->request->post['quantities'])) {
			$this->data['quantities'] = $this->request->post['quantities'];
		} elseif (!empty($quantities)) { 
			$this->data['quantities'] = $quantities;
		} else {
			$this->data['quantities'] = array('0','50');
		}

		if (isset($this->request->post['screen_charges'])) {
			$this->data['screen_charges'] = $this->request->post['screen_charges'];
		} elseif (!empty($screen_charges)) { 
			$this->data['screen_charges'] = $screen_charges;
		} else {
			$this->data['screen_charges'] = array('8','6');
		}
		
		if (isset($this->request->post['price'])) {
			$this->data['price'] = $this->request->post['price'];
		} elseif (!empty($price)) { 
			$this->data['price'] = $price;
		} else {
			$this->data['price'] = array();
			$this->data['price'][1][0] = 0.5;
			$this->data['price'][1][1] = 0.45;
			$this->data['price'][2][0] = 0.9;
			$this->data['price'][2][1] = 0.85;
		}
		
		if (isset($this->request->post['max_colors'])) {
			$this->data['max_colors'] = $this->request->post['max_colors'];
		} elseif (!empty($max_colors)) { 
			$this->data['max_colors'] = $max_colors;
		} else {
			$this->data['max_colors'] = 2;
		}

		if (isset($this->session->data['error_quantities'])) {
			$this->data['error_quantities'] = $this->session->data['error_quantities'];

			unset($this->session->data['error_quantities']);
		} else {
			$this->data['error_quantities'] = '';
		}

		if (isset($this->session->data['error_screen_charges'])) {
			$this->data['error_screen_charges'] = $this->session->data['error_screen_charges'];

			unset($this->session->data['error_screen_charges']);
		} else {
			$this->data['error_screen_charges'] = '';
		}

		if (isset($this->session->data['error_price'])) {
			$this->data['error_price'] = $this->session->data['error_price'];

			unset($this->session->data['error_price']);
		} else {
			$this->data['error_price'] = '';
		}
		
		$this->data['printing_colors_limit'] = ($this->config->get('printing_colors_limit'))?$this->config->get('printing_colors_limit'):5;


		$this->template = 'printing_method/screenprinting_price.tpl';
			
		$this->response->setOutput($this->render());

	}

	public function colors_tab() {

		$this->load->language('printing_method/screenprinting');
		
		$this->load->language('design_color/list');

		$this->load->model('design_color/design_color');

		$filters = array();
		$filters['sort'] = 'sort';
		$filters['order'] = 'ASC';
		

		$this->data['column_id_design_color'] = $this->language->get('column_id_design_color');
		$this->data['column_name'] = $this->language->get('column_name');
    	$this->data['column_need_white_base'] = $this->language->get('column_need_white_base');
    	$this->data['column_hexa'] = $this->language->get('column_hexa');
    	$this->data['column_code'] = $this->language->get('column_code');
    	$this->data['column_sort'] = $this->language->get('column_sort');
		$this->data['column_status'] = $this->language->get('column_status');
		$this->data['text_no_results'] = $this->language->get('text_no_results');
		$this->data['text_default'] = $this->language->get('text_default');

		$this->data['text_help_colors'] = $this->language->get('text_help_colors');

		if (isset($this->request->post['data']['screenprinting_colors'])) {
			$this->data['data']['screenprinting_colors'] = $this->request->post['data']['screenprinting_colors'];
		} elseif ($this->config->get('screenprinting_colors')) {
			$this->data['data']['screenprinting_colors'] = $this->config->get('screenprinting_colors');
		} else {
			$this->data['data']['screenprinting_colors'] = array();
		}
		
		
		$this->data['colors'] = array();

		$color_total = $this->model_design_color_design_color->getTotalColors($filters);

		$results = $this->model_design_color_design_color->getColors($filters);
		
    	foreach ($results as $result) {
			$this->data['colors'][] = array(
				'id_design_color'    => $result['id_design_color'],
				'name'      	=> $result['name'],
				'code'      	=> $result['code'],
				'isdefault'      	=> $result['isdefault'],
				'status'      	=> ($result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled')),
				'need_white_base'      	=> ($result['need_white_base'] ? $this->language->get('text_yes') : $this->language->get('text_no')),
				'hexa'      	=> $result['hexa'],
				'sort'      	=> $result['sort'],
				'selected'      => in_array($result['id_design_color'], $this->data['data']['screenprinting_colors'])
			);
		}



		$this->template = 'printing_method/screenprinting_colors.tpl';
			
		$this->response->setOutput($this->render());

	}
	
	private function validate() {

		if (!$this->user->hasPermission('modify', 'printing_method/screenprinting')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if(!isset($this->request->post['quantities']) || !is_array($this->request->post['quantities'])) {
			$this->error['error_quantities'] = $this->language->get('error_quantities');
		} else {
			foreach($this->request->post['quantities'] as $value) {
				if(!preg_match("/^[0-9]+$/",$value)) {
					$this->error['error_quantities'] = $this->language->get('error_quantities');
					$this->session->data['error_quantities'] = $this->language->get('error_quantities');
				}
			}
		}

		if(!isset($this->request->post['screen_charges']) || !is_array($this->request->post['screen_charges'])) {
			$this->error['error_screen_charges'] = $this->language->get('error_screen_charges');
		} else {
			foreach($this->request->post['screen_charges'] as $value) {
				if(!preg_match("/^[0-9]+(.[0-9]+)?$/",$value)) {
					$this->error['error_screen_charges'] = $this->language->get('error_screen_charges');
					$this->session->data['error_screen_charges'] = $this->language->get('error_screen_charges');
				}
			}
		}
		
		if(!isset($this->request->post['price']) || !is_array($this->request->post['price'])) {
			$this->error['error_price'] = $this->language->get('error_price');
		} else {
			foreach($this->request->post['price'] as $prices) {
				foreach($prices as $value) {
					if(!preg_match("/^[0-9]+(.[0-9]+)?$/",$value)) {
						$this->error['error_price'] = $this->language->get('error_price');
						$this->session->data['error_price'] = $this->language->get('error_price');
					}
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
	}

	public function install() {

		$this->load->model('printing_method/screenprinting');
		
		$this->model_printing_method_screenprinting->install();

	}

	public function uninstall() {

		$this->load->model('printing_method/screenprinting');
		
		$this->model_printing_method_screenprinting->uninstall();

	}
}
?>