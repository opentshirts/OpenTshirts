<?php
class ControllerFontFont extends Controller {
	private $error = array();

  	public function index() {
		$this->getList();
  	}
	
  	public function _list() {

    	$this->getList();
  	}
	
  	public function insert() {
		$this->load->language('font/form');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('font/font');
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
      	  	
			$id_font = $this->model_font_font->addFont($this->request->post);
						
			$this->session->data['success'] = $this->language->get('text_success');
		  
			$url = '';
			
			if (isset($this->request->get['filter_id_font'])) {
				$url .= '&filter_id_font=' . $this->request->get['filter_id_font'];
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


			$this->redirect($this->url->link('font/font/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
		
    	$this->getForm();
  	}
	
  	public function update() {
		
		$this->load->language('font/form');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('font/font');
		    	
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			
			$this->model_font_font->editFont($this->request->get['id_font'], $this->request->post);
	  		
			$this->session->data['success'] = $this->language->get('text_success');
	  
			$url = '';

			if (isset($this->request->get['filter_id_font'])) {
				$url .= '&filter_id_font=' . $this->request->get['filter_id_font'];
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


			$this->redirect($this->url->link('font/font/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
		
    	$this->getForm();
  	}
	
  	public function delete() {
		
		$this->load->language('font/form');

		if (isset($this->request->post['selected']) && $this->validateDelete()) {
			
			$this->load->model('font/font');
			
			foreach ($this->request->post['selected'] as $id_font) {
				$this->model_font_font->deleteFont($id_font);
			}

			$this->session->data['success'] = $this->language->get('text_success');

			$url = '';
	
			if (isset($this->request->get['filter_id_font'])) {
				$url .= '&filter_id_font=' . $this->request->get['filter_id_font'];
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

			$this->redirect($this->url->link('font/font/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
		$this->getList();
  	}

  	private function getList() {
		
		$this->load->language('font/list');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('font/font');

		$filters = array();
		
		if (isset($this->request->get['filter_id_font'])) {
			$filter_id_font = $this->request->get['filter_id_font'];
			$filters['filter_id_font'] = $filter_id_font;
		} else {
			$filter_id_font = null;
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
			$sort = 'f.date_added';
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

		if (isset($this->request->get['filter_id_font'])) {
			$url .= '&filter_id_font=' . $this->request->get['filter_id_font'];
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
			'href'      => $this->url->link('font/font/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'),
			'separator' => ' :: '
   		);
		$this->data['delete'] = $this->url->link('font/font/delete', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['insert'] = $this->url->link('font/font/insert', 'token=' . $this->session->data['token'] . $url, 'SSL');

		$this->data['fonts'] = array();

		$font_total = $this->model_font_font->getTotalFonts($filters);

		$results = $this->model_font_font->getFonts($filters);
		$this->load->model('font/category');
		$this->load->model('tool/image');
		
    	foreach ($results as $result) {
			$action = array();
						
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => $this->url->link('font/font/update', 'token=' . $this->session->data['token'] . '&id_font=' . $result['id_font'] . $url, 'SSL')
			);
			
			$cats = array();
			foreach($this->model_font_font->getFontCategories($result['id_font']) as $id_category)
			{
				$cats[] = $this->model_font_category->getCategory($id_category);
			}
			
			
			if($result['ttf_file'] && file_exists(DIR_IMAGE . 'data/fonts/' . $result['ttf_file'])) {
				$thumb = $this->url->link('font/ttf2png', "font_source=fonts/".$result['ttf_file']."&display_text=".strtoupper($result['name'])."&token=".$this->session->data['token'], 'SSL');
			} else {
				$thumb = $this->model_tool_image->resize('no_image.jpg', 100, 100);
			}	
			
			
			$this->data['fonts'][] = array(
				'id_font'    => $result['id_font'],
				'name'      	=> $result['name'],
				'status'      	=> ($result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled')),
				'thumb'      	=> $thumb,
				'date_added'    => date($this->language->get('date_format_short'), strtotime($result['date_added'])),
				'categories'    => $cats,
				'keywords'      => $this->model_font_font->getFontKeywords($result['id_font']),
				'selected'      => isset($this->request->post['selected']) && in_array($result['id_font'], $this->request->post['selected']),
				'action'        => $action
			);
		}

		$this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['column_id_font'] = $this->language->get('column_id_font');
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
		$this->data['button_insert'] = $this->language->get('button_add_font');

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

		if (isset($this->request->get['filter_id_font'])) {
			$url .= '&filter_id_font=' . $this->request->get['filter_id_font'];
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

		$this->data['sort_font'] = $this->url->link('font/font/_list', 'token=' . $this->session->data['token'] . '&sort=f.id_font' . $url, 'SSL');
		$this->data['sort_name'] = $this->url->link('font/font/_list', 'token=' . $this->session->data['token'] . '&sort=f.name' . $url, 'SSL');
		$this->data['sort_status'] = $this->url->link('font/font/_list', 'token=' . $this->session->data['token'] . '&sort=f.status' . $url, 'SSL');
		$this->data['sort_date_added'] = $this->url->link('font/font/_list', 'token=' . $this->session->data['token'] . '&sort=f.date_added' . $url, 'SSL');

		$url = '';

		if (isset($this->request->get['filter_id_font'])) {
			$url .= '&filter_id_font=' . $this->request->get['filter_id_font'];
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
		$pagination->total = $font_total;
		$pagination->page = $page;
		$pagination->limit = $limit;
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = $this->url->link('font/font/_list', 'token=' . $this->session->data['token'] . $url . '&page={page}', 'SSL');

		$this->data['pagination'] = $pagination->render();

		$this->data['filter_id_font'] = $filter_id_font;
		$this->data['filter_id_category'] = $filter_id_category;
		$this->data['filter_status'] = $filter_status;
		$this->data['filter_keyword'] = $filter_keyword;
		$this->data['sort'] = $sort;
		$this->data['order'] = $order;
		$this->data['limit'] = $limit;

		$this->load->model('font/category');

    	$this->data['categories'] = $this->model_font_category->getCategoriesByParentId();
		
		$this->data['statuses'] = array();
		$this->data['statuses'][] = array('val'=>'', 'description'=>$this->language->get('text_none'));
		$this->data['statuses'][] = array('val'=>'1', 'description'=>$this->language->get('text_enabled'));
		$this->data['statuses'][] = array('val'=>'0', 'description'=>$this->language->get('text_disabled'));

		$this->template = 'font/list.tpl';
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
		$this->data['entry_swf_file'] = $this->language->get('entry_swf_file');
		$this->data['entry_ttf_file'] = $this->language->get('entry_ttf_file');
		$this->data['entry_status'] = $this->language->get('entry_status');
			
		$this->data['button_save'] = $this->language->get('button_save');
		$this->data['button_cancel'] = $this->language->get('button_cancel');
		$this->data['button_add_font'] = $this->language->get('button_add_font');
		$this->data['button_remove'] = $this->language->get('button_remove');
		$this->data['button_upload'] = $this->language->get('button_upload');

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
				
 		if (isset($this->error['ttf_file'])) {
			$this->data['error_ttf_file'] = $this->error['ttf_file'];
		} else {
			$this->data['error_ttf_file'] = '';
		}
				
 		if (isset($this->error['swf_file'])) {
			$this->data['error_swf_file'] = $this->error['swf_file'];
		} else {
			$this->data['error_swf_file'] = '';
		}
				
		$url = '';

		if (isset($this->request->get['filter_id_font'])) {
			$url .= '&filter_id_font=' . $this->request->get['filter_id_font'];
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
       		'text'      => $this->language->get('text_font_list'),
			'href'      => $this->url->link('font/font/_list', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);


		if (!isset($this->request->get['id_font'])) {
			$this->data['breadcrumbs'][] = array(
				'text'      => $this->language->get('heading_title'),
				'href'      => $this->url->link('font/font/insert', 'token=' . $this->session->data['token'] . $url, 'SSL'),				
				'separator' => ' :: '
			);
			$this->data['action'] = $this->url->link('font/font/insert', 'token=' . $this->session->data['token'] . $url, 'SSL');
		} else {
			$this->data['breadcrumbs'][] = array(
				'text'      => $this->language->get('heading_title'),
				'href'      => $this->url->link('font/font/update', 'token=' . $this->session->data['token'] . '&id_font=' . $this->request->get['id_font'] . $url, 'SSL'),				
				'separator' => ' :: '
			);
			$this->data['action'] = $this->url->link('font/font/update', 'token=' . $this->session->data['token'] . '&id_font=' . $this->request->get['id_font'] . $url, 'SSL');
		}
		
		$this->data['cancel'] = $this->url->link('font/font/_list', 'token=' . $this->session->data['token'] . $url, 'SSL');
		
		$this->load->model('tool/image');
		
		if (isset($this->request->get['id_font']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			
			$result = $this->model_font_font->getFont($this->request->get['id_font']);	
			
			if($result['ttf_file'] && file_exists(DIR_IMAGE . 'data/fonts/' . $result['ttf_file'])) {
				$thumb = $this->url->link('font/ttf2png', "font_source=fonts/".$result['ttf_file']."&display_text=".strtoupper($result['name'])."&token=".$this->session->data['token'], 'SSL');
			} else {
				$thumb = $this->model_tool_image->resize('no_image.jpg', 100, 100);
			}	
			$font_info = array(
				'id_font'		=> $result['id_font'],
				'name'      	=> $result['name'],
				'thumb'    		=> $thumb,
				'swf_file'      => $result['swf_file'],
				'ttf_file'      => $result['ttf_file'],
				'status'      	=> $result['status'],
				'keywords'      => implode(",",$this->model_font_font->getFontKeywords($result['id_font']))
			);
		}
				
		if (isset($this->request->post['name'])) {
			$this->data['name'] = $this->request->post['name'];
		} elseif (!empty($font_info)) {
			$this->data['name'] = $font_info['name'];
		} else {
			$this->data['name'] = '';
		}
				
		if (isset($this->request->post['status'])) {
			$this->data['status'] = $this->request->post['status'];
		} elseif (!empty($font_info)) { 
			$this->data['status'] = $font_info['status'];
		} else {
			$this->data['status'] = '';
		}	
		
		if (isset($this->request->post['keywords'])) {
			$this->data['keywords'] = $this->request->post['keywords'];
		} elseif (!empty($font_info)) { 
			$this->data['keywords'] = $font_info['keywords'];
		} else {
			$this->data['keywords'] = '';
		}	
		
		if (isset($this->request->post['swf_file'])) {
			$this->data['swf_file'] = $this->request->post['swf_file'];
		} elseif (!empty($font_info)) { 
			$this->data['swf_file'] = $font_info['swf_file'];
		} else {
			$this->data['swf_file'] = '';
		}
		
		if (isset($this->request->post['ttf_file'])) {
			$this->data['ttf_file'] = $this->request->post['ttf_file'];
		} elseif (!empty($font_info)) { 
			$this->data['ttf_file'] = $font_info['ttf_file'];
		} else {
			$this->data['ttf_file'] = '';
		}
		
		
		
		if (isset($this->request->post['ttf_file'])) {
			$this->data['thumb'] = $this->url->link('font/ttf2png', "font_source=fonts/".$this->request->post['ttf_file']."&display_text=Sample&token=".$this->session->data['token'], 'SSL');
		} elseif (!empty($font_info)) {
			$this->data['thumb'] = $font_info['thumb'];
		} else {
			$this->data['thumb'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);
		}
		
		$this->data['statuses'] = array();
		$this->data['statuses'][] = array('val'=>'1', 'description'=>$this->language->get('text_enabled'));
		$this->data['statuses'][] = array('val'=>'0', 'description'=>$this->language->get('text_disabled'));

		$this->template = 'font/form.tpl';
		$this->children = array(
			'font/category/category_tab',
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}
	
	
  	private function validateForm() {
		if (!$this->user->hasPermission('modify', 'font/font')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
 
		if ((utf8_strlen($this->request->post['name']) < 1) || (utf8_strlen($this->request->post['name']) > 255)) {
			$this->error['name'] = $this->language->get('error_name');
		}
		
		if ((utf8_strlen($this->request->post['swf_file']) < 1) || (utf8_strlen($this->request->post['swf_file']) > 255)) {
			$this->error['swf_file'] = $this->language->get('error_swf_file');
		}
		
		if ((utf8_strlen($this->request->post['ttf_file']) < 1) || (utf8_strlen($this->request->post['ttf_file']) > 255)) {
			$this->error['ttf_file'] = $this->language->get('error_ttf_file');
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
		if (!$this->user->hasPermission('modify', 'font/font')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
 
		if (!$this->error) {
			return true; 
		} else {
			return false;
		}
	}



	public function upload_ttf() {
		
		$this->language->load('font/form');
		
		$json = array();
		
		if (!empty($this->request->files['file']['name'])) {
			$filename = html_entity_decode($this->request->files['file']['name'], ENT_QUOTES, 'UTF-8');
			
			if ((strlen($filename) < 3) || (strlen($filename) > 128)) {
        		$json['error'] = $this->language->get('error_filename');
	  		}	  	
			
			$allowed = array();
			
			$filetypes = explode(',', 'ttf,otf,TTF,OTF');
			
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
		
		if (!$this->user->hasPermission('modify', 'font/font')) {
			$json['error'] = $this->language->get('error_permission');
		}
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && !isset($json['error'])) {
			if (is_uploaded_file($this->request->files['file']['tmp_name']) && file_exists($this->request->files['file']['tmp_name'])) {
				//$file = md5(rand()) . '-' . basename($filename) ;
				$file = basename($filename) ;
				
				if(move_uploaded_file($this->request->files['file']['tmp_name'], DIR_IMAGE . 'data/fonts/' . $file))
				{
					$json['filename'] = $file;
					
					$json['file'] = html_entity_decode($this->url->link('font/ttf2png', "font_source=fonts/".$file."&display_text=Sample&token=".$this->session->data['token'], 'SSL'));
					
					$json['success'] = $this->language->get('text_upload');
				} else {
					$json['error'] = $this->language->get('error_upload');
				}
			
			}
		}	

		$this->response->setOutput(json_encode($json));		
	}

	public function upload_swf() {
		
		$this->language->load('font/form');
		
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
		
		if (!$this->user->hasPermission('modify', 'font/font')) {
			$json['error'] = $this->language->get('error_permission');
		}
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && !isset($json['error'])) {
			if (is_uploaded_file($this->request->files['file']['tmp_name']) && file_exists($this->request->files['file']['tmp_name'])) {
				//$file = md5(rand()) . '-' . basename($filename) ;
				$file = basename($filename) ;
				
				if(move_uploaded_file($this->request->files['file']['tmp_name'], DIR_IMAGE . 'data/fonts/' . $file))
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
			
}
?>