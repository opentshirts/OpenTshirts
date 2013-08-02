<?php
class ControllerOpentshirtsProductExport extends Controller {
	private $error = array();

  	public function index() {
		$this->load->language('catalog/product');
		$this->load->language('opentshirts/product_export');
    	
		$this->document->setTitle($this->language->get('heading_title')); 
		
		$this->load->model('catalog/product');
		
		$this->getList();
  	}

  	public function form() {

  		$this->load->language('opentshirts/product_export');

		$this->document->setTitle($this->language->get('heading_title'));
		$this->document->addScript('view/javascript/uploadify/swfobject.js');
		$this->document->addScript('view/javascript/uploadify/jquery.uploadify.v2.1.4.min.js');
		$this->document->addStyle('view/javascript/uploadify/uploadify.css');

		$this->data['heading_title'] = $this->language->get('heading_title');
		$this->data['button_upload'] = $this->language->get('button_upload');
		$this->data['token'] = $this->session->data['token'];
		$this->data['heading_title'] = $this->language->get('heading_title');
		$this->data['text_wait'] = $this->language->get('text_wait');
		
		$this->data['text_upload_max_filesize'] = $this->language->get('text_upload_max_filesize');
		$this->data['text_post_max_size'] = $this->language->get('text_post_max_size');
		$this->data['text_memory_limit'] = $this->language->get('text_memory_limit');
		$this->data['text_max_execution_time'] = $this->language->get('text_max_execution_time');
		$this->data['text_overwrite'] = $this->language->get('text_overwrite');
		

		$this->data['breadcrumbs'] = array();

		$this->data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
			'separator' => false
		);

		$this->data['breadcrumbs'][] = array(
			'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('opentshirts/product_export', 'token=' . $this->session->data['token'], 'SSL'),				
			'separator' => ' :: '
		);
		
		$this->template = 'opentshirts/product_export_form.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}

  	private function getList() {				
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
		
		if (isset($this->request->get['filter_price'])) {
			$filter_price = $this->request->get['filter_price'];
		} else {
			$filter_price = null;
		}

		if (isset($this->request->get['filter_quantity'])) {
			$filter_quantity = $this->request->get['filter_quantity'];
		} else {
			$filter_quantity = null;
		}

		if (isset($this->request->get['filter_status'])) {
			$filter_status = $this->request->get['filter_status'];
		} else {
			$filter_status = null;
		}
		
		if (isset($this->request->get['limit'])) {
			$limit = $this->request->get['limit'];
		} else {
			$limit = 9999999999;
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
		
		if (isset($this->request->get['filter_price'])) {
			$url .= '&filter_price=' . $this->request->get['filter_price'];
		}
		
		if (isset($this->request->get['filter_quantity'])) {
			$url .= '&filter_quantity=' . $this->request->get['filter_quantity'];
		}		

		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['limit'])) {
			$url .= '&limit=' . $this->request->get['limit'];
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
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('catalog/product', 'token=' . $this->session->data['token'] . $url, 'SSL'),       		
      		'separator' => ' :: '
   		);
		
		$this->data['generate'] = $this->url->link('opentshirts/product_export/generate', 'token=' . $this->session->data['token'] . $url, 'SSL');
    	
		$this->data['products'] = array();

		$data = array(
			'filter_name'	  => $filter_name, 
			'filter_model'	  => $filter_model,
			'filter_price'	  => $filter_price,
			'filter_quantity' => $filter_quantity,
			'filter_status'   => $filter_status,
			'sort'            => $sort,
			'order'           => $order,
			'start'           => ($page - 1) * $limit,
			'limit'           => $limit
		);
		
		$this->load->model('tool/image');
		
		$product_total = $this->model_catalog_product->getTotalProducts($data);
			
		$results = $this->model_catalog_product->getProducts($data);
				    	
