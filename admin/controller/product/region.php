<?php
class ControllerProductRegion extends Controller {
	
  	public function form($data = array()) {
		
		$this->load->language('product/region');
		
		$this->data['length_unit'] = $this->length->getUnit($this->config->get('config_length_class_id'));
		$this->data['entry_name'] = $this->language->get('entry_name');
		$this->data['entry_width'] = sprintf($this->language->get('entry_width'),$this->data['length_unit']);
		$this->data['entry_height'] = sprintf($this->language->get('entry_height'),$this->data['length_unit']);
		$this->data['button_remove'] = $this->language->get('button_remove');
		$this->data['button_mask'] = $this->language->get('button_mask');
		
		$this->data['text_x'] = $this->language->get('text_x');
		$this->data['text_y'] = $this->language->get('text_y');
		$this->data['text_default'] = $this->language->get('text_default');
		$this->data['text_mask'] = $this->language->get('text_mask');
		$this->data['text_clear'] = $this->language->get('text_clear');
		

		$this->data['token'] = $this->session->data['token'];
		
		if (!empty($this->request->get['product_id']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			$this->load->model('product/product');
			$product = $this->model_product_product->getProduct($this->request->get['product_id']);	
			$default_region = $product['default_view'].'_'.$product['default_region'];
		}
		

		if (!empty($data)) {
			$view_index = $data['view_index'];
			$region_index = $data['region_index'];
			$name = $data['name'];
			$x = $data['x'];
			$y = $data['y'];
			$width = $data['width'];
			$height = $data['height'];
			$mask = $data['mask'];
		}

		if (isset($view_index)) { 
			$this->data['view_index'] = $view_index;
		} else {
			$this->data['view_index'] = $this->request->get['view_index'];
		}
		
		if (isset($region_index)) { 
			$this->data['region_index'] = $region_index;
		} else {
			$this->data['region_index'] = mt_rand();
		}
		
		if (!empty($name)) { 
			$this->data['name'] = $name;
		} else {
			$this->data['name'] = 'print area';
		}
		
		if (!empty($x)) { 
			$this->data['x'] = $x;
		} else {
			$this->data['x'] = '10';
		}
		
		if (!empty($y)) { 
			$this->data['y'] = $y;
		} else {
			$this->data['y'] = '15';
		}

		if (!empty($width)) { 
			$this->data['width'] = $width;
		} else {
			$this->data['width'] = '10';
		}

		if (!empty($height)) { 
			$this->data['height'] = $height;
		} else {
			$this->data['height'] = '10';
		}

		$this->load->model('tool/image');
		$this->data['no_image'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);

		if (!empty($mask)) { 
			$this->data['mask'] = $mask;
			$this->data['thumb_mask'] = $this->model_tool_image->resize('data/products/' .$mask, 100, 100);
			$this->data['mask_url'] = HTTPS_CATALOG . 'image/data/products/' . $mask;
		} else {
			$this->data['mask'] = '';
			$this->data['thumb_mask'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);
			$this->data['mask_url'] = '';
		}

		if (isset($this->request->post['default_region'])) { 
			$this->data['default_region'] = $this->request->post['default_region'];
		} else if (isset($default_region)) { 
			$this->data['default_region'] = $default_region;
		} else {
			$this->data['default_region'] = '';
		}
		
		$this->template = 'product/region_item.tpl';
		$this->response->setOutput($this->render());

	}

	public function upload_mask() {
		
		$this->language->load('product/form');
		
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
		
		if (!$this->user->hasPermission('modify', 'product/product')) {
			$json['error'] = $this->language->get('error_permission');
		}
 
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && !isset($json['error'])) {
			if (is_uploaded_file($this->request->files['file']['tmp_name']) && file_exists($this->request->files['file']['tmp_name'])) {
				$file = md5(rand()) . '-' . basename($filename) ;
				
				if(move_uploaded_file($this->request->files['file']['tmp_name'], DIR_IMAGE . 'data/products/' . $file))
				{
					$json['filename'] = $file;
					$json['image'] = HTTPS_CATALOG . 'image/data/products/' . $file;
					
					$this->load->model('tool/image');
		
					$json['thumb'] = $this->model_tool_image->resize('data/products/' .$file, 100, 100);
					
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