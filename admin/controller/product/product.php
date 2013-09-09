<?php
class ControllerProductProduct extends Controller {
	private $error = array();

  	public function index() {

    	$this->getList();

  	}
	
  	public function _list() {

    	$this->getList();
  	}
	
  	public function insert() {
		$this->load->language('product/form');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('product/product');
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
      	  	
			$product_id = $this->model_product_product->addProduct($this->request->post);
						
			$this->session->data['success'] = $this->language->get('text_success');
		  
			$url = '';
			
			if (isset($this->request->get['filter_name'])) {
				$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
			}
			
			if (isset($this->request->get['filter_model'])) {
				$url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
			}
			
			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
			}

			if (isset($this->request->get['filter_printable'])) {
				$url .= '&filter_printable=' . $this->request->get['filter_printable'];
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

			$this->redirect($this->url->link('product/product/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
		
    	$this->getForm();
  	}
	
  	public function update() {
		
		$this->load->language('product/form');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('product/product');

		$this->load->model('catalog/product');
		    	
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			
			$this->model_product_product->editProduct($this->request->get['product_id'], $this->request->post);
	  		
			$this->session->data['success'] = $this->language->get('text_success');
	  
			$url = '';

			if (isset($this->request->get['filter_name'])) {
				$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
			}
			
			if (isset($this->request->get['filter_model'])) {
				$url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
			}
			
			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
			}

			if (isset($this->request->get['filter_printable'])) {
				$url .= '&filter_printable=' . $this->request->get['filter_printable'];
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


			$this->redirect($this->url->link('product/product', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
		
    	$this->getForm();
  	}
	
  	public function delete() {
		
		$this->load->language('product/form');

		if (isset($this->request->post['selected']) && $this->validateDelete()) {
			
			$this->load->model('product/product');
			
			foreach ($this->request->post['selected'] as $product_id) {
				$this->model_product_product->deleteProduct($product_id);
			}

			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';
	
			if (isset($this->request->get['filter_product_id'])) {
				$url .= '&filter_product_id=' . $this->request->get['filter_product_id'];
			}
			
			if (isset($this->request->get['filter_id_category'])) {
				$url .= '&filter_id_category=' . $this->request->get['filter_id_category'];
			}
			
			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
			}

			if (isset($this->request->get['filter_printable'])) {
				$url .= '&filter_printable=' . $this->request->get['filter_printable'];
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

			$this->redirect($this->url->link('product/product', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
		$this->getList();
  	}

  	public function set_default() {
		
		$this->load->language('product/form');

		if (isset($this->request->get['product_id']) && $this->validateDefault()) {
			
			$this->load->model('product/product');
			
			$this->model_product_product->setToDefaultProduct($this->request->get['product_id']);

			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';
	
			if (isset($this->request->get['filter_name'])) {
				$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
			}
			
			if (isset($this->request->get['filter_model'])) {
				$url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
			}
			
			if (isset($this->request->get['filter_status'])) {
				$url .= '&filter_status=' . $this->request->get['filter_status'];
			}

			if (isset($this->request->get['filter_printable'])) {
				$url .= '&filter_printable=' . $this->request->get['filter_printable'];
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

			$this->redirect($this->url->link('product/product', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
		$this->getList();
  	}

  	private function getList() {	

  		$this->load->language('product/product');

		$this->document->setTitle($this->language->get('heading_title'));

  		$this->load->model('product/product');

		if (isset($this->request->get['filter_name'])) {
			$filter_name = $this->request->get['filter_name'];
		} else {
			$filter_name = null;
		}

		if (isset($this->request->get['filter_model'])) {
			$filter_model = $this->request->get['filter_model'];
		} else {
			$filter_model = null;
		}

		if (isset($this->request->get['filter_status'])) {
			$filter_status = $this->request->get['filter_status'];
		} else {
			$filter_status = null;
		}

		if (isset($this->request->get['filter_printable'])) {
			$filter_printable = $this->request->get['filter_printable'];
		} else {
			$filter_printable = null;
		}

		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = 'pd.name';
		}
		
		if (isset($this->request->get['order'])) {
			$order = $this->request->get['order'];
		} else {
			$order = 'ASC';
		}
		
		if (isset($this->request->get['page'])) {
			$page = $this->request->get['page'];
		} else {
			$page = 1;
		}
						
		$url = '';
						
		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
		}
		
		if (isset($this->request->get['filter_model'])) {
			$url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['filter_printable'])) {
			$url .= '&filter_printable=' . $this->request->get['filter_printable'];
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
		
		$this->data['text_oc_product_list'] = sprintf($this->language->get('text_oc_product_list'), $this->url->link('catalog/product', 'token=' . $this->session->data['token'] . $url, 'SSL'));

  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('product/product', 'token=' . $this->session->data['token'] . $url, 'SSL'),       		
      		'separator' => ' :: '
   		);
		
		$this->data['products'] = array();

		$data = array(
			'filter_name'	  => $filter_name, 
			'filter_model'	  => $filter_model,
			'filter_status'   => $filter_status,
			'filter_printable'=> $filter_printable,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $this->config->get('config_admin_limit'),
			'limit'           => $this->config->get('config_admin_limit')
		);
		
		$this->load->model('tool/image');
		
		$product_total = $this->model_product_product->getTotalProducts($data);
			
		$results = $this->model_product_product->getProducts($data);

		$printable_ids = $this->model_product_product->getPrintableProducts();
				    	
		foreach ($results as $result) {
			$action = array();
			
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => $this->url->link('product/product/update', 'token=' . $this->session->data['token'] . '&product_id=' . $result['p_id'] . $url, 'SSL')
			);
			
			if ($result['image'] && file_exists(DIR_IMAGE . $result['image'])) {
				$image = $this->model_tool_image->resize($result['image'], 40, 40);
			} else {
				$image = $this->model_tool_image->resize('no_image.jpg', 40, 40);
			}

			if(!is_null($filter_printable) && $filter_printable=="0") {
				if(isset($printable_ids[$result['p_id']])) {	
					continue;
				}
			}

			$this->data['products'][] = array(
				'product_id' => $result['p_id'],
				'name'       => $result['name'],
				'model'      => $result['model'],
				'image'      => $image,
				'status'     => ($result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled')),
				'printable'  => (isset($printable_ids[$result['p_id']]) ? $this->language->get('text_enabled') : $this->language->get('text_disabled')),
				'selected'   => isset($this->request->post['selected']) && in_array($result['p_id'], $this->request->post['selected']),
				'action'     => $action
			);
      		
    	}
		
		$this->data['heading_title'] = $this->language->get('heading_title');		
				
		$this->data['text_enabled'] = $this->language->get('text_enabled');		
		$this->data['text_disabled'] = $this->language->get('text_disabled');		
		$this->data['text_no_results'] = $this->language->get('text_no_results');		
		$this->data['text_image_manager'] = $this->language->get('text_image_manager');		
			
		$this->data['column_image'] = $this->language->get('column_image');		
		$this->data['column_name'] = $this->language->get('column_name');		
		$this->data['column_model'] = $this->language->get('column_model');		
		$this->data['column_price'] = $this->language->get('column_price');		
		$this->data['column_quantity'] = $this->language->get('column_quantity');	
		$this->data['column_status'] = $this->language->get('column_status');	
		$this->data['column_printable'] = $this->language->get('column_printable');		
		$this->data['column_action'] = $this->language->get('column_action');		
				
		$this->data['button_copy'] = $this->language->get('button_copy');		
		$this->data['button_insert'] = $this->language->get('button_insert');		
		$this->data['button_delete'] = $this->language->get('button_delete');		
		$this->data['button_filter'] = $this->language->get('button_filter');

		 
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

		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
		}
		
		if (isset($this->request->get['filter_model'])) {
			$url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['filter_printable'])) {
			$url .= '&filter_printable=' . $this->request->get['filter_printable'];
		}
								
		if ($order == 'ASC') {
			$url .= '&order=DESC';
		} else {
			$url .= '&order=ASC';
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}
					
		$this->data['sort_name'] = $this->url->link('product/product', 'token=' . $this->session->data['token'] . '&sort=pd.name' . $url, 'SSL');
		$this->data['sort_model'] = $this->url->link('product/product', 'token=' . $this->session->data['token'] . '&sort=p.model' . $url, 'SSL');
		$this->data['sort_price'] = $this->url->link('product/product', 'token=' . $this->session->data['token'] . '&sort=p.price' . $url, 'SSL');
		$this->data['sort_quantity'] = $this->url->link('product/product', 'token=' . $this->session->data['token'] . '&sort=p.quantity' . $url, 'SSL');
		$this->data['sort_status'] = $this->url->link('product/product', 'token=' . $this->session->data['token'] . '&sort=p.status' . $url, 'SSL');
		$this->data['sort_order'] = $this->url->link('product/product', 'token=' . $this->session->data['token'] . '&sort=p.sort_order' . $url, 'SSL');
		
		$url = '';

		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
		}
		
		if (isset($this->request->get['filter_model'])) {
			$url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['filter_printable'])) {
			$url .= '&filter_printable=' . $this->request->get['filter_printable'];
		}

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}
												
		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}
				
		$pagination = new Pagination();
		$pagination->total = $product_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = $this->url->link('product/product', 'token=' . $this->session->data['token'] . $url . '&page={page}', 'SSL');
			
		$this->data['pagination'] = $pagination->render();
	
		$this->data['filter_name'] = $filter_name;
		$this->data['filter_model'] = $filter_model;
		$this->data['filter_status'] = $filter_status;
		$this->data['filter_printable'] = $filter_printable;
		
		$this->data['sort'] = $sort;
		$this->data['order'] = $order;

		$this->template = 'product/product_list.tpl';
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
		 
		$this->data['text_default'] = $this->language->get('text_default');
		$this->data['text_select'] = $this->language->get('text_select');
		$this->data['text_none'] = $this->language->get('text_none');
		$this->data['text_wait'] = $this->language->get('text_wait');
    	$this->data['text_disabled'] = $this->language->get('text_disabled');
    	$this->data['text_enabled'] = $this->language->get('text_enabled');
		
		$this->data['entry_name'] = $this->language->get('entry_name');
		$this->data['entry_model'] = $this->language->get('entry_model');
		$this->data['entry_image'] = $this->language->get('entry_image');
		$this->data['entry_status'] = $this->language->get('entry_status');
		$this->data['entry_printable_status'] = $this->language->get('entry_printable_status');
			
		$this->data['button_save'] = $this->language->get('button_save');
		$this->data['button_cancel'] = $this->language->get('button_cancel');

		$this->data['tab_data'] = $this->language->get('tab_data');
		$this->data['tab_price'] = $this->language->get('tab_price');
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
				
		$url = '';

		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
		}
		
		if (isset($this->request->get['filter_model'])) {
			$url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['filter_printable'])) {
			$url .= '&filter_printable=' . $this->request->get['filter_printable'];
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
       		'text'      => $this->language->get('text_product_list'),
			'href'      => $this->url->link('product/product', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);

		if (!isset($this->request->get['product_id'])) {
			$this->data['action'] = $this->url->link('product/product/insert', 'token=' . $this->session->data['token'] . $url, 'SSL');
		} else {
			$this->data['action'] = $this->url->link('product/product/update', 'token=' . $this->session->data['token'] . '&product_id=' . $this->request->get['product_id'] . $url, 'SSL');
		}
		
		$this->data['cancel'] = $this->url->link('product/product', 'token=' . $this->session->data['token'] . $url, 'SSL');
		
		if (isset($this->request->get['product_id']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			
			$product_info = $this->model_catalog_product->getProduct($this->request->get['product_id']);

			$this->load->model('product/product');
			
			$printable_product_info = $this->model_product_product->getProduct($this->request->get['product_id']);
		}

		if (isset($this->request->get['product_id'])) {
			$this->data['product_description'] = $this->model_catalog_product->getProductDescriptions($this->request->get['product_id']);
		} else {
			$this->data['product_description'] = array();
		}

		$this->load->model('localisation/language');
		
		$this->data['languages'] = $this->model_localisation_language->getLanguages();
				
		if (!empty($product_info)) {
			$this->data['name'] = $product_info['name'];
		} else {
			$this->data['name'] = '';
		}

		if (!empty($product_info)) {
			$this->data['model'] = $product_info['model'];
		} else {
			$this->data['model'] = '';
		}	
		
		if (isset($this->request->post['status'])) {
			$this->data['status'] = $this->request->post['status'];
		} elseif (!empty($product_info)) { 
			$this->data['status'] = $product_info['status'];
		} else {
			$this->data['status'] = '';
		}	

		if (isset($this->request->post['printable_status'])) {
      		$this->data['printable_status'] = $this->request->post['printable_status'];
    	} elseif (!empty($printable_product_info)) {
			$this->data['printable_status'] = $printable_product_info['printable_status'];
		} else {
      		$this->data['printable_status'] = 1;
    	}
		
		if (!empty($product_info)) { 
			$this->data['image'] = $product_info['image'];
		} else {
			$this->data['image'] = '';
		}
		
		$this->load->model('tool/image');
		
		if (!empty($product_info) && $product_info['image'] && file_exists(DIR_IMAGE . $product_info['image'])) {
			$this->data['thumb'] = $this->model_tool_image->resize($product_info['image'], 100, 100);
		} else {
			$this->data['thumb'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);
		}
		
		$this->data['no_image'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);

		$this->template = 'product/product_form.tpl';
		$this->children = array(
			'product/color_size/color_size_tab',
			'product/view/view_tab',
			'product/price/price_tab',
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}
	
	
  	private function validateForm() {
		if (!$this->user->hasPermission('modify', 'product/product')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
		
		if(!isset($this->request->post['colors_number'])) {
			$this->error['colors_number'] = $this->language->get('error_colors_number');
			$this->session->data['error_colors_number'] = $this->language->get('error_colors_number');
		}
		
		if(!isset($this->request->post['color_size'])) {
			$this->error['color_size'] = $this->language->get('error_color_size');
			$this->session->data['error_color_size'] = $this->language->get('error_color_size');
		}
		
		if(!isset($this->request->post['default_color'])) {
			$this->error['error_default_color'] = $this->language->get('error_default_color');
			$this->session->data['error_default_color'] = $this->language->get('error_default_color');
		}
		
		if(!isset($this->request->post['quantities']) || !is_array($this->request->post['quantities'])) {
			$this->error['error_quantities'] = $this->language->get('error_quantities');
			$this->session->data['error_quantities'] = $this->language->get('error_quantities');
		} else {
			foreach($this->request->post['quantities'] as $value) {
				if(!preg_match("/^[0-9]+$/",$value)) {
					$this->error['error_quantities'] = $this->language->get('error_quantities');
					$this->session->data['error_quantities'] = $this->language->get('error_quantities');
				}
			}
		}
		
		if(!isset($this->request->post['price']) || !is_array($this->request->post['price'])) {
			$this->error['error_price'] = $this->language->get('error_price');
			$this->session->data['error_price'] = $this->language->get('error_price');
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
		
		if(isset($this->request->post['upcharge'])) {
			if(!is_array($this->request->post['upcharge'])) {
				$this->error['error_upcharge'] = $this->language->get('error_upcharge');
				$this->session->data['error_upcharge'] = $this->language->get('error_upcharge');
			}
			foreach($this->request->post['upcharge'] as $key=>$value) {
				if(!preg_match("/^[0-9]+(.[0-9]+)?$/",$value)) {
					$this->error['error_upcharge'] = $this->language->get('error_upcharge');
					$this->session->data['error_upcharge'] = $this->language->get('error_upcharge');
				}
			}
		}
		
		if(!isset($this->request->post['default_region'])) {
			$this->error['error_default_region'] = $this->language->get('error_default_region');
			$this->session->data['error_default_region'] = $this->language->get('error_default_region');
		}
		
		if(empty($this->request->post['views'])) {
			$this->error['error_views'] = $this->language->get('error_views');
			$this->session->data['error_views'] = $this->language->get('error_views');
		} else {
			foreach($this->request->post['views'] as $view) {
				if(empty($view['shade']) && empty($view['underfill'])) {
					$this->error['error_view_shade_underfill'] = $this->language->get('error_view_shade_underfill');
					$this->session->data['error_view_shade_underfill'] = $this->language->get('error_view_shade_underfill');
				}
				if(empty($view['fills'])) {
					$this->error['error_view_fills'] = $this->language->get('error_view_fills');
					$this->session->data['error_view_fills'] = $this->language->get('error_view_fills');
				}
				if(empty($view['regions'])) {
					$this->error['error_view_regions'] = $this->language->get('error_view_regions');
					$this->session->data['error_view_regions'] = $this->language->get('error_view_regions');
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
		if (!$this->user->hasPermission('modify', 'product/product')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
 
		if (!$this->error) {
			return true; 
		} else {
			return false;
		}
	}
	private function validateDefault() {
		if (!$this->user->hasPermission('modify', 'product/product')) {
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