		foreach ($results as $result) {
			
			if ($result['image'] && file_exists(DIR_IMAGE . $result['image'])) {
				$image = $this->model_tool_image->resize($result['image'], 40, 40);
			} else {
				$image = $this->model_tool_image->resize('no_image.jpg', 40, 40);
			}
	
			$special = false;
			
			$product_specials = $this->model_catalog_product->getProductSpecials($result['product_id']);
			
			foreach ($product_specials  as $product_special) {
				if (($product_special['date_start'] == '0000-00-00' || $product_special['date_start'] < date('Y-m-d')) && ($product_special['date_end'] == '0000-00-00' || $product_special['date_end'] > date('Y-m-d'))) {
					$special = $product_special['price'];
			
					break;
				}					
			}
	
      		$this->data['products'][] = array(
				'product_id' => $result['product_id'],
				'name'       => $result['name'],
				'model'      => $result['model'],
				'price'      => $result['price'],
				'special'    => $special,
				'image'      => $image,
				'quantity'   => $result['quantity'],
				'status'     => ($result['status'] ? $this->language->get('text_enabled') : $this->language->get('text_disabled')),
				'selected'   => isset($this->request->post['selected']) && in_array($result['product_id'], $this->request->post['selected'])
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
		$this->data['column_action'] = $this->language->get('column_action');		
				
		$this->data['entry_limit'] = $this->language->get('entry_limit');		
				
		$this->data['button_generate'] = $this->language->get('button_generate');	
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

		if (isset($this->session->data['product_export_link'])) {
			$this->data['product_export_link'] = $this->session->data['product_export_link'];
		
			unset($this->session->data['product_export_link']);
		} else {
			$this->data['product_export_link'] = '';
		}

		$url = '';

		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
		}
		
		if (isset($this->request->get['filter_model'])) {
			$url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
		}
		
		if (isset($this->request->get['filter_price'])) {
			$url .= '&filter_price=' . $this->request->get['filter_price'];
		}
		
		if (isset($this->request->get['filter_quantity'])) {
			$url .= '&filter_quantity=' . $this->request->get['filter_quantity'];
		}
		
		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['limit'])) {
			$url .= '&limit=' . $this->request->get['limit'];
		}
								
		if ($order == 'ASC') {
			$url .= '&order=DESC';
		} else {
			$url .= '&order=ASC';
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}
					
		$this->data['sort_name'] = $this->url->link('opentshirts/product_export', 'token=' . $this->session->data['token'] . '&sort=pd.name' . $url, 'SSL');
		$this->data['sort_model'] = $this->url->link('opentshirts/product_export', 'token=' . $this->session->data['token'] . '&sort=p.model' . $url, 'SSL');
		$this->data['sort_price'] = $this->url->link('opentshirts/product_export', 'token=' . $this->session->data['token'] . '&sort=p.price' . $url, 'SSL');
		$this->data['sort_quantity'] = $this->url->link('opentshirts/product_export', 'token=' . $this->session->data['token'] . '&sort=p.quantity' . $url, 'SSL');
		$this->data['sort_status'] = $this->url->link('opentshirts/product_export', 'token=' . $this->session->data['token'] . '&sort=p.status' . $url, 'SSL');
		$this->data['sort_order'] = $this->url->link('opentshirts/product_export', 'token=' . $this->session->data['token'] . '&sort=p.sort_order' . $url, 'SSL');
		
		$url = '';

		if (isset($this->request->get['filter_name'])) {
			$url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
		}
		
		if (isset($this->request->get['filter_model'])) {
			$url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
		}
		
		if (isset($this->request->get['filter_price'])) {
			$url .= '&filter_price=' . $this->request->get['filter_price'];
		}
		
		if (isset($this->request->get['filter_quantity'])) {
			$url .= '&filter_quantity=' . $this->request->get['filter_quantity'];
		}

		if (isset($this->request->get['filter_status'])) {
			$url .= '&filter_status=' . $this->request->get['filter_status'];
		}

		if (isset($this->request->get['limit'])) {
			$url .= '&limit=' . $this->request->get['limit'];
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
		$pagination->limit = $limit;
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = $this->url->link('opentshirts/product_export', 'token=' . $this->session->data['token'] . $url . '&page={page}', 'SSL');
			
		$this->data['pagination'] = $pagination->render();
	
		$this->data['filter_name'] = $filter_name;
		$this->data['filter_model'] = $filter_model;
		$this->data['filter_price'] = $filter_price;
		$this->data['filter_quantity'] = $filter_quantity;
		$this->data['filter_status'] = $filter_status;
		
		$this->data['limit'] = $limit;
		$this->data['sort'] = $sort;
		$this->data['order'] = $order;

		$this->template = 'opentshirts/product_export_list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
  	}

	
  	public function generate() {
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST' && !empty($this->request->post['selected']))) {
			
			$this->load->model('opentshirts/product_export');
			$this->load->model('catalog/product');

			$this->load->language('opentshirts/product_export');
      	  	
			$json = array();
			$files = array();
			foreach ($this->request->post['selected'] as $product_id)
			{
				$json[] = $this->model_opentshirts_product_export->dump($product_id);
				$files = array_merge($files, $this->model_opentshirts_product_export->get_files($product_id));
			}
			$fp = fopen('data_products.json', 'w');
			fwrite($fp, json_encode($json));
			fclose($fp);
			
			$files[] = array('source'=>'data_products.json', 'dest'=>'data_products.json');
			
			///generate categories
			$json_categories = array();
			$categories = array();
			foreach ($this->request->post['selected'] as $product_id)
			{
				$result_categories = $this->model_catalog_product->getProductCategories($product_id);
				foreach ($result_categories as $category_id) {
					if(!in_array($category_id,$categories)) {
						$categories[] = $category_id;
					}
				}
			}
			foreach ($categories as $category_id)
			{
				$json_categories[] = $this->model_opentshirts_product_export->dump_category($category_id);
				$files = array_merge($files, $this->model_opentshirts_product_export->dump_category_files($category_id));
			}
			$fp = fopen('data_categories.json', 'w');
			fwrite($fp, json_encode($json_categories));
			fclose($fp);
			
			$files[] = array('source'=>'data_categories.json', 'dest'=>'data_categories.json');
			/// end generate categories

			///generate colors
			$json_colors = array();
			$colors = array();
			$this->load->model('product/product');
			foreach ($this->request->post['selected'] as $product_id)
			{
				$result_colors = $this->model_product_product->getColors($product_id);
				foreach ($result_colors as $id_product_color) {
					if(!in_array($id_product_color,$colors)) {
						$colors[] = $id_product_color;
					}
				}
			}
			foreach ($colors as $id_product_color)
			{
				$json_colors[] = $this->model_opentshirts_product_export->dump_product_color($id_product_color);
			}
			$fp = fopen('data_colors.json', 'w');
			fwrite($fp, json_encode($json_colors));
			fclose($fp);
			
			$files[] = array('source'=>'data_colors.json', 'dest'=>'data_colors.json');
			/// end generate colors

			///generate sizes
			$json_sizes = array();
			$sizes = array();
			$this->load->model('product/product');
			foreach ($this->request->post['selected'] as $product_id)
			{
				$result_sizes = $this->model_product_product->getSizes($product_id);
				foreach ($result_sizes as $id_product_size) {
					if(!in_array($id_product_size,$sizes)) {
						$sizes[] = $id_product_size;
					}
				}
			}
			foreach ($sizes as $id_product_size)
			{
				$json_sizes[] = $this->model_opentshirts_product_export->dump_product_size($id_product_size);
			}
			$fp = fopen('data_sizes.json', 'w');
			fwrite($fp, json_encode($json_sizes));
			fclose($fp);
			
			$files[] = array('source'=>'data_sizes.json', 'dest'=>'data_sizes.json');
			/// end generate sizes
			
			///generate manufacturers
			$json_manufacturers = array();
			$manufacturers = array();
			foreach ($this->request->post['selected'] as $product_id)
			{
				$result = $this->model_catalog_product->getProduct($product_id);
				$manufacturer_id = $result['manufacturer_id'];
				if($manufacturer_id) {
					if(!in_array($manufacturer_id,$manufacturers)) {
						$manufacturers[] = $manufacturer_id;
					}
				}
			}
			foreach ($manufacturers as $manufacturer_id)
			{
				$json_manufacturers[] = $this->model_opentshirts_product_export->dump_manufacturer($manufacturer_id);
				$files = array_merge($files, $this->model_opentshirts_product_export->dump_manufacturer_files($manufacturer_id));
			}
			$fp = fopen('data_manufacturers.json', 'w');
			fwrite($fp, json_encode($json_manufacturers));
			fclose($fp);
			
			$files[] = array('source'=>'data_manufacturers.json', 'dest'=>'data_manufacturers.json');
			/// end generate manufacturers
			
			$date = date('Y-m-d G-i-s');
			$part = (isset($this->request->get['page']))?"part-".$this->request->get['page'].'-':'';
			$installer = DIR_DOWNLOAD . 'product-export-'. $part . $date.'.zip';
			$this->load->library('zip');
			$zip = new Zip();
			$zip->create_zip($files,$installer, false);
			
			$this->session->data['product_export_link'] = HTTP_CATALOG . basename(DIR_DOWNLOAD) . '/' . basename($installer);
			$this->session->data['success'] = $this->language->get('text_success');

			@unlink('data_products.json');
			@unlink('data_categories.json');
			@unlink('data_colors.json');
			@unlink('data_sizes.json');
			@unlink('data_manufacturers.json');			
		}
		
    	$this->index();
  	}


  	public function import() {

		$this->language->load('opentshirts/product_export');

		$this->load->model('opentshirts/product_export');
		
		if (!isset($this->request->files['Filedata'])) {
			$response = $this->language->get('error_upload_post');
		} elseif ($this->request->files['Filedata']['error'] != UPLOAD_ERR_OK) {
			$response = $this->language->get('error_upload_' . $this->request->files['Filedata']['error']);
		}
		
		if (!$this->user->hasPermission('modify', 'opentshirts/product_export')) {
			$response = $this->language->get('error_permission');
		}
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && !isset($response)) {
			$response = $this->language->get('nothing');
			if (is_uploaded_file($this->request->files['Filedata']['tmp_name']) && file_exists($this->request->files['Filedata']['tmp_name'])) {
				//ob_start();
				$msg = '';
				$updated_ids = array();
				$updated_ids['categories'] = $this->importCategories(); // key = "id on json file" --- value = "id inserted on this new DB"
				$updated_ids['manufacturers'] = $this->importManufacturers(); // key = "id on json file" --- value = "id inserted on this new DB"
				$updated_ids['colors'] = $this->importColors(); // key = "id on json file" --- value = "id inserted on this new DB"
				$updated_ids['sizes'] = $this->importSizes(); // key = "id on json file" --- value = "id inserted on this new DB"
				//print_r($updated_ids['categories']);
				if($r = $this->importProducts($updated_ids)) {
					$msg .= $r;
				}

				//ob_end_clean();	

				

				if(!empty($msg))
				{
					$response = $msg;
				}

				$response .= '[' . $this->request->files['Filedata']['name'] . ']';
				
			}
		}
		
		$this->response->setOutput($response);
	}	
	
	
	
	private function importProducts($updated_ids)
	{
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'data_products.json'))
		{
			$this->load->model('install/product');
			
			$products = json_decode($file, true);

			foreach($products as $product)
			{
				$this->model_opentshirts_product_export->import_product($product,$this->request->files['Filedata']['tmp_name'], $updated_ids);	
			}

			$response = $this->language->get('product_install_sucess');
			
			return $response;
		} else {
			return false;
		}
	}
	
	private function importCategories()
	{
		$categories_update = array();
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'data_categories.json'))
		{
			
			$product_categories = json_decode($file, true);
			
			foreach($product_categories as $category)
			{
				$categories_update[$category['category']['category_id']] = $this->model_opentshirts_product_export->import_category($category,$this->request->files['Filedata']['tmp_name']);	
			}
			//update parents
			foreach($product_categories as $category)
			{
				if($category['category']['parent_id']) {
					$this->model_opentshirts_product_export->update_category_parent($categories_update[$category['category']['category_id']], $categories_update[$category['category']['parent_id']]);
				}	
			}
		} 
		return $categories_update;
	}
	
	
	private function importColors()
	{
		$colors_update = array();
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'data_colors.json'))
		{
			
			$product_colors = json_decode($file, true);
			
			foreach($product_colors as $color)
			{
				$colors_update[$color['color']['id_product_color']] = $this->model_opentshirts_product_export->import_color($color);	
			}
		} 
		return $colors_update;
	}

	private function importSizes()
	{
		$sizes_update = array();
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'data_sizes.json'))
		{
			
			$product_sizes = json_decode($file, true);
			
			foreach($product_sizes as $size)
			{
				$sizes_update[$size['id_product_size']] = $this->model_opentshirts_product_export->import_size($size);	
			}
		} 
		return $sizes_update;
	}
	
	private function importManufacturers()
	{
		$manufacturers_update = array();
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'data_manufacturers.json'))
		{
			
			$product_manufacturers = json_decode($file, true);
			
			foreach($product_manufacturers as $manufacturer)
			{
				$manufacturers_update[$manufacturer['manufacturer']['manufacturer_id']] = $this->model_opentshirts_product_export->import_manufacturer($manufacturer,$this->request->files['Filedata']['tmp_name']);	
			}
		} 
		return $manufacturers_update;
	}
			
}
?>