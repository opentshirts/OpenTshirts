<?php
class ControllerProductSize extends Controller {
	private $error = array();

  	public function index() {

    	$this->getList();
  	}
	
  	public function _list() {

    	$this->getList();
  	}
	
  	public function insert() {
		$this->load->language('product/size/form');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('product/size');
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
      	  	
			$id_product_size = $this->model_product_size->addSize($this->request->post);
						
			$this->session->data['success'] = $this->language->get('text_success');
		  
			$url = '';
			
			if (isset($this->request->get['filter_id_product_size'])) {
				$url .= '&filter_id_product_size=' . $this->request->get['filter_id_product_size'];
			}
			
			if (isset($this->request->get['filter_apply_additional_cost'])) {
				$url .= '&filter_apply_additional_cost=' . $this->request->get['filter_apply_additional_cost'];
			}
			
			if (isset($this->request->get['sort'])) {
				$url .= '&sort=' . $this->request->get['sort'];
			}
	
			if (isset($this->request->get['order'])) {
				$url .= '&order=' . $this->request->get['order'];
			}
			
			if (isset($this->request->get['page'])) {
				$url .= '&page=' . $this->request->get['page'];
			}

			if (isset($this->request->get['limit'])) {
				$url .= '&limit=' . $this->request->get['limit'];
			}

			$this->redirect($this->url->link('product/size/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
		
    	$this->getForm();
  	}
	
  	public function update() {
		
		$this->load->language('product/size/form');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('product/size');
		    	
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			
			$this->model_product_size->editSize($this->request->get['id_product_size'], $this->request->post);
	  		
			$this->session->data['success'] = $this->language->get('text_success');
	  
			$url = '';
			
			if (isset($this->request->get['filter_id_product_size'])) {
				$url .= '&filter_id_product_size=' . $this->request->get['filter_id_product_size'];
			}
			
			if (isset($this->request->get['filter_apply_additional_cost'])) {
				$url .= '&filter_apply_additional_cost=' . $this->request->get['filter_apply_additional_cost'];
			}
												
			if (isset($this->request->get['sort'])) {
				$url .= '&sort=' . $this->request->get['sort'];
			}
	
			if (isset($this->request->get['order'])) {
				$url .= '&order=' . $this->request->get['order'];
			}
			
			if (isset($this->request->get['page'])) {
				$url .= '&page=' . $this->request->get['page'];
			}

			if (isset($this->request->get['limit'])) {
				$url .= '&limit=' . $this->request->get['limit'];
			}

			$this->redirect($this->url->link('product/size/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
		
    	$this->getForm();
  	}
	
  	public function delete() {
		
		$this->load->language('product/size/form');

		if (isset($this->request->post['selected']) && $this->validateDelete()) {
			
			$this->load->model('product/size');
			
			foreach ($this->request->post['selected'] as $id_product_size) {
				$this->model_product_size->deleteSize($id_product_size);
			}

			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';
			
			if (isset($this->request->get['filter_id_product_size'])) {
				$url .= '&filter_id_product_size=' . $this->request->get['filter_id_product_size'];
			}
			
			if (isset($this->request->get['filter_apply_additional_cost'])) {
				$url .= '&filter_apply_additional_cost=' . $this->request->get['filter_apply_additional_cost'];
			}
												
			if (isset($this->request->get['sort'])) {
				$url .= '&sort=' . $this->request->get['sort'];
			}
	
			if (isset($this->request->get['order'])) {
				$url .= '&order=' . $this->request->get['order'];
			}
			
			if (isset($this->request->get['page'])) {
				$url .= '&page=' . $this->request->get['page'];
			}

			if (isset($this->request->get['limit'])) {
				$url .= '&limit=' . $this->request->get['limit'];
			}

			$this->redirect($this->url->link('product/size/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
		$this->getList();
  	}
  	public function sorting() {
		
		$this->load->language('product/size/form');

		if (isset($this->request->post['sorting'])) {
			
			$this->load->model('product/size');
			
			$this->model_product_size->saveOrder($this->request->post['sorting']); 

			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';
			
			if (isset($this->request->get['filter_id_product_size'])) {
				$url .= '&filter_id_product_size=' . $this->request->get['filter_id_product_size'];
			}
			
			if (isset($this->request->get['filter_apply_additional_cost'])) {
				$url .= '&filter_apply_additional_cost=' . $this->request->get['filter_apply_additional_cost'];
			}
												
			if (isset($this->request->get['sort'])) {
				$url .= '&sort=' . $this->request->get['sort'];
			}
	
			if (isset($this->request->get['order'])) {
				$url .= '&order=' . $this->request->get['order'];
			}
			
			if (isset($this->request->get['page'])) {
				$url .= '&page=' . $this->request->get['page'];
			}

			if (isset($this->request->get['limit'])) {
				$url .= '&limit=' . $this->request->get['limit'];
			}

			$this->redirect($this->url->link('product/size/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
		$this->getList();
  	}

  	private function getList() {
		
		$this->load->language('product/size/list');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('product/size');

		$filters = array();
		
		if (isset($this->request->get['filter_id_product_size'])) {
			$filter_id_product_size = $this->request->get['filter_id_product_size'];
			$filters['filter_id_product_size'] = $filter_id_product_size;
		} else {
			$filter_id_product_size = null;
		}

		if (isset($this->request->get['filter_apply_additional_cost'])) {
			$filter_apply_additional_cost = $this->request->get['filter_apply_additional_cost'];
			$filters['filter_apply_additional_cost'] = $filter_apply_additional_cost;
		} else {
			$filter_apply_additional_cost = null;
		}

		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = 'sort';
		}
		$filters['sort'] = $sort;

		if (isset($this->request->get['order'])) {
			$order = $this->request->get['order'];
		} else {
			$order = 'ASC';
		}
		$filters['order'] = $order;
		
		if (isset($this->request->get['page'])) {
			$page = $this->request->get['page'];
		} else {
			$page = 1;
		}
		
		if (isset($this->request->get['limit'])) {
			$limit = $this->request->get['limit'];
		} else {
			$limit =  99999999;
		}
		$filters['start'] = ($page - 1) * $limit;
		$filters['limit'] = $limit;
					
		$url = '';

		if (isset($this->request->get['filter_id_product_size'])) {
			$url .= '&filter_id_product_size=' . $this->request->get['filter_id_product_size'];
		}
		
		if (isset($this->request->get['filter_apply_additional_cost'])) {
			$url .= '&filter_apply_additional_cost=' . $this->request->get['filter_apply_additional_cost'];
		}

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}
		
		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		if (isset($this->request->get['limit'])) {
			$url .= '&limit=' . $this->request->get['limit'];
		}

  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
			'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('product/size/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'),
			'separator' => ' :: '
   		);

		$this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['column_id_product_size'] = $this->language->get('column_id_product_size');
		$this->data['column_description'] = $this->language->get('column_description');
    	$this->data['column_initials'] = $this->language->get('column_initials');
    	$this->data['column_apply_additional_cost'] = $this->language->get('column_apply_additional_cost');
		$this->data['column_sort'] = $this->language->get('column_sort');
		$this->data['column_action'] = $this->language->get('column_action');
		$this->data['text_no_results'] = $this->language->get('text_no_results');
		$this->data['text_limit'] = $this->language->get('text_limit');
		
		$this->data['button_delete'] = $this->language->get('button_delete');
		$this->data['button_save_order'] = $this->language->get('button_save_order');
		$this->data['button_insert'] = $this->language->get('button_add_size');
		
		$this->data['delete'] = $this->url->link('product/size/delete', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['save_order'] = $this->url->link('product/size/sorting', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['insert'] = $this->url->link('product/size/insert', 'token=' . $this->session->data['token'] . $url, 'SSL');

		$this->data['token'] = $this->session->data['token'];

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

		$url = '';

		if (isset($this->request->get['filter_id_product_size'])) {
			$url .= '&filter_id_product_size=' . $this->request->get['filter_id_product_size'];
		}
		
		if (isset($this->request->get['filter_apply_additional_cost'])) {
			$url .= '&filter_apply_additional_cost=' . $this->request->get['filter_apply_additional_cost'];
		}
		
		if ($order == 'ASC') {
			$url .= '&order=' .  'DESC';
		} else {
			$url .= '&order=' .  'ASC';
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}
		
		if (isset($this->request->get['limit'])) {
			$url .= '&limit=' . $this->request->get['limit'];
		}

		$this->data['sort_description'] = $this->url->link('product/size/_list', 'token=' . $this->session->data['token'] . '&sort=description' . $url, 'SSL');
		$this->data['sort_sort'] = $this->url->link('product/size/_list', 'token=' . $this->session->data['token'] . '&sort=sort' . $url, 'SSL');
		$this->data['sort_apply_additional_cost'] = $this->url->link('product/size/_list', 'token=' . $this->session->data['token'] . '&sort=apply_additional_cost' . $url, 'SSL');

		$url = '';

		if (isset($this->request->get['filter_id_product_size'])) {
			$url .= '&filter_id_product_size=' . $this->request->get['filter_id_product_size'];
		}
		
		if (isset($this->request->get['filter_apply_additional_cost'])) {
			$url .= '&filter_apply_additional_cost=' . $this->request->get['filter_apply_additional_cost'];
		}

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}
		
		if (isset($this->request->get['limit'])) {
			$url .= '&limit=' . $this->request->get['limit'];
		}
		
		$this->data['sizes'] = array();

		$size_total = $this->model_product_size->getTotalSizes($filters);

		$results = $this->model_product_size->getSizes($filters);
		
    	foreach ($results as $result) {
			$action = array();
						
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => $this->url->link('product/size/update', 'token=' . $this->session->data['token'] . '&id_product_size=' . $result['id_product_size'] . $url, 'SSL')
			);
			
			
			$this->data['sizes'][] = array(
				'id_product_size'    => $result['id_product_size'],
				'description'      	=> $result['description'],
				'initials'      	=> $result['initials'],
				'sort'      	=> $result['sort'],
				'apply_additional_cost'      	=> ($result['apply_additional_cost'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled')),
				'selected'      => isset($this->request->post['selected']) && in_array($result['id_product_size'], $this->request->post['selected']),
				'action'        => $action
			);
		}

		$pagination = new Pagination();
		$pagination->total = $size_total;
		$pagination->page = $page;
		$pagination->limit = $limit;
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = $this->url->link('product/size/_list', 'token=' . $this->session->data['token'] . $url . '&page={page}', 'SSL');

		$this->data['pagination'] = $pagination->render();

		$this->data['filter_id_product_size'] = $filter_id_product_size;
		$this->data['filter_apply_additional_cost'] = $filter_apply_additional_cost;
		$this->data['sort'] = $sort;
		$this->data['order'] = $order;
		$this->data['limit'] = $limit;
		
		
		$this->data['apply_additional_cost_status'] = array();
		$this->data['apply_additional_cost_status'][] = array('val'=>'', 'description'=>$this->language->get('text_none'));
		$this->data['apply_additional_cost_status'][] = array('val'=>'1', 'description'=>$this->language->get('text_enabled'));
		$this->data['apply_additional_cost_status'][] = array('val'=>'0', 'description'=>$this->language->get('text_disabled'));


		$this->template = 'product/size/list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}

  	private function getForm() {
		
		$this->data['heading_title'] = $this->language->get('heading_title');
		 
		$this->data['entry_description'] = $this->language->get('entry_description');
		$this->data['entry_initials'] = $this->language->get('entry_initials');
		$this->data['entry_upcharge'] = $this->language->get('entry_upcharge');

		$this->data['tab_data'] = $this->language->get('tab_data');
			
		$this->data['button_save'] = $this->language->get('button_save');
		$this->data['button_cancel'] = $this->language->get('button_cancel');

		$this->data['token'] = $this->session->data['token'];

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
		
 		if (isset($this->error['description'])) {
			$this->data['error_description'] = $this->error['description'];
		} else {
			$this->data['error_description'] = '';
		}
				
 		if (isset($this->error['initials'])) {
			$this->data['error_initials'] = $this->error['initials'];
		} else {
			$this->data['error_initials'] = '';
		}
				
		$url = '';

		if (isset($this->request->get['filter_id_product_size'])) {
			$url .= '&filter_id_product_size=' . $this->request->get['filter_id_product_size'];
		}
		
		if (isset($this->request->get['filter_apply_additional_cost'])) {
			$url .= '&filter_apply_additional_cost=' . $this->request->get['filter_apply_additional_cost'];
		}

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}
		
		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		$this->data['breadcrumbs'] = array();

		$this->data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
			'separator' => false
		);
		
		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_product_size_list'),
			'href'      => $this->url->link('product/size/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);


		if (!isset($this->request->get['id_product_size'])) {
			$this->data['action'] = $this->url->link('product/size/insert', 'token=' . $this->session->data['token'] . $url, 'SSL');
			$this->data['breadcrumbs'][] = array(
				'text'      => $this->language->get('heading_title'),
				'href'      => $this->url->link('product/size/insert', 'token=' . $this->session->data['token'] . $url, 'SSL'),				
				'separator' => ' :: '
			);
		
		} else {
			$this->data['action'] = $this->url->link('product/size/update', 'token=' . $this->session->data['token'] . '&id_product_size=' . $this->request->get['id_product_size'] . $url, 'SSL');
			$this->data['breadcrumbs'][] = array(
				'text'      => $this->language->get('heading_title'),
				'href'      => $this->url->link('product/size/update', 'token=' . $this->session->data['token'] . '&id_product_size=' . $this->request->get['id_product_size'] . $url, 'SSL'),				
				'separator' => ' :: '
			);
		
		}
		
		$this->data['cancel'] = $this->url->link('product/size/_list', 'token=' . $this->session->data['token'] . $url, 'SSL');
		
		if (isset($this->request->get['id_product_size']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			
			$size = $this->model_product_size->getSize($this->request->get['id_product_size']);	
			
			$size_info = array(
				'id_product_size'	=> $size['id_product_size'],
				'description'      	=> $size['description'],
				'initials'      	=> $size['initials'],
				'apply_additional_cost'      	=> $size['apply_additional_cost']
			);
		}
		
		if (isset($this->request->post['description'])) {
			$this->data['description'] = $this->request->post['description'];
		} elseif (!empty($size_info)) {
			$this->data['description'] = $size_info['description'];
		} else {
			$this->data['description'] = '';
		}
		
		if (isset($this->request->post['initials'])) {
			$this->data['initials'] = $this->request->post['initials'];
		} elseif (!empty($size_info)) {
			$this->data['initials'] = $size_info['initials'];
		} else {
			$this->data['initials'] = '';
		}
		
		if (isset($this->request->post['apply_additional_cost'])) {
			$this->data['apply_additional_cost'] = $this->request->post['apply_additional_cost'];
		} elseif (!empty($size_info)) {
			$this->data['apply_additional_cost'] = $size_info['apply_additional_cost'];
		} else {
			$this->data['apply_additional_cost'] = '0';
		}

		$this->data['apply_additional_cost_status'] = array();
		$this->data['apply_additional_cost_status'][] = array('val'=>'1', 'description'=>$this->language->get('text_enabled'));
		$this->data['apply_additional_cost_status'][] = array('val'=>'0', 'description'=>$this->language->get('text_disabled'));

		$this->template = 'product/size/form.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}
	
	
  	private function validateForm() {
		if (!$this->user->hasPermission('modify', 'product/size')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
 
		if ((utf8_strlen($this->request->post['description']) < 1) || (utf8_strlen($this->request->post['description']) > 255)) {
			$this->error['description'] = $this->language->get('error_description');
		}
		
		if ((utf8_strlen($this->request->post['initials']) < 1) || (utf8_strlen($this->request->post['initials']) > 10)) {
			$this->error['initials'] = $this->language->get('error_initials');
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
		if (!$this->user->hasPermission('modify', 'product/size')) {
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