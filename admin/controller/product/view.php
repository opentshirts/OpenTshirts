<?php
class ControllerProductView extends Controller {
	private $error = array();

  	public function index() {

    	$this->getList();
  	}
	
  	public function view_tab() {
		
		$this->load->language('product/view');


		$this->data['text_help_create_views_header'] = $this->language->get('text_help_create_views_header');
		$this->data['text_help_create_views_body'] = $this->language->get('text_help_create_views_body');
		$this->data['button_add_view'] = $this->language->get('button_add_view');
		
		if (isset($this->request->get['product_id']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			$this->load->model('product/view');
			$this->load->model('product/region');
			$this->load->model('product/fill');
			
			$views = array();
			$result = $this->model_product_view->getViews(array('product_id' => $this->request->get['product_id']));
			foreach ($result as $view) {
				$regions = array();
				foreach ($this->model_product_region->getRegions(array('product_id' => $this->request->get['product_id'], 'view_index' => $view['view_index'])) as $region) {
					$regions[] = array(
						'region_index'	=> $region['region_index'],
						'name'		=> $region['name'],
						'x'			=> $region['x'],
						'y'			=> $region['y'],
						'width'		=> $region['width'],
						'height'	=> $region['height'],
						'mask'	    => $region['mask']
					);
				}	
				$fills = array();
				foreach ($this->model_product_fill->getFills(array('product_id' => $this->request->get['product_id'], 'view_index' => $view['view_index'])) as $fill) {
					$fills[$fill['view_fill_index']] = $fill['file'];
				}
				
				$views[] = array(
        			'view_index'	=> $view['view_index'],
        			'name'			=> $view['name'],
        			'regions_scale'	=> $view['regions_scale'],
        			'shade'			=> $view['shade'],
        			'underfill'		=> $view['underfill'],
					'regions'		=> $regions,
					'fills'			=> $fills
        		);
    		}	
			
		}
		
		$this->data['token'] = $this->session->data['token'];
		
		$this->data['views'] = array();
		if (isset($this->request->post['views'])) {
			foreach($this->request->post['views'] as $view) {
				$this->data['views'][] = $this->getChild('product/view/form', $view);
			}			
		} elseif (!empty($views)) { 
			foreach($views as $view) {
				$this->data['views'][] = $this->getChild('product/view/form', $view);
			}	
		}
		
		if (!empty($this->request->get['product_id'])) {
			$this->data['product_id'] =$this->request->get['product_id'];
		} else { 
			$this->data['product_id'] = '';	
		}
		
		if (isset($this->session->data['error_default_region'])) {
			$this->data['error_default_region'] = $this->session->data['error_default_region'];
			unset($this->session->data['error_default_region']);
		} else {
			$this->data['error_default_region'] = '';
		}

		if (isset($this->session->data['error_views'])) {
			$this->data['error_views'] = $this->session->data['error_views'];
			unset($this->session->data['error_views']);
		} else {
			$this->data['error_views'] = '';
		}

		if (isset($this->session->data['error_view_fills'])) {
			$this->data['error_view_fills'] = $this->session->data['error_view_fills'];
			unset($this->session->data['error_view_fills']);
		} else {
			$this->data['error_view_fills'] = '';
		}

		if (isset($this->session->data['error_view_shade_underfill'])) {
			$this->data['error_view_shade_underfill'] = $this->session->data['error_view_shade_underfill'];
			unset($this->session->data['error_view_shade_underfill']);
		} else {
			$this->data['error_view_shade_underfill'] = '';
		}

		if (isset($this->session->data['error_view_regions'])) {
			$this->data['error_view_regions'] = $this->session->data['error_view_regions'];
			unset($this->session->data['error_view_regions']);
		} else {
			$this->data['error_view_regions'] = '';
		}

		$this->template = 'product/view.tpl';
		$this->response->setOutput($this->render());
  	}

	public function form($data = array()) {
		$this->load->language('product/view');
		
		$this->data['entry_name'] = $this->language->get('entry_name');
		$this->data['button_add_region'] = $this->language->get('button_add_region');
		$this->data['button_remove'] = $this->language->get('button_remove');
		$this->data['button_shade'] = $this->language->get('button_shade');
		$this->data['button_underfill'] = $this->language->get('button_underfill');
		$this->data['button_fill'] = $this->language->get('button_fill');
		$this->data['text_regions'] = $this->language->get('text_regions');
		$this->data['text_fills'] = $this->language->get('text_fills');
		$this->data['text_shade'] = $this->language->get('text_shade');
		$this->data['text_underfill'] = $this->language->get('text_underfill');
		$this->data['text_clear'] = $this->language->get('text_clear');
		$this->data['text_scale'] = $this->language->get('text_scale');
		$this->data['text_coloreable'] = $this->language->get('text_coloreable');
		$this->data['text_view_setup'] = $this->language->get('text_view_setup');
		$this->data['text_coloreable_pros_cons'] = $this->language->get('text_coloreable_pros_cons');
		$this->data['text_no_coloreable_pros_cons'] = $this->language->get('text_no_coloreable_pros_cons');		
		
		$this->data['token'] = $this->session->data['token'];
		
		if (!empty($data)) {
			$view_index = $data['view_index'];
			$name = $data['name'];
			$shade = $data['shade'];
			$underfill = $data['underfill'];
			$regions_scale = $data['regions_scale'];
			$fills = (isset($data['fills']))?$data['fills']:array();
			$regions = (isset($data['regions']))?$data['regions']:array();
		}
		
		if (isset($view_index)) { 
			$this->data['view_index'] = $view_index;
		} else {
			$this->data['view_index'] = mt_rand();
		}
		
		if (!empty($name)) { 
			$this->data['name'] = $name;
		} else {
			$this->data['name'] = 'Enter View Name';
		}
		
		$this->load->model('tool/image');
		
		if (isset($shade)) { 
			$this->data['shade'] = $shade;
			if(empty($shade)) {
				$this->data['thumb_shade'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);
				$this->data['shade_url'] = '';
			} else {
				$this->data['thumb_shade'] = $this->model_tool_image->resize('data/products/' .$shade, 100, 100);
				$this->data['shade_url'] = HTTPS_CATALOG . 'image/data/products/' . $shade;
			}
		} else {
			$this->data['shade'] = 'default_shade.png';
			$this->data['thumb_shade'] = $this->model_tool_image->resize('data/products/default_shade.png' , 100, 100);
			$this->data['shade_url'] = HTTPS_CATALOG . 'image/data/products/default_shade.png';
		}

		if (!empty($underfill)) { 
			$this->data['underfill'] = $underfill;
			$this->data['thumb_underfill'] = $this->model_tool_image->resize('data/products/' .$underfill, 100, 100);
			$this->data['underfill_url'] = HTTPS_CATALOG . 'image/data/products/' . $underfill;
		} else {
			$this->data['underfill'] = '';
			$this->data['thumb_underfill'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);
			$this->data['underfill_url'] = '';
		}


		
		
		if (isset($regions_scale)) { 
			$this->data['regions_scale'] = $regions_scale;
		} else {
			$this->data['regions_scale'] = '';
		}
		
		/*if (!empty($fills)) { 
			foreach($fills as $key=>$fill) {
				$this->data['fills'][] = array(
					'view_fill_index' => $key, 
					'fill_file' => $fill, 
					'image' =>  HTTPS_CATALOG . 'image/data/products/'.$fill,
					'thumb' => $this->model_tool_image->resize('data/products/'.$fill , 100, 100)
				);
			}
		} else {
			$this->data['fills'] = array();
			$this->data['fills'][] = array(
				'view_fill_index' => '0', 
				'fill_file' => 'default_fill.png', 
				'image' =>  HTTPS_CATALOG . 'image/data/products/default_fill.png',
				'thumb' => $this->model_tool_image->resize('data/products/default_fill.png' , 100, 100)
			);
		}*/
		
		$this->data['no_image'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);
		$this->data['fills'] = array();
		if (!empty($fills)) { 
			foreach($fills as $key=>$fill) {
				$this->data['fills'][] = $this->getChild('product/view/fill', array('view_index' => $this->data['view_index'], 'view_fill_index' => $key, 'fill_file' =>  $fill));
			}	
		} else {
			$this->data['fills'][] = $this->getChild('product/view/fill', array('view_index' => $this->data['view_index']));
		}
		
		if (!empty($regions)) { 
			foreach($regions as $region) {
				$region['view_index'] = $this->data['view_index'];
				$this->data['regions'][] = $this->getChild('product/region/form', $region);
			}	
		} else {
			$this->data['regions'] = array();
		}
		
		$this->template = 'product/view_item.tpl';
		$this->response->setOutput($this->render());

	}
	
  	public function fill($data = array()) {
		
		$this->load->language('product/view');
		
		$this->load->model('tool/image');

		$this->data['no_image'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);

		$this->data['text_clear'] = $this->language->get('text_clear');
		$this->data['button_fill'] = $this->language->get('button_fill');
		$this->data['token'] = $this->session->data['token'];
		
		if (isset($data['view_index'])) { 
			$this->data['view_index'] = $data['view_index'];
		} else {
			$this->data['view_index'] = $this->request->get['view_index'];
		}
		
		if (isset($data['view_fill_index'])) { 
			$this->data['view_fill_index'] = $data['view_fill_index'];
		} else {
			$this->data['view_fill_index'] = mt_rand();
		}
		
		
		if (isset($data['fill_file'])) { 
			if(empty($data['fill_file'])) {
				$this->data['fill_file'] = '';
				$this->data['image'] = '';
				$this->data['thumb'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);
			} else {
				$this->data['fill_file'] = $data['fill_file'];
				$this->data['image'] = HTTPS_CATALOG . 'image/data/products/'.$data['fill_file'];
				$this->data['thumb'] = $this->model_tool_image->resize('data/products/'.$data['fill_file'] , 100, 100);
			}
		} else {
			$this->data['fill_file'] = 'default_fill.png';
			$this->data['image'] = HTTPS_CATALOG . 'image/data/products/default_fill.png';
			$this->data['thumb'] = $this->model_tool_image->resize('data/products/default_fill.png' , 100, 100);
		}

		$this->template = 'product/add_fill.tpl';

		$this->response->setOutput($this->render());

	}
	
	public function upload_shade() {
		
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
	
	public function upload_fill() {
		
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