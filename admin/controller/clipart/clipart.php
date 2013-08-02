<?php
class ControllerClipartClipart extends Controller {
	private $error = array();

  	public function index() {
		$this->getList();

  	}
	
  	public function _list() {

    	$this->getList();
  	}
	
  	public function insert() {
		$this->load->language('clipart/form');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('clipart/clipart');
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
      	  	
			$id_clipart = $this->model_clipart_clipart->addClipart($this->request->post);
						
			$this->session->data['success'] = $this->language->get('text_success');
		  
			$url = '';
			
			if (isset($this->request->get['filter_id_clipart'])) {
				$url .= '&filter_id_clipart=' . $this->request->get['filter_id_clipart'];
			}
			
			if (isset($this->request->get['filter_id_category'])) {
				$url .= '&filter_id_category=' . $this->request->get['filter_id_category'];
			}
			
			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
			}
												
			if (isset($this->request->get['filter_keyword'])) {
				$url .= '&filter_keyword=' . $this->request->get['filter_keyword'];
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

			$this->redirect($this->url->link('clipart/clipart/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
		
    	$this->getForm();
  	}
	
  	public function update() {
		
		$this->load->language('clipart/form');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('clipart/clipart');
		    	
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			
			$this->model_clipart_clipart->editClipart($this->request->get['id_clipart'], $this->request->post);
	  		
			$this->session->data['success'] = $this->language->get('text_success');
	  
			$url = '';

			if (isset($this->request->get['filter_id_clipart'])) {
				$url .= '&filter_id_clipart=' . $this->request->get['filter_id_clipart'];
			}
			
			if (isset($this->request->get['filter_id_category'])) {
				$url .= '&filter_id_category=' . $this->request->get['filter_id_category'];
			}
			
			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
			}
												
			if (isset($this->request->get['filter_keyword'])) {
				$url .= '&filter_keyword=' . $this->request->get['filter_keyword'];
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


			$this->redirect($this->url->link('clipart/clipart/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
		
    	$this->getForm();
  	}
	
  	public function delete() {
		
		$this->load->language('clipart/form');

		if (isset($this->request->post['selected']) && $this->validateDelete()) {
			
			$this->load->model('clipart/clipart');
			
			foreach ($this->request->post['selected'] as $id_clipart) {
				$this->model_clipart_clipart->deleteClipart($id_clipart);
			}

			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';
	
			if (isset($this->request->get['filter_id_clipart'])) {
				$url .= '&filter_id_clipart=' . $this->request->get['filter_id_clipart'];
			}
			
			if (isset($this->request->get['filter_id_category'])) {
				$url .= '&filter_id_category=' . $this->request->get['filter_id_category'];
			}
			
			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
			}
												
			if (isset($this->request->get['filter_keyword'])) {
				$url .= '&filter_keyword=' . $this->request->get['filter_keyword'];
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

			$this->redirect($this->url->link('clipart/clipart/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
		$this->getList();
  	}

  	private function getList() {
		
		$this->load->language('clipart/list');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('clipart/clipart');

		$filters = array();
		
		if (isset($this->request->get['filter_id_clipart'])) {
			$filter_id_clipart = $this->request->get['filter_id_clipart'];
			$filters['filter_id_clipart'] = $filter_id_clipart;
		} else {
			$filter_id_clipart = null;
		}

		if (isset($this->request->get['filter_id_category'])) {
			$filter_id_category = $this->request->get['filter_id_category'];
			$filters['filter_id_category'] = $filter_id_category;
		} else {
			$filter_id_category = null;
		}

		if (isset($this->request->get['filter_status'])) {
			$filter_status = $this->request->get['filter_status'];
			$filters['filter_status'] = $filter_status;
		} else {
			$filter_status = '';
		}

		if (isset($this->request->get['filter_keyword'])) {
			$filter_keyword = $this->request->get['filter_keyword'];
			$filters['filter_keyword'] = $filter_keyword;
		} else {
			$filter_keyword = '';
		}

		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = 'c.date_added';
		}
		$filters['sort'] = $sort;

		if (isset($this->request->get['order'])) {
			$order = $this->request->get['order'];
		} else {
			$order = 'DESC';
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

		if (isset($this->request->get['filter_id_clipart'])) {
			$url .= '&filter_id_clipart=' . $this->request->get['filter_id_clipart'];
		}
		
		if (isset($this->request->get['filter_id_category'])) {
			$url .= '&filter_id_category=' . $this->request->get['filter_id_category'];
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}
											
		if (isset($this->request->get['filter_keyword'])) {
			$url .= '&filter_keyword=' . $this->request->get['filter_keyword'];
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
			'href'      => $this->url->link('clipart/clipart/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'),
			'separator' => ' :: '
   		);
		$this->data['delete'] = $this->url->link('clipart/clipart/delete', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['insert'] = $this->url->link('clipart/clipart/insert', 'token=' . $this->session->data['token'] . $url, 'SSL');

		$this->data['cliparts'] = array();

		$clipart_total = $this->model_clipart_clipart->getTotalCliparts($filters);

		$results = $this->model_clipart_clipart->getCliparts($filters);
		$this->load->model('clipart/category');
		$this->load->model('tool/image');
		
    	foreach ($results as $result) {
			$action = array();
						
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => $this->url->link('clipart/clipart/update', 'token=' . $this->session->data['token'] . '&id_clipart=' . $result['id_clipart'] . $url, 'SSL')
			);
			
			$cats = array();
			foreach($this->model_clipart_clipart->getClipartCategories($result['id_clipart']) as $id_category)
			{
				$cats[] = $this->model_clipart_category->getCategory($id_category);
			}
			
			if($result['image_file'] && file_exists(DIR_IMAGE . 'data/cliparts/' . $result['image_file'])) {
				$thumb = $this->model_tool_image->resize('data/cliparts/' .$result['image_file'], 100, 100);
			} else {
				$thumb = $this->model_tool_image->resize('no_image.jpg', 100, 100);
			}
			
			$this->data['cliparts'][] = array(
				'id_clipart'    => $result['id_clipart'],
				'name'      	=> $result['name'],
				'status'      	=> ($result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled')),
				//'thumb'      	=> 	__HTTP_RESOURCES_DIR__ . 'cliparts/clipart_'.$result['id_clipart'].'/thumb_90_90.jpg',
				'thumb'      	=> 	$thumb,
				'date_added'    => date($this->language->get('date_format_short'), strtotime($result['date_added'])),
				'categories'    => $cats,
				'keywords'      => $this->model_clipart_clipart->getClipartKeywords($result['id_clipart']),
				'selected'      => isset($this->request->post['selected']) && in_array($result['id_clipart'], $this->request->post['selected']),
				'action'        => $action
			);
		}

		$this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['column_id_clipart'] = $this->language->get('column_id_clipart');
		$this->data['column_name'] = $this->language->get('column_name');
    	$this->data['column_status'] = $this->language->get('column_status');
		$this->data['column_thumb'] = $this->language->get('column_thumb');
		$this->data['column_date_added'] = $this->language->get('column_date_added');
		$this->data['column_action'] = $this->language->get('column_action');
		$this->data['column_categories'] = $this->language->get('column_categories');
		$this->data['column_keywords'] = $this->language->get('column_keywords');
		$this->data['text_no_results'] = $this->language->get('text_no_results');
		$this->data['text_limit'] = $this->language->get('text_limit');
		$this->data['text_none'] = $this->language->get('text_none');
		

		$this->data['button_delete'] = $this->language->get('button_delete');
		$this->data['button_filter'] = $this->language->get('button_filter');
		$this->data['button_insert'] = $this->language->get('button_insert');

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

		if (isset($this->request->get['filter_id_clipart'])) {
			$url .= '&filter_id_clipart=' . $this->request->get['filter_id_clipart'];
		}
		
		if (isset($this->request->get['filter_id_category'])) {
			$url .= '&filter_id_category=' . $this->request->get['filter_id_category'];
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}
											
		if (isset($this->request->get['filter_keyword'])) {
			$url .= '&filter_keyword=' . $this->request->get['filter_keyword'];
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

		$this->data['sort_clipart'] = $this->url->link('clipart/clipart/_list', 'token=' . $this->session->data['token'] . '&sort=c.id_clipart' . $url, 'SSL');
		$this->data['sort_name'] = $this->url->link('clipart/clipart/_list', 'token=' . $this->session->data['token'] . '&sort=c.name' . $url, 'SSL');
		$this->data['sort_status'] = $this->url->link('clipart/clipart/_list', 'token=' . $this->session->data['token'] . '&sort=c.status' . $url, 'SSL');
		$this->data['sort_date_added'] = $this->url->link('clipart/clipart/_list', 'token=' . $this->session->data['token'] . '&sort=c.date_added' . $url, 'SSL');

		$url = '';

		if (isset($this->request->get['filter_id_clipart'])) {
			$url .= '&filter_id_clipart=' . $this->request->get['filter_id_clipart'];
		}
		
		if (isset($this->request->get['filter_id_category'])) {
			$url .= '&filter_id_category=' . $this->request->get['filter_id_category'];
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}
											
		if (isset($this->request->get['filter_keyword'])) {
			$url .= '&filter_keyword=' . $this->request->get['filter_keyword'];
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

		$pagination = new Pagination();
		$pagination->total = $clipart_total;
		$pagination->page = $page;
		$pagination->limit = $limit;
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = $this->url->link('clipart/clipart/_list', 'token=' . $this->session->data['token'] . $url . '&page={page}', 'SSL');

		$this->data['pagination'] = $pagination->render();

		$this->data['filter_id_clipart'] = $filter_id_clipart;
		$this->data['filter_id_category'] = $filter_id_category;
		$this->data['filter_status'] = $filter_status;
		$this->data['filter_keyword'] = $filter_keyword;
		$this->data['sort'] = $sort;
		$this->data['order'] = $order;
		$this->data['limit'] = $limit;

		$this->load->model('clipart/category');

    	$this->data['categories'] = $this->model_clipart_category->getCategoriesByParentId();
		
		$this->data['statuses'] = array();
		$this->data['statuses'][] = array('val'=>'', 'description'=>$this->language->get('text_none'));
		$this->data['statuses'][] = array('val'=>'1', 'description'=>$this->language->get('text_enabled'));
		$this->data['statuses'][] = array('val'=>'0', 'description'=>$this->language->get('text_disabled'));

		$this->template = 'clipart/list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}

  	private function getForm() {
		
		$this->data['heading_title'] = $this->language->get('heading_title');
		
		$this->document->addScript('view/javascript/uploadify/swfobject.js');
		$this->document->addScript('view/javascript/uploadify/jquery.uploadify.v2.1.4.min.js');
		$this->document->addStyle('view/javascript/uploadify/uploadify.css');

		$this->data['text_select'] = $this->language->get('text_select');
		$this->data['text_none'] = $this->language->get('text_none');
		$this->data['text_freq_keywords'] = $this->language->get('text_freq_keywords');
		$this->data['text_clear'] = $this->language->get('text_clear');
		
		$this->data['entry_name'] = $this->language->get('entry_name');
		$this->data['entry_keywords'] = $this->language->get('entry_keywords');
		$this->data['entry_status'] = $this->language->get('entry_status');
			
		$this->data['button_save'] = $this->language->get('button_save');
		$this->data['button_cancel'] = $this->language->get('button_cancel');

		$this->data['tab_data'] = $this->language->get('tab_data');
		$this->data['tab_categories'] = $this->language->get('tab_categories');
		$this->data['tab_appearance'] = $this->language->get('tab_appearance');

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
				
		$url = '';

		if (isset($this->request->get['filter_id_clipart'])) {
			$url .= '&filter_id_clipart=' . $this->request->get['filter_id_clipart'];
		}
		
		if (isset($this->request->get['filter_id_category'])) {
			$url .= '&filter_id_category=' . $this->request->get['filter_id_category'];
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}
											
		if (isset($this->request->get['filter_keyword'])) {
			$url .= '&filter_keyword=' . $this->request->get['filter_keyword'];
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
       		'text'      => $this->language->get('text_clipart_list'),
			'href'      => $this->url->link('clipart/clipart/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);


		if (!isset($this->request->get['id_clipart'])) {
			$this->data['breadcrumbs'][] = array(
				'text'      => $this->language->get('heading_title'),
				'href'      => $this->url->link('clipart/clipart/insert', 'token=' . $this->session->data['token'] . $url, 'SSL'),				
				'separator' => ' :: '
			);
			$this->data['action'] = $this->url->link('clipart/clipart/insert', 'token=' . $this->session->data['token'] . $url, 'SSL');
		} else {
			$this->data['breadcrumbs'][] = array(
				'text'      => $this->language->get('heading_title'),
				'href'      => $this->url->link('clipart/clipart/update', 'token=' . $this->session->data['token'] . '&id_clipart=' . $this->request->get['id_clipart'] . $url, 'SSL'),				
				'separator' => ' :: '
			);
			$this->data['action'] = $this->url->link('clipart/clipart/update', 'token=' . $this->session->data['token'] . '&id_clipart=' . $this->request->get['id_clipart'] . $url, 'SSL');
		}
		
		$this->data['cancel'] = $this->url->link('clipart/clipart/_list', 'token=' . $this->session->data['token'] . $url, 'SSL');
		
		if (isset($this->request->get['id_clipart']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			
			$result = $this->model_clipart_clipart->getClipart($this->request->get['id_clipart']);	
			
			$clipart_info = array(
				'id_clipart'		=> $result['id_clipart'],
				'name'      	=> $result['name'],
				'status'      	=> $result['status'],
				'keywords'      => implode(",",$this->model_clipart_clipart->getClipartKeywords($result['id_clipart']))
			);
		}
				
		if (isset($this->request->post['name'])) {
			$this->data['name'] = $this->request->post['name'];
		} elseif (!empty($clipart_info)) {
			$this->data['name'] = $clipart_info['name'];
		} else {
			$this->data['name'] = '';
		}
				
		if (isset($this->request->post['status'])) {
			$this->data['status'] = $this->request->post['status'];
		} elseif (!empty($clipart_info)) { 
			$this->data['status'] = $clipart_info['status'];
		} else {
			$this->data['status'] = '';
		}	
		
		if (isset($this->request->post['keywords'])) {
			$this->data['keywords'] = $this->request->post['keywords'];
		} elseif (!empty($clipart_info)) { 
			$this->data['keywords'] = $clipart_info['keywords'];
		} else {
			$this->data['keywords'] = '';
		}	
		
		$this->data['statuses'] = array();
		$this->data['statuses'][] = array('val'=>'1', 'description'=>$this->language->get('text_enabled'));
		$this->data['statuses'][] = array('val'=>'0', 'description'=>$this->language->get('text_disabled'));

		$this->template = 'clipart/form.tpl';
		$this->children = array(
			'clipart/category/category_tab',
			'clipart/clipart/appearance_tab',
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}
	
	
  	private function validateForm() {
		if (!$this->user->hasPermission('modify', 'clipart/clipart')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
 
		if ((utf8_strlen($this->request->post['name']) < 1) || (utf8_strlen($this->request->post['name']) > 255)) {
			$this->error['name'] = $this->language->get('error_name');
		}
		
		if ((utf8_strlen($this->request->post['swf_file']) < 1) || (utf8_strlen($this->request->post['swf_file']) > 255)) {
			$this->error['swf_file'] = $this->language->get('error_swf_file');
			$this->session->data['error_swf_file'] = $this->language->get('error_swf_file');
		}
		
		if ((utf8_strlen($this->request->post['vector_file']) < 1) || (utf8_strlen($this->request->post['vector_file']) > 255)) {
			$this->error['vector_file'] = $this->language->get('error_vector_file');
			$this->session->data['error_vector_file'] = $this->language->get('error_vector_file');
		}
		
		if ((utf8_strlen($this->request->post['image_file']) < 1) || (utf8_strlen($this->request->post['image_file']) > 255)) {
			$this->error['image_file'] = $this->language->get('error_image_file');
			$this->session->data['error_image_file'] = $this->language->get('error_image_file');
		}
		
		
		if (empty($this->request->post['layer_name'])) {
			$this->error['layer_name'] = $this->language->get('error_layer_name');
			$this->session->data['error_layer_name'] = $this->language->get('error_layer_name');
		} else {
			foreach($this->request->post['layer_name'] as $name) {
				if(empty($name)) {
					$this->error['layer_name'] = $this->language->get('error_layer_name');
					$this->session->data['error_layer_name'] = $this->language->get('error_layer_name');
				}
			}
		}
		
		if (empty($this->request->post['layer_id_design_color'])) {
			$this->error['layer_id_design_color'] = $this->language->get('error_layer_id_design_color');
			$this->session->data['error_layer_id_design_color'] = $this->language->get('error_layer_id_design_color');
		} else {
			foreach($this->request->post['layer_id_design_color'] as $layer_id_design_color) {
				if(empty($layer_id_design_color)) {
					$this->error['layer_id_design_color'] = $this->language->get('error_layer_id_design_color');
					$this->session->data['error_layer_id_design_color'] = $this->language->get('error_layer_id_design_color');
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
	
	private function validateDelete() {
		if (!$this->user->hasPermission('modify', 'clipart/clipart')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
 
		if (!$this->error) {
			return true; 
		} else {
			return false;
		}
	}


	public function upload_vector() {
		
		$this->language->load('clipart/form');
		
		$json = array();
		
		if (!empty($this->request->files['file']['name'])) {
			$filename = html_entity_decode($this->request->files['file']['name'], ENT_QUOTES, 'UTF-8');
			
			if ((strlen($filename) < 3) || (strlen($filename) > 128)) {
        		$json['error'] = $this->language->get('error_filename');
	  		}	  	
			
			$allowed = array();
			
			$filetypes = explode(',', 'cdr,svg,ai,eps');
			
			foreach ($filetypes as $filetype) {
				$allowed[] = trim($filetype);
			}
			
			if (!in_array(utf8_substr(strrchr($filename, '.'), 1), $allowed)) {
				$json['error'] = $this->language->get('error_filetype');
       		}
						
			if ($this->request->files['file']['error'] != UPLOAD_ERR_OK) {
				$json['error'] = $this->language->get('error_upload_' . $this->request->files['file']['error']);
			}
		} else {
			$json['error'] = $this->language->get('error_upload');
		}
		
		if (!$this->user->hasPermission('modify', 'clipart/clipart')) {
			$json['error'] = $this->language->get('error_permission');
		}
 

		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && !isset($json['error'])) {
			if (is_uploaded_file($this->request->files['file']['tmp_name']) && file_exists($this->request->files['file']['tmp_name'])) {
				$file = substr(md5(rand()), 0, 8) . '-' . basename($filename) ;
				
				if(move_uploaded_file($this->request->files['file']['tmp_name'], DIR_IMAGE . 'data/cliparts/' . $file))
				{
					$json['filename'] = $file;
					
					$json['success'] = $this->language->get('text_upload');
				} else {
					$json['error'] = $this->language->get('error_upload');
				}
			
			}
		}	

		$this->response->setOutput(json_encode($json));		
	}
	
	public function upload_swf() {
		
		$this->language->load('clipart/form');
		
		$json = array();
		
		if (!empty($this->request->files['file']['name'])) {
			$filename = html_entity_decode($this->request->files['file']['name'], ENT_QUOTES, 'UTF-8');
			
			if ((strlen($filename) < 3) || (strlen($filename) > 128)) {
        		$json['error'] = $this->language->get('error_filename');
	  		}	  	
			
			$allowed = array();
			
			$filetypes = explode(',', 'swf,SWF');
			
			foreach ($filetypes as $filetype) {
				$allowed[] = trim($filetype);
			}
			
			if (!in_array(utf8_substr(strrchr($filename, '.'), 1), $allowed)) {
				$json['error'] = $this->language->get('error_filetype');
       		}
						
			if ($this->request->files['file']['error'] != UPLOAD_ERR_OK) {
				$json['error'] = $this->language->get('error_upload_' . $this->request->files['file']['error']);
			}
		} else {
			$json['error'] = $this->language->get('error_upload');
		}
		
		if (!$this->user->hasPermission('modify', 'clipart/clipart')) {
			$json['error'] = $this->language->get('error_permission');
		}
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && !isset($json['error'])) {
			if (is_uploaded_file($this->request->files['file']['tmp_name']) && file_exists($this->request->files['file']['tmp_name'])) {
				$file = substr(md5(rand()), 0, 8) . '-' . basename($filename) ;
				
				if(move_uploaded_file($this->request->files['file']['tmp_name'], DIR_IMAGE . 'data/cliparts/' . $file))
				{
					$json['filename'] = $file;
					
					$json['success'] = $this->language->get('text_upload');
				} else {
					$json['error'] = $this->language->get('error_upload');
				}
			
			}
		}	

		$this->response->setOutput(json_encode($json));		
	}

	public function upload_image() {
		
		$this->language->load('clipart/form');
		
		$json = array();
		
		if (!empty($this->request->files['file']['name'])) {
			$filename = html_entity_decode($this->request->files['file']['name'], ENT_QUOTES, 'UTF-8');
			
			if ((strlen($filename) < 3) || (strlen($filename) > 128)) {
        		$json['error'] = $this->language->get('error_filename');
	  		}	  	
			
			$allowed = array();
			
			$filetypes = explode(',', 'jpg,png,gif,JPG');
			
			foreach ($filetypes as $filetype) {
				$allowed[] = trim($filetype);
			}
			
			if (!in_array(utf8_substr(strrchr($filename, '.'), 1), $allowed)) {
				$json['error'] = $this->language->get('error_filetype');
       		}
						
			if ($this->request->files['file']['error'] != UPLOAD_ERR_OK) {
				$json['error'] = $this->language->get('error_upload_' . $this->request->files['file']['error']);
			}
		} else {
			$json['error'] = $this->language->get('error_upload');
		}
		
		if (!$this->user->hasPermission('modify', 'clipart/clipart')) {
			$json['error'] = $this->language->get('error_permission');
		}
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && !isset($json['error'])) {
			if (is_uploaded_file($this->request->files['file']['tmp_name']) && file_exists($this->request->files['file']['tmp_name'])) {
				$file = substr(md5(rand()), 0, 8) . '-' . basename($filename) ;
				
				if(move_uploaded_file($this->request->files['file']['tmp_name'], DIR_IMAGE . 'data/cliparts/' . $file))
				{
					$json['filename'] = $file;
					
					$this->load->model('tool/image');
		
					$json['file'] = $this->model_tool_image->resize('data/cliparts/' .$file, 100, 100);
					
					$json['success'] = $this->language->get('text_upload');
				} else {
					$json['error'] = $this->language->get('error_upload');
				}
			
			}
		}	

		$this->response->setOutput(json_encode($json));		
	}
	
	public function appearance_tab() {

		$this->load->language('clipart/form');

		$this->load->model('clipart/clipart');

		$this->data['entry_swf_file'] = $this->language->get('entry_swf_file');
		$this->data['entry_vector_file'] = $this->language->get('entry_vector_file');
		$this->data['entry_vector_file_2'] = $this->language->get('entry_vector_file_2');
		$this->data['entry_image_file'] = $this->language->get('entry_image_file');
		$this->data['text_child_not_sprite'] = $this->language->get('text_child_not_sprite');
		$this->data['text_layers'] = $this->language->get('text_layers');
		$this->data['text_select'] = $this->language->get('text_select');
		$this->data['text_full_color'] = $this->language->get('text_full_color');
		$this->data['button_upload'] = $this->language->get('button_upload');
		$this->data['token'] = $this->session->data['token'];

		if (isset($this->session->data['error_swf_file'])) {
			$this->data['error_swf_file'] = $this->session->data['error_swf_file'];
			unset($this->session->data['error_swf_file']);
		} else {
			$this->data['error_swf_file'] = '';
		}

		if (isset($this->session->data['error_image_file'])) {
			$this->data['error_image_file'] = $this->session->data['error_image_file'];
			unset($this->session->data['error_image_file']);
		} else {
			$this->data['error_image_file'] = '';
		}

		if (isset($this->session->data['error_vector_file'])) {
			$this->data['error_vector_file'] = $this->session->data['error_vector_file'];
			unset($this->session->data['error_vector_file']);
		} else {
			$this->data['error_vector_file'] = '';
		}

		if (isset($this->session->data['error_layer_id_design_color'])) {
			$this->data['error_layer_id_design_color'] = $this->session->data['error_layer_id_design_color'];
			unset($this->session->data['error_layer_id_design_color']);
		} else {
			$this->data['error_layer_id_design_color'] = '';
		}

		if (isset($this->session->data['error_layer_name'])) {
			$this->data['error_layer_name'] = $this->session->data['error_layer_name'];
			unset($this->session->data['error_layer_name']);
		} else {
			$this->data['error_layer_name'] = '';
		}

		if (isset($this->request->get['id_clipart']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			
			$result = $this->model_clipart_clipart->getClipart($this->request->get['id_clipart']);	
			$layers_result = $this->model_clipart_clipart->getClipartLayers($this->request->get['id_clipart']);	
			
			$layer_name = array();
			$layer_id_design_color = array();
			foreach ($layers_result as $layer_result) {
				$layer_name[] = $layer_result['name'];
				$layer_id_design_color[] = $layer_result['id_design_color'];
    		}	

			$clipart_info = array(
				'vector_file'      => $result['vector_file'],
				'vector_file_2'      => $result['vector_file_2'],
				'image_file'      => $result['image_file'],
				'swf_file'      => $result['swf_file'],
				'layer_name'		=> $layer_name,
				'layer_id_design_color'		=> $layer_id_design_color
			);
		}


		if (isset($this->request->post['swf_file'])) {
			$this->data['swf_file'] = $this->request->post['swf_file'];
		} elseif (!empty($clipart_info)) { 
			$this->data['swf_file'] = $clipart_info['swf_file'];
		} else {
			$this->data['swf_file'] = '';
		}
		
		if (isset($this->request->post['image_file'])) {
			$this->data['image_file'] = $this->request->post['image_file'];
		} elseif (!empty($clipart_info)) { 
			$this->data['image_file'] = $clipart_info['image_file'];
		} else {
			$this->data['image_file'] = '';
		}
		
		if (isset($this->request->post['vector_file'])) {
			$this->data['vector_file'] = $this->request->post['vector_file'];
		} elseif (!empty($clipart_info)) { 
			$this->data['vector_file'] = $clipart_info['vector_file'];
		} else {
			$this->data['vector_file'] = '';
		}
		
		if (isset($this->request->post['vector_file_2'])) {
			$this->data['vector_file_2'] = $this->request->post['vector_file_2'];
		} elseif (!empty($clipart_info)) { 
			$this->data['vector_file_2'] = $clipart_info['vector_file_2'];
		} else {
			$this->data['vector_file_2'] = '';
		}
		
		if (isset($this->request->post['layer_name'])) {
			$this->data['layer_name'] = $this->request->post['layer_name'];
		} elseif (!empty($clipart_info)) { 
			$this->data['layer_name'] = $clipart_info['layer_name'];
		} else {
			$this->data['layer_name'] = array('Layer');
		}
		
		if (isset($this->request->post['layer_id_design_color'])) {
			$this->data['layer_id_design_color'] = $this->request->post['layer_id_design_color'];
		} elseif (!empty($clipart_info)) { 
			$this->data['layer_id_design_color'] = $clipart_info['layer_id_design_color'];
		} else {
			$this->data['layer_id_design_color'] = array('0');
		}
		
		$this->data['clipart_dir'] = HTTPS_CATALOG . 'image/data/cliparts/';
		
		$this->load->model('tool/image');
		
		if (isset($this->request->post['image_file'])) {
			$this->data['thumb'] = $this->model_tool_image->resize('data/cliparts/' .$this->request->post['image_file'], 100, 100);
		} elseif (!empty($clipart_info) && $clipart_info['image_file'] && file_exists(DIR_IMAGE . 'data/cliparts/' . $clipart_info['image_file'])) {
			$this->data['thumb'] = $this->model_tool_image->resize('data/cliparts/' .$clipart_info['image_file'], 100, 100);
		} else {
			$this->data['thumb'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);
		}
		
		$this->load->model('design_color/design_color');
		
		$this->data['colors'] = $this->model_design_color_design_color->getColors();
		
		$this->template = 'clipart/appearance_tab.tpl';
		
		$this->response->setOutput($this->render());

	}
			
}
?>