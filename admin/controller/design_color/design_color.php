<?php
class ControllerDesignColorDesignColor extends Controller {
	private $error = array();

  	public function index() {

    	$this->getList();
  	}
	
  	public function _list() {

    	$this->getList();
  	}

  	public function insert() {
		$this->load->language('design_color/form');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('design_color/design_color');
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
      	  	
			$this->model_design_color_design_color->addColor($this->request->post);
						
			$this->session->data['success'] = $this->language->get('text_success');
		  
			$url = '';
			
			if (isset($this->request->get['filter_id_design_color'])) {
				$url .= '&filter_id_design_color=' . $this->request->get['filter_id_design_color'];
			}
			
			if (isset($this->request->get['filter_code'])) {
				$url .= '&filter_code=' . $this->request->get['filter_code'];
			}
			
			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
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

			$this->redirect($this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
		
    	$this->getForm();
  	}
	
  	public function update() {
		
		$this->load->language('design_color/form');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('design_color/design_color');
		    	
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			
			$this->model_design_color_design_color->editColor($this->request->get['id_design_color'], $this->request->post);
	  		
			$this->session->data['success'] = $this->language->get('text_success');
	  
			$url = '';
			
			if (isset($this->request->get['filter_id_design_color'])) {
				$url .= '&filter_id_design_color=' . $this->request->get['filter_id_design_color'];
			}
			
			if (isset($this->request->get['filter_code'])) {
				$url .= '&filter_code=' . $this->request->get['filter_code'];
			}
			
			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
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

			$this->redirect($this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
		
    	$this->getForm();
  	}
	
  	public function delete() {
		
		$this->load->language('design_color/form');

		if (isset($this->request->post['selected']) && $this->validateDelete()) {
			
			$this->load->model('design_color/design_color');
			
			foreach ($this->request->post['selected'] as $id_design_color) {
				$this->model_design_color_design_color->deleteColor($id_design_color);
			}

			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';
			
			if (isset($this->request->get['filter_id_design_color'])) {
				$url .= '&filter_id_design_color=' . $this->request->get['filter_id_design_color'];
			}
			
			if (isset($this->request->get['filter_code'])) {
				$url .= '&filter_code=' . $this->request->get['filter_code'];
			}
			
			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
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

			$this->redirect($this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
		$this->getList();
  	}
  	public function sorting() {
		
		$this->load->language('design_color/form');

		if (isset($this->request->post['sorting'])) {
			
			$this->load->model('design_color/design_color');
			
			$this->model_design_color_design_color->saveOrder($this->request->post['sorting']); 

			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';
			
			if (isset($this->request->get['filter_id_design_color'])) {
				$url .= '&filter_id_design_color=' . $this->request->get['filter_id_design_color'];
			}
			
			if (isset($this->request->get['filter_code'])) {
				$url .= '&filter_code=' . $this->request->get['filter_code'];
			}
			
			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
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

			$this->redirect($this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
		$this->getList();
  	}

  	private function getList() {
		
		$this->load->language('design_color/list');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('design_color/design_color');

		$filters = array();
		
		if (isset($this->request->get['filter_id_design_color'])) {
			$filter_id_design_color = $this->request->get['filter_id_design_color'];
			$filters['filter_id_design_color'] = $filter_id_design_color;
		} else {
			$filter_id_design_color = null;
		}

		if (isset($this->request->get['filter_code'])) {
			$filter_code = $this->request->get['filter_code'];
			$filters['filter_code'] = $filter_code;
		} else {
			$filter_code = null;
		}

		if (isset($this->request->get['filter_status'])) {
			$filter_status = $this->request->get['filter_status'];
			$filters['filter_status'] = $filter_status;
		} else {
			$filter_status = '';
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
			$limit =  $this->config->get('config_admin_limit');
		}
		$filters['start'] = ($page - 1) * $limit;
		$filters['limit'] = $limit;
					
		$url = '';

		if (isset($this->request->get['filter_id_design_color'])) {
			$url .= '&filter_id_design_color=' . $this->request->get['filter_id_design_color'];
		}
		
		if (isset($this->request->get['filter_code'])) {
			$url .= '&filter_code=' . $this->request->get['filter_code'];
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
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
			'href'      => $this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'),
			'separator' => ' :: '
   		);

		$this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['column_id_design_color'] = $this->language->get('column_id_design_color');
		$this->data['column_name'] = $this->language->get('column_name');
    	$this->data['column_need_white_base'] = $this->language->get('column_need_white_base');
    	$this->data['column_hexa'] = $this->language->get('column_hexa');
    	$this->data['column_code'] = $this->language->get('column_code');
    	$this->data['column_sort'] = $this->language->get('column_sort');
		$this->data['column_status'] = $this->language->get('column_status');
		$this->data['column_action'] = $this->language->get('column_action');
		$this->data['text_no_results'] = $this->language->get('text_no_results');
		$this->data['text_limit'] = $this->language->get('text_limit');
		$this->data['text_default'] = $this->language->get('text_default');
		
		$this->data['button_delete'] = $this->language->get('button_delete');
		$this->data['button_save_order'] = $this->language->get('button_save_order');
		$this->data['button_insert'] = $this->language->get('button_add_color');
		
		$this->data['delete'] = $this->url->link('design_color/design_color/delete', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['save_order'] = $this->url->link('design_color/design_color/sorting', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['insert'] = $this->url->link('design_color/design_color/insert', 'token=' . $this->session->data['token'] . $url, 'SSL');

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

		if (isset($this->request->get['filter_id_design_color'])) {
			$url .= '&filter_id_design_color=' . $this->request->get['filter_id_design_color'];
		}
		
		if (isset($this->request->get['filter_code'])) {
			$url .= '&filter_code=' . $this->request->get['filter_code'];
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
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

		$this->data['sort_id_design_color'] = $this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . '&sort=id_design_color' . $url, 'SSL');
		$this->data['sort_name'] = $this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . '&sort=name' . $url, 'SSL');
		$this->data['sort_code'] = $this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . '&sort=code' . $url, 'SSL');
		$this->data['sort_need_white_base'] = $this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . '&sort=need_white_base' . $url, 'SSL');
		$this->data['sort_sort'] = $this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . '&sort=sort' . $url, 'SSL');

		$url = '';

		if (isset($this->request->get['filter_id_design_color'])) {
			$url .= '&filter_id_design_color=' . $this->request->get['filter_id_design_color'];
		}
		
		if (isset($this->request->get['filter_code'])) {
			$url .= '&filter_code=' . $this->request->get['filter_code'];
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
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
		
		$this->data['colors'] = array();

		$color_total = $this->model_design_color_design_color->getTotalColors($filters);

		$results = $this->model_design_color_design_color->getColors($filters);
		
    	foreach ($results as $result) {
			$action = array();
						
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => $this->url->link('design_color/design_color/update', 'token=' . $this->session->data['token'] . '&id_design_color=' . $result['id_design_color'] . $url, 'SSL')
			);
			
			
			$this->data['colors'][] = array(
				'id_design_color'    => $result['id_design_color'],
				'name'      	=> $result['name'],
				'code'      	=> $result['code'],
				'isdefault'      	=> $result['isdefault'],
				'status'      	=> ($result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled')),
				'need_white_base'      	=> ($result['need_white_base'] ? $this->language->get('text_yes') : $this->language->get('text_no')),
				'hexa'      	=> $result['hexa'],
				'sort'      	=> $result['sort'],
				'selected'      => isset($this->request->post['selected']) && in_array($result['id_design_color'], $this->request->post['selected']),
				'action'        => $action
			);
		}

		$pagination = new Pagination();
		$pagination->total = $color_total;
		$pagination->page = $page;
		$pagination->limit = $limit;
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = $this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . $url . '&page={page}', 'SSL');

		$this->data['pagination'] = $pagination->render();

		$this->data['filter_id_design_color'] = $filter_id_design_color;
		$this->data['filter_code'] = $filter_code;
		$this->data['filter_status'] = $filter_status;
		$this->data['sort'] = $sort;
		$this->data['order'] = $order;
		$this->data['limit'] = $limit;
		
		$this->data['statuses'] = array();
		$this->data['statuses'][] = array('val'=>'', 'description'=>$this->language->get('text_none'));
		$this->data['statuses'][] = array('val'=>'1', 'description'=>$this->language->get('text_enabled'));
		$this->data['statuses'][] = array('val'=>'0', 'description'=>$this->language->get('text_disabled'));
		

		$this->template = 'design_color/list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}

  	private function getForm() {
		
		$this->document->addScript('view/javascript/jscolor/jscolor.js');
		
		$this->data['heading_title'] = $this->language->get('heading_title');
		 
		$this->data['entry_name'] = $this->language->get('entry_name');
		$this->data['entry_code'] = $this->language->get('entry_code');
		$this->data['entry_status'] = $this->language->get('entry_status');
		$this->data['entry_hexa'] = $this->language->get('entry_hexa');
		$this->data['entry_need_white_base'] = $this->language->get('entry_need_white_base');
		
		$this->data['text_yes'] = $this->language->get('text_yes');
		$this->data['text_no'] = $this->language->get('text_no');

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
		
 		if (isset($this->error['name'])) {
			$this->data['error_name'] = $this->error['name'];
		} else {
			$this->data['error_name'] = '';
		}

 		if (isset($this->error['status'])) {
			$this->data['error_status'] = $this->error['status'];
		} else {
			$this->data['error_status'] = '';
		}

 		if (isset($this->error['hexa'])) {
			$this->data['error_hexa'] = $this->error['hexa'];
		} else {
			$this->data['error_hexa'] = '';
		}
				
		$url = '';

		if (isset($this->request->get['filter_id_design_color'])) {
			$url .= '&filter_id_design_color=' . $this->request->get['filter_id_design_color'];
		}
		
		if (isset($this->request->get['filter_code'])) {
			$url .= '&filter_code=' . $this->request->get['filter_code'];
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
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
       		'text'      => $this->language->get('text_design_color_list'),
			'href'      => $this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);


		if (!isset($this->request->get['id_design_color'])) {
			$this->data['action'] = $this->url->link('design_color/design_color/insert', 'token=' . $this->session->data['token'] . $url, 'SSL');
			$this->data['breadcrumbs'][] = array(
				'text'      => $this->language->get('heading_title'),
				'href'      => $this->url->link('design_color/design_color/insert', 'token=' . $this->session->data['token'] . $url, 'SSL'),				
				'separator' => ' :: '
			);
		
		} else {
			$this->data['action'] = $this->url->link('design_color/design_color/update', 'token=' . $this->session->data['token'] . '&id_design_color=' . $this->request->get['id_design_color'] . $url, 'SSL');
			$this->data['breadcrumbs'][] = array(
				'text'      => $this->language->get('heading_title'),
				'href'      => $this->url->link('design_color/design_color/update', 'token=' . $this->session->data['token'] . '&id_design_color=' . $this->request->get['id_design_color'] . $url, 'SSL'),				
				'separator' => ' :: '
			);
		
		}
		
		$this->data['cancel'] = $this->url->link('design_color/design_color/_list', 'token=' . $this->session->data['token'] . $url, 'SSL');
		
		if (isset($this->request->get['id_design_color']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			
			$color = $this->model_design_color_design_color->getColor($this->request->get['id_design_color']);	
			
			$color_info = array(
				'id_design_color'	=> $color['id_design_color'],
				'name'      	=> $color['name'],
				'status'      	=> $color['status'],
				'need_white_base'      	=> $color['need_white_base'],
				'code'      	=> $color['code'],
				'hexa'   => $color['hexa']
			);
		}

		if (isset($this->request->post['name'])) {
			$this->data['name'] = $this->request->post['name'];
		} elseif (!empty($color_info)) {
			$this->data['name'] = $color_info['name'];
		} else {
			$this->data['name'] = '';
		}
		
		if (isset($this->request->post['status'])) {
			$this->data['status'] = $this->request->post['status'];
		} elseif (!empty($color_info)) {
			$this->data['status'] = $color_info['status'];
		} else {
			$this->data['status'] = '0';
		}
		
		if (isset($this->request->post['need_white_base'])) {
			$this->data['need_white_base'] = $this->request->post['need_white_base'];
		} elseif (!empty($color_info)) {
			$this->data['need_white_base'] = $color_info['need_white_base'];
		} else {
			$this->data['need_white_base'] = '1';
		}

		if (isset($this->request->post['code'])) {
			$this->data['code'] = $this->request->post['code'];
		} elseif (!empty($color_info)) {
			$this->data['code'] = $color_info['code'];
		} else {
			$this->data['code'] = '';
		}

		if (isset($this->request->post['hexa'])) {
			$this->data['hexa'] = $this->request->post['hexa'];
		} elseif (!empty($color_info)) { 
			$this->data['hexa'] = $color_info['hexa'];
		} else {
			$this->data['hexa'] = 'FFFFFF';
		}
		
		$this->data['statuses'] = array();
		$this->data['statuses'][] = array('val'=>'1', 'description'=>$this->language->get('text_enabled'));
		$this->data['statuses'][] = array('val'=>'0', 'description'=>$this->language->get('text_disabled'));

		$this->template = 'design_color/form.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}
	
	
  	private function validateForm() {
		if (!$this->user->hasPermission('modify', 'design_color/design_color')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
 
		if ((utf8_strlen($this->request->post['name']) < 1) || (utf8_strlen($this->request->post['name']) > 255)) {
			$this->error['name'] = $this->language->get('error_name');
		}
		
		if(empty($this->request->post['hexa']) || !preg_match("/^[a-fA-F0-9]{6}$/",$this->request->post['hexa'])) {
			$this->error['hexa'] = $this->language->get('error_hexa');
		}
		
		if($this->request->post['status']=="0" && $this->model_design_color_design_color->isDefault($this->request->get['id_design_color'])=="1") {
			$this->error['status'] = $this->language->get('error_status');
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
		if (!$this->user->hasPermission('modify', 'design_color/design_color')) {
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