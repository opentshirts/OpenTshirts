<?php
class ControllerFontCategory extends Controller {
	private $error = array();

  	public function index() {

    	$this->getList();
  	}
	
	public function insert() {
		$this->load->language('font/category');
		
		$this->load->model('font/category');
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			$this->model_font_category->addCategory($this->request->post);

			$this->session->data['success'] = $this->language->get('text_success');
			
			$this->redirect($this->url->link('font/category', 'token=' . $this->session->data['token'], 'SSL')); 
		}

		$this->getForm();
	}

	public function update() {
		$this->load->language('font/category');
		
		$this->load->model('font/category');
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			$this->model_font_category->editCategory($this->request->get['id_category'], $this->request->post);
			
			$this->session->data['success'] = $this->language->get('text_success');
			
			$this->redirect($this->url->link('font/category', 'token=' . $this->session->data['token'], 'SSL'));
		}

		$this->getForm();
	}

	public function delete() {
		$this->load->language('font/category');
		
		$this->load->model('font/category');
		
		if (isset($this->request->post['selected']) && $this->validateDelete()) {
			foreach ($this->request->post['selected'] as $id_category) {
				$this->model_font_category->deleteCategory($id_category);
			}

			$this->session->data['success'] = $this->language->get('text_success');

			$this->redirect($this->url->link('font/category', 'token=' . $this->session->data['token'], 'SSL'));
		}

		$this->getList();
	}
	
	private function getList() {
		$this->load->language('font/category');
		
		$this->load->model('font/category');
		
		$this->document->setTitle($this->language->get('heading_title'));

		$this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('font/category', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);


		if (isset($this->request->post['selected'])) {
			$this->data['selected'] = $this->request->post['selected'];
		} else {
			$this->data['selected'] = array();
		}
		
		$this->data['categories'] = $this->recursiveCategories($this->model_font_category->getCategoriesByParentId());
		
		$this->data['delete'] = $this->url->link('font/category/delete', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['insert'] = $this->url->link('font/category/insert', 'token=' . $this->session->data['token'] , 'SSL');
		
		$this->data['column_name'] = $this->language->get('column_name');
		$this->data['column_action'] = $this->language->get('column_action');
		$this->data['button_delete'] = $this->language->get('button_delete');
		$this->data['button_insert'] = $this->language->get('button_add_category');
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

		$this->template = 'font/category_list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
		
	}
	
	private function recursiveCategories($categories, $level=0) {
		$category_data = array();
		foreach ($categories as $category) {
			$action = array();
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => $this->url->link('font/category/update', 'token=' . $this->session->data['token'] . '&id_category=' . $category['id_category'] , 'SSL')
			);		
			$indent = '';
			for($i=0; $i<$level; $i++) { 
				$indent .= "&nbsp;---&nbsp;"; 
			}

			$category_data[] = array(	
				'id_category' => $category['id_category'],
				'description' => $indent.$category['description'],
				'selected'    => isset($this->request->post['selected']) && in_array($category['id_category'], $this->request->post['selected']),
				'action' 	  => $action
			);
		
			$category_data = array_merge($category_data, $this->recursiveCategories($category['children'], $level+1));
		}	
		return $category_data;
	}
	
	private function getForm() {
		$this->load->language('font/category');
		
		$this->load->model('font/category');
		
		$this->document->setTitle($this->language->get('heading_title'));
		
		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('font/category', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);

		$this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['text_root'] = $this->language->get('text_root');
				
		$this->data['entry_description'] = $this->language->get('entry_description');
		$this->data['entry_parent'] = $this->language->get('entry_parent');

		$this->data['tab_data'] = $this->language->get('tab_data');
		
		$this->data['button_save'] = $this->language->get('button_save');
		$this->data['button_cancel'] = $this->language->get('button_cancel');
		
 		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}
	
 		if (isset($this->error['description'])) {
			$this->data['error_description'] = $this->error['description'];
		} else {
			$this->data['error_description'] = '';
		}

		
		if (!isset($this->request->get['id_category'])) {
			$this->data['action'] = $this->url->link('font/category/insert', 'token=' . $this->session->data['token'], 'SSL');
		} else {
			$this->data['action'] = $this->url->link('font/category/update', 'token=' . $this->session->data['token'] . '&id_category=' . $this->request->get['id_category'], 'SSL');
		}
		
		$this->data['cancel'] = $this->url->link('font/category', 'token=' . $this->session->data['token'], 'SSL');

		$this->data['token'] = $this->session->data['token'];

		if (isset($this->request->get['id_category']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
      		$category_info = $this->model_font_category->getCategory($this->request->get['id_category']);
    	}
		
		$categories = $this->recursiveCategories($this->model_font_category->getCategoriesByParentId(), 1);

		// Remove own id from list
		if (!empty($category_info)) {
			foreach ($categories as $key => $category) {
				if ($category['id_category'] == $category_info['id_category']) {
					unset($categories[$key]);
				}
			}
		}

		$this->data['categories'] = $categories;

		if (isset($this->request->post['parent_category'])) {
			$this->data['parent_category'] = $this->request->post['parent_category'];
		} elseif (!empty($category_info)) {
			$this->data['parent_category'] = $category_info['parent_category'];
		} else {
			$this->data['parent_category'] = '';
		}
		
		if (isset($this->request->post['description'])) {
			$this->data['description'] = $this->request->post['description'];
		} elseif (!empty($category_info)) {
			$this->data['description'] = $category_info['description'];
		} else {
			$this->data['description'] = '';
		}
						
		$this->template = 'font/category_form.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}

	private function validateForm() {
		if (!$this->user->hasPermission('modify', 'font/category')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
 
		if ((utf8_strlen($this->request->post['description']) < 2) || (utf8_strlen($this->request->post['description']) > 255)) {
			$this->error['description'] = $this->language->get('error_description');
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
		if (!$this->user->hasPermission('modify', 'font/category')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
 
		if (!$this->error) {
			return true; 
		} else {
			return false;
		}
	}

  	public function category_tab() {
		
		$this->load->language('font/category_tab');
		
		$this->load->model('font/category');

		$this->data['selected'] = array();
		if (isset($this->request->get['id_font']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			
			$this->load->model('font/font');

			$selected_categories = $this->model_font_font->getFontCategories($this->request->get['id_font']);
		}
		
		if (isset($this->request->post['selected_categories'])) {
			$this->data['selected_categories'] = $this->request->post['selected_categories'];
		} elseif (!empty($selected_categories)) { 
			$this->data['selected_categories'] = $selected_categories;
		} else {
			$this->data['selected_categories'] = array();
		}

		$this->data['categories'] = $this->model_font_category->getCategoriesByParentId();
		
		$this->data['text_no_results'] = $this->language->get('text_no_results');
		$this->data['text_autoselect_parent'] = $this->language->get('text_autoselect_parent');
		$this->data['text_root'] = $this->language->get('text_root');
		$this->data['text_select_all'] = $this->language->get('text_select_all');
		$this->data['text_unselect_all'] = $this->language->get('text_unselect_all');

		$this->data['token'] = $this->session->data['token'];

		$this->template = 'font/category_tab.tpl';
		
		$this->response->setOutput($this->render());
  	}
			
}
?>