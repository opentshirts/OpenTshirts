<?php
class ControllerProductManufacturer extends Controller {
	private $error = array();

  	public function index() {

    	$this->getList();
  	}
	
	public function insert() {
		$this->load->language('product/manufacturer');
		
		$this->load->model('product/manufacturer');
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			$this->model_product_manufacturer->addManufacturer($this->request->post);

			$this->session->data['success'] = $this->language->get('text_success');
			
			$this->redirect($this->url->link('product/manufacturer', 'token=' . $this->session->data['token'], 'SSL')); 
		}

		$this->getForm();
	}

	public function update() {
		$this->load->language('product/manufacturer');
		
		$this->load->model('product/manufacturer');
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			$this->model_product_manufacturer->editManufacturer($this->request->get['id_manufacturer'], $this->request->post);
			
			$this->session->data['success'] = $this->language->get('text_success');
			
			$this->redirect($this->url->link('product/manufacturer', 'token=' . $this->session->data['token'], 'SSL'));
		}

		$this->getForm();
	}

	public function delete() {
		$this->load->language('product/manufacturer');
		
		$this->load->model('product/manufacturer');
		
		if (isset($this->request->post['selected']) && $this->validateDelete()) {
			foreach ($this->request->post['selected'] as $id_manufacturer) {
				$this->model_product_manufacturer->deleteManufacturer($id_manufacturer);
			}

			$this->session->data['success'] = $this->language->get('text_success');

			$this->redirect($this->url->link('product/manufacturer', 'token=' . $this->session->data['token'], 'SSL'));
		}

		$this->getList();
	}
	
	private function getList() {
		$this->load->language('product/manufacturer');
		
		$this->load->model('product/manufacturer');
		
		$this->document->setTitle($this->language->get('heading_title'));
		
		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_product_administration'),
			'href'      => $this->url->link('product/product', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('product/manufacturer', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);


		if (isset($this->request->post['selected'])) {
			$this->data['selected'] = $this->request->post['selected'];
		} else {
			$this->data['selected'] = array();
		}
		
		$results = $this->model_product_manufacturer->getManufacturers();
		$this->data['manufacturers'] = array();
		foreach ($results as $result) {
			$action = array();
						
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => $this->url->link('product/manufacturer/update', 'token=' . $this->session->data['token'] . '&id_manufacturer=' . $result['id_manufacturer'] , 'SSL')
			);

			$this->data['manufacturers'][] = array(
				'id_manufacturer'    => $result['id_manufacturer'],
				'name'      	=> $result['name'],
				'selected'      => isset($this->request->post['selected']) && in_array($result['id_manufacturer'], $this->request->post['selected']),
				'action'        => $action
			);
		}

		
		$this->data['delete'] = $this->url->link('product/manufacturer/delete', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['add_manufacturer'] = $this->url->link('product/manufacturer/insert', 'token=' . $this->session->data['token'] , 'SSL');
		
		$this->data['column_name'] = $this->language->get('column_name');
		$this->data['column_action'] = $this->language->get('column_action');
		$this->data['button_delete'] = $this->language->get('button_delete');
		$this->data['button_add_manufacturer'] = $this->language->get('button_add_manufacturer');
		$this->data['text_no_results'] = $this->language->get('text_no_results');

		
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

		$this->data['token'] = $this->session->data['token'];

		$this->template = 'product/manufacturer/list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
		
	}
		
	private function getForm() {
		$this->load->language('product/manufacturer');
		
		$this->load->model('product/manufacturer');
		
		$this->document->setTitle($this->language->get('heading_title'));
		
		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_product_administration'),
			'href'      => $this->url->link('product/product', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('product/manufacturer', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);

		$this->data['entry_name'] = $this->language->get('entry_name');
		
		$this->data['button_save'] = $this->language->get('button_save');
		$this->data['button_cancel'] = $this->language->get('button_cancel');
		
 		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}
	
 		if (isset($this->error['name'])) {
			$this->data['error_name'] = $this->error['name'];
		} else {
			$this->data['error_name'] = '';
		}

		
		if (!isset($this->request->get['id_manufacturer'])) {
			$this->data['action'] = $this->url->link('product/manufacturer/insert', 'token=' . $this->session->data['token'], 'SSL');
		} else {
			$this->data['action'] = $this->url->link('product/manufacturer/update', 'token=' . $this->session->data['token'] . '&id_manufacturer=' . $this->request->get['id_manufacturer'], 'SSL');
		}
		
		$this->data['cancel'] = $this->url->link('product/manufacturer', 'token=' . $this->session->data['token'], 'SSL');

		$this->data['token'] = $this->session->data['token'];

		if (isset($this->request->get['id_manufacturer']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
      		$manufacturer_info = $this->model_product_manufacturer->getManufacturer($this->request->get['id_manufacturer']);
    	}
		

		if (isset($this->request->post['name'])) {
			$this->data['name'] = $this->request->post['name'];
		} elseif (!empty($manufacturer_info)) {
			$this->data['name'] = $manufacturer_info['name'];
		} else {
			$this->data['name'] = '';
		}
						
		$this->template = 'product/manufacturer/form.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}

	private function validateForm() {
		if (!$this->user->hasPermission('modify', 'product/manufacturer')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
		
		if ((utf8_strlen($this->request->post['name']) < 2) || (utf8_strlen($this->request->post['name']) > 255)) {
			$this->error['name'] = $this->language->get('error_name');
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

	private function validateDelete() {
		if (!$this->user->hasPermission('modify', 'product/manufacturer')) {
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