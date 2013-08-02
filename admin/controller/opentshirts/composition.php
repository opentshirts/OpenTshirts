<?php
class ControllerOpentshirtsComposition extends Controller {
	private $error = array();

  	public function index() {

    	$this->getList();

  	}
	
  	public function _list() {

    	$this->getList();
  	}
	
  	public function insert() {
		$this->load->language('opentshirts/composition_form');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('opentshirts/composition');
		
		/*if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
      	  	
			$id_composition = $this->model_composition_composition->addComposition($this->request->post);
						
			$this->session->data['success'] = $this->language->get('text_success');
		  
			$url = '';
			
			if (isset($this->request->get['filter_id_composition'])) {
				$url .= '&filter_id_composition=' . $this->request->get['filter_id_composition'];
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

			$this->redirect($this->url->link('composition/composition/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}*/
		
    	$this->getForm();
  	}
	
  	public function update() {
		
		$this->load->language('opentshirts/composition_form');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('opentshirts/composition');
		    	
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			
			$this->model_opentshirts_composition->editComposition($this->request->get['id_composition'], $this->request->post);
	  		
			$this->session->data['success'] = $this->language->get('text_success');
	  
			$url = '';

			if (isset($this->request->get['filter_id_composition'])) {
				$url .= '&filter_id_composition=' . $this->request->get['filter_id_composition'];
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


			$this->redirect($this->url->link('opentshirts/composition/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
		
    	$this->getForm();
  	}
	
  	public function delete() {
		
		$this->load->language('opentshirts/composition_form');

		if (isset($this->request->post['selected']) && $this->validateDelete()) {
			
			$this->load->model('opentshirts/composition');
			
			foreach ($this->request->post['selected'] as $id_composition) {
				$this->model_opentshirts_composition->deleteComposition($id_composition);
			}

			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';
	
			if (isset($this->request->get['filter_id_composition'])) {
				$url .= '&filter_id_composition=' . $this->request->get['filter_id_composition'];
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

			$this->redirect($this->url->link('opentshirts/composition/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
		$this->getList();
  	}

  	private function getList() {
		
		$this->load->language('opentshirts/composition_list');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('opentshirts/composition');

		$filters = array();
		$filters['filter_id_author'] = 0;
		
		if (isset($this->request->get['filter_id_composition'])) {
			$filter_id_composition = $this->request->get['filter_id_composition'];
			$filters['filter_id_composition'] = $filter_id_composition;
		} else {
			$filter_id_composition = null;
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

		if (isset($this->request->get['filter_id_composition'])) {
			$url .= '&filter_id_composition=' . $this->request->get['filter_id_composition'];
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
			'href'      => $this->url->link('opentshirts/composition/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'),
			'separator' => ' :: '
   		);
		$this->data['delete'] = $this->url->link('opentshirts/composition/delete', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['insert'] = $this->url->link('opentshirts/composition/insert', 'token=' . $this->session->data['token'] . $url, 'SSL');

		$this->data['compositions'] = array();

		$composition_total = $this->model_opentshirts_composition->getTotalCompositions($filters);

		$results = $this->model_opentshirts_composition->getCompositions($filters);
		$this->load->model('opentshirts/composition_category');
		$this->load->model('opentshirts/design');
		$this->load->model('tool/image');
		
    	foreach ($results as $result) {
			$action = array();
						
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => $this->url->link('opentshirts/composition/update', 'token=' . $this->session->data['token'] . '&id_composition=' . $result['id_composition'] . $url, 'SSL')
			);
			
			$cats = array();
			foreach($this->model_opentshirts_composition->getCompositionCategories($result['id_composition']) as $id_category)
			{
				$cats[] = $this->model_opentshirts_composition_category->getCategory($id_category);
			}
			
			$images = array();
			$design_results = $this->model_opentshirts_design->getDesigns(array("filter_id_composition" => $result['id_composition']));
			foreach ($design_results as $design_result) {
				
				if (file_exists(DIR_IMAGE . 'data/designs/design_' . $design_result['id_design']. '/snapshot.png')) {
					$image['thumb'] = $this->model_tool_image->resize('data/designs/design_' . $design_result['id_design']. '/snapshot.png', 40, 40);
				} else {
					$image['thumb'] = $this->model_tool_image->resize('no_image.jpg', 40, 40);
				}

				if (file_exists(DIR_IMAGE . 'data/designs/design_' . $design_result['id_design']. '/snapshot.png')) {
					$image['large'] = $this->model_tool_image->resize('data/designs/design_' . $design_result['id_design']. '/snapshot.png', 100, 100);
				} else {
					$image['large'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);
				}

				if (file_exists(DIR_IMAGE . 'data/designs/design_' . $design_result['id_design']. '/snapshot.png')) {
					$image['original'] = HTTPS_CATALOG . 'image/data/designs/design_' . $design_result['id_design']. '/snapshot.png';
				} else {
					$image['original'] = '';
				}

				$images[] = $image;
				
			}

			
			$this->data['compositions'][] = array(
				'id_composition'    => $result['id_composition'],
				'name'      	=> $result['name'],
				'link'		=> HTTP_CATALOG."?route=studio/home&idc=".$result['id_composition'],
				'status'      	=> ($result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled')),
				'images'      	=> 	$images,
				'date_added'    => date($this->language->get('date_format_short'), strtotime($result['date_added'])),
				'categories'    => $cats,
				'keywords'      => $this->model_opentshirts_composition->getCompositionKeywords($result['id_composition']),
				'selected'      => isset($this->request->post['selected']) && in_array($result['id_composition'], $this->request->post['selected']),
				'action'        => $action
			);
		}

		$this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['column_id_composition'] = $this->language->get('column_id_composition');
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
		$this->data['button_insert'] = $this->language->get('button_add_composition');

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

		if (isset($this->request->get['filter_id_composition'])) {
			$url .= '&filter_id_composition=' . $this->request->get['filter_id_composition'];
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

		$this->data['sort_composition'] = $this->url->link('opentshirts/composition/_list', 'token=' . $this->session->data['token'] . '&sort=c.id_composition' . $url, 'SSL');
		$this->data['sort_name'] = $this->url->link('opentshirts/composition/_list', 'token=' . $this->session->data['token'] . '&sort=c.name' . $url, 'SSL');
		$this->data['sort_status'] = $this->url->link('opentshirts/composition/_list', 'token=' . $this->session->data['token'] . '&sort=c.status' . $url, 'SSL');
		$this->data['sort_date_added'] = $this->url->link('opentshirts/composition/_list', 'token=' . $this->session->data['token'] . '&sort=c.date_added' . $url, 'SSL');

		$url = '';

		if (isset($this->request->get['filter_id_composition'])) {
			$url .= '&filter_id_composition=' . $this->request->get['filter_id_composition'];
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
		$pagination->total = $composition_total;
		$pagination->page = $page;
		$pagination->limit = $limit;
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = $this->url->link('opentshirts/composition/_list', 'token=' . $this->session->data['token'] . $url . '&page={page}', 'SSL');

		$this->data['pagination'] = $pagination->render();

		$this->data['filter_id_composition'] = $filter_id_composition;
		$this->data['filter_id_category'] = $filter_id_category;
		$this->data['filter_status'] = $filter_status;
		$this->data['filter_keyword'] = $filter_keyword;
		$this->data['sort'] = $sort;
		$this->data['order'] = $order;
		$this->data['limit'] = $limit;

		$this->load->model('opentshirts/composition_category');

    	$this->data['categories'] = $this->model_opentshirts_composition_category->getCategoriesByParentId();
		
		$this->data['statuses'] = array();
		$this->data['statuses'][] = array('val'=>'', 'description'=>$this->language->get('text_none'));
		$this->data['statuses'][] = array('val'=>'1', 'description'=>$this->language->get('text_enabled'));
		$this->data['statuses'][] = array('val'=>'0', 'description'=>$this->language->get('text_disabled'));

		$this->template = 'opentshirts/composition_list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}

  	private function getForm() {
		
		$this->data['heading_title'] = $this->language->get('heading_title');
		 
		$this->data['text_default'] = $this->language->get('text_default');
		$this->data['text_select'] = $this->language->get('text_select');
		$this->data['text_none'] = $this->language->get('text_none');
		$this->data['text_wait'] = $this->language->get('text_wait');
		$this->data['text_freq_keywords'] = $this->language->get('text_freq_keywords');
		$this->data['text_clear'] = $this->language->get('text_clear');
		
		$this->data['entry_name'] = $this->language->get('entry_name');
		$this->data['entry_keywords'] = $this->language->get('entry_keywords');
		$this->data['entry_status'] = $this->language->get('entry_status');
			
		$this->data['button_save'] = $this->language->get('button_save');
		$this->data['button_cancel'] = $this->language->get('button_cancel');
		$this->data['button_remove'] = $this->language->get('button_remove');

		$this->data['tab_data'] = $this->language->get('tab_data');
		$this->data['tab_categories'] = $this->language->get('tab_categories');

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

		if (isset($this->request->get['filter_id_composition'])) {
			$url .= '&filter_id_composition=' . $this->request->get['filter_id_composition'];
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
       		'text'      => $this->language->get('text_composition_list'),
			'href'      => $this->url->link('opentshirts/composition/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);

		$this->data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title'),
			'href'      => '',				
			'separator' => ' :: '
		);

		if (!isset($this->request->get['id_composition'])) {
			$this->data['action'] = $this->url->link('opentshirts/composition/insert', 'token=' . $this->session->data['token'] . $url, 'SSL');
		} else {
			$this->data['action'] = $this->url->link('opentshirts/composition/update', 'token=' . $this->session->data['token'] . '&id_composition=' . $this->request->get['id_composition'] . $url, 'SSL');
		}
		
		$this->data['cancel'] = $this->url->link('opentshirts/composition/_list', 'token=' . $this->session->data['token'] . $url, 'SSL');
		
		if (isset($this->request->get['id_composition'])) {
			
			$this->load->model('opentshirts/composition');
			$this->load->model('opentshirts/design');
			$this->load->model('product/product');
			$this->load->model('tool/image');
			
			$result = $this->model_opentshirts_composition->getComposition($this->request->get['id_composition']);	
			
			$images = array();
			$design_results = $this->model_opentshirts_design->getDesigns(array("filter_id_composition" => $this->request->get['id_composition']));
			foreach ($design_results as $design_result) {
				
				if (file_exists(DIR_IMAGE . 'data/designs/design_' . $design_result['id_design']. '/snapshot.png')) {
					$image['thumb'] = $this->model_tool_image->resize('data/designs/design_' . $design_result['id_design']. '/snapshot.png', 60, 60);
				} else {
					$image['thumb'] = $this->model_tool_image->resize('no_image.jpg', 60, 60);
				}

				if (file_exists(DIR_IMAGE . 'data/designs/design_' . $design_result['id_design']. '/snapshot.png')) {
					$image['large'] = $this->model_tool_image->resize('data/designs/design_' . $design_result['id_design']. '/snapshot.png', 300, 300);
				} else {
					$image['large'] = $this->model_tool_image->resize('no_image.jpg', 300, 300);
				}

				if (file_exists(DIR_IMAGE . 'data/designs/design_' . $design_result['id_design']. '/snapshot.png')) {
					$image['original'] = HTTPS_CATALOG . 'image/data/designs/design_' . $design_result['id_design']. '/snapshot.png';
				} else {
					$image['original'] = '';
				}

				$images[] = $image;
			}
			
			$composition_info = array(
				'id_composition'    => $result['id_composition'],
				'name'    	   => $result['name'],
				'status'      	=> $result['status'],
				'keywords'      => implode(",",$this->model_opentshirts_composition->getCompositionKeywords($result['id_composition'])),
				'product'	   => $this->model_product_product->getProduct($result['product_id']),
				'images'		=> $images,
				'date_added'    => date($this->language->get('date_format_short'), strtotime($result['date_added']))
			);
		}
				
		if (isset($this->request->post['name'])) {
			$this->data['name'] = $this->request->post['name'];
		} elseif (!empty($composition_info)) {
			$this->data['name'] = $composition_info['name'];
		} else {
			$this->data['name'] = '';
		}
				
		if (isset($this->request->post['status'])) {
			$this->data['status'] = $this->request->post['status'];
		} elseif (!empty($composition_info)) { 
			$this->data['status'] = $composition_info['status'];
		} else {
			$this->data['status'] = '';
		}	
		
		if (isset($this->request->post['keywords'])) {
			$this->data['keywords'] = $this->request->post['keywords'];
		} elseif (!empty($composition_info)) { 
			$this->data['keywords'] = $composition_info['keywords'];
		} else {
			$this->data['keywords'] = '';
		}	
		
		if (!empty($composition_info)) { 
			$this->data['images'] = $composition_info['images'];
		} else {
			$this->data['images'] = array();
		}	
		
		$this->data['statuses'] = array();
		$this->data['statuses'][] = array('val'=>'1', 'description'=>$this->language->get('text_enabled'));
		$this->data['statuses'][] = array('val'=>'0', 'description'=>$this->language->get('text_disabled'));

		$this->template = 'opentshirts/composition_form.tpl';
		$this->children = array(
			'opentshirts/composition_category/category_tab',
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}
	
	
  	private function validateForm() {
		if (!$this->user->hasPermission('modify', 'opentshirts/composition')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if ((utf8_strlen($this->request->post['name']) < 1) || (utf8_strlen($this->request->post['name']) > 255)) {
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
		if (!$this->user->hasPermission('modify', 'opentshirts/composition')) {
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