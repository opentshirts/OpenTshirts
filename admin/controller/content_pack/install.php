<?php
class ControllerContentPackInstall extends Controller {
	private $error = array();

  	public function index() {
		$this->load->language('content_pack/install');

		$this->document->setTitle($this->language->get('heading_title'));
		$this->document->addScript('view/javascript/uploadify/swfobject.js');
		$this->document->addScript('view/javascript/uploadify/jquery.uploadify.v2.1.4.min.js');
		$this->document->addStyle('view/javascript/uploadify/uploadify.css');

    	$this->getForm();
  	}	

  	public function getForm() {
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
			'href'      => $this->url->link('content_pack/install', 'token=' . $this->session->data['token'], 'SSL'),				
			'separator' => ' :: '
		);
		
		$this->template = 'content_pack/install.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}
	

	public function install() {


		$this->language->load('content_pack/install');
		
		if (!isset($this->request->files['Filedata'])) {
			$response = $this->language->get('error_upload_post');
		} elseif ($this->request->files['Filedata']['error'] != UPLOAD_ERR_OK) {
			$response = $this->language->get('error_upload_' . $this->request->files['Filedata']['error']);
		}
		
		if (!$this->user->hasPermission('modify', 'content_pack/install')) {
			$response = $this->language->get('error_permission');
		}
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && !isset($response)) {
			$response = $this->language->get('nothing');
			if (is_uploaded_file($this->request->files['Filedata']['tmp_name']) && file_exists($this->request->files['Filedata']['tmp_name'])) {
				ob_start();
				$msg = '';
				$this->installClipartCategories();
				$this->installFontCategories();
				$this->installProductCategories();
				$new_product_color_id = $this->installProductColors();
				$new_product_size_id = $this->installProductSizes();
				//$this->installProductManufacturers();
				$this->installCompositionCategories();
				$this->installDesignColors();

				if($r = $this->installCliparts())
				{
					$msg .= $r;
				}
				if($r = $this->installFonts())
				{
					$msg .= $r;
				}
				if($r = $this->installProducts($new_product_color_id,$new_product_size_id))
				{
					$msg .= $r;
				}
				if($r = $this->installCompositions())
				{
					$msg .= $r;
				}
				ob_end_clean();		
				if(!empty($msg))
				{
					$response = $msg;
				}
				$response .= '[' . $this->request->files['Filedata']['name'] . ']';
				
			}
		}
		
		$this->response->setOutput($response);
	}	
	
	private function installCliparts()
	{
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'cliparts.json'))
		{
			
			$this->load->model('install/clipart');
			
			$cliparts = json_decode($file);
			$overwrite = (empty($this->request->post['overwrite']))?false:true;
			foreach($cliparts as $clipart_obj)
			{
				$this->model_install_clipart->install($clipart_obj,$this->request->files['Filedata']['tmp_name'], $overwrite);	
			}
			if($overwrite) {
				$response = $this->language->get('clipart_install_sucess_overwrite');
			} else {
				$response = $this->language->get('clipart_install_sucess');
			}
			return $response;
		} else {
			return false;
		}
	}
	
	private function installClipartCategories()
	{
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'clipart_categories.json'))
		{
			$this->load->model('install/clipart_category');
			
			$clipart_categories = json_decode($file);
			foreach($clipart_categories as $category_obj)
			{
				$this->model_install_clipart_category->install($category_obj);	
			}
		} 
	}
	
	private function installFonts()
	{
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'fonts.json'))
		{			
			$this->load->model('install/font');
			
			$overwrite = (empty($this->request->post['overwrite']))?false:true;
			
			$fonts = json_decode($file);
			foreach($fonts as $font_obj)
			{
				$this->model_install_font->install($font_obj,$this->request->files['Filedata']['tmp_name'], $overwrite);	
			}
			if($overwrite) {
				$response = $this->language->get('font_install_sucess_overwrite');
			} else {
				$response = $this->language->get('font_install_sucess');
			}
			return $response;
		} else {
			return false;
		}
	}
	
	
	private function installFontCategories()
	{
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'font_categories.json'))
		{
			$this->load->model('install/font_category');
			
			$font_categories = json_decode($file);
			foreach($font_categories as $category_obj)
			{
				$this->model_install_font_category->install($category_obj);	
			}
		} 
	}
	
	
	private function installProducts($new_product_color_id, $new_product_size_id)
	{
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'products.json'))
		{
			$this->load->model('install/product');
			
			$overwrite = (empty($this->request->post['overwrite']))?false:true;
			
			$products = json_decode($file);
			foreach($products as $product_obj)
			{
				$this->model_install_product->install($product_obj,$this->request->files['Filedata']['tmp_name'], $overwrite );	
			}
			if($overwrite) {
				$response = $this->language->get('product_install_sucess_overwrite');
			} else {
				$response = $this->language->get('product_install_sucess');
			}
			return $response;
		} else {
			return false;
		}
	}
	
	private function installProductCategories()
	{
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'product_categories.json'))
		{
			$this->load->model('install/product_category');
			
			$product_categories = json_decode($file);
			$categories_update = array();
			foreach($product_categories as $category_obj)
			{
				$categories_update[$category_obj->id_category] = $this->model_install_product_category->install($category_obj);	
			}
			//update parents
			foreach($product_categories as $category_obj)
			{
				if($category_obj->parent_category) {
					$this->model_install_product_category->update_parent($categories_update[$category_obj->id_category], $categories_update[$category_obj->parent_category]);
				}	
			}
		} 
	}
	
	private function installCompositions()
	{
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'compositions.json'))
		{
			$this->load->model('install/composition');
			
			$overwrite = (empty($this->request->post['overwrite']))?false:true;
			
			$compositions = json_decode($file);
			foreach($compositions as $composition_obj)
			{
				$this->model_install_composition->install($composition_obj,$this->request->files['Filedata']['tmp_name'], $overwrite);	
			}
			if($overwrite) {
				$response = $this->language->get('composition_install_sucess_overwrite');
			} else {
				$response = $this->language->get('composition_install_sucess');
			}
			return $response;
		} else {
			return false;
		}
	}
	
	private function installCompositionCategories()
	{
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'composition_categories.json'))
		{
			$this->load->model('install/composition_category');
			
			$composition_categories = json_decode($file);
			foreach($composition_categories as $category_obj)
			{
				$this->model_install_composition_category->install($category_obj);	
			}
		} 
	}
	
	private function installProductColors()
	{
		$new_product_color_id = array();
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'product_colors.json'))
		{
			$this->load->model('install/product_color');
			
			$product_colors = json_decode($file);
			foreach($product_colors as $product_color_obj)
			{
				$new_product_color_id[$product_color_obj->id_product_color] = $this->model_install_product_color->install($product_color_obj);	
			}
		} 
		return $new_product_color_id;
	}
	private function installProductSizes()
	{
		$new_product_color_id = array();
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'product_sizes.json'))
		{
			$this->load->model('install/product_size');
			
			$product_sizes = json_decode($file);
			foreach($product_sizes as $product_size_obj)
			{
				$new_product_size_id[$product_size_obj->id_product_size] = $this->model_install_product_size->install($product_size_obj);	
			}
		} 
		return $new_product_color_id;
	}
	
	private function installProductManufacturers()
	{
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'product_manufacturers.json'))
		{
			$this->load->model('install/product_manufacturer');
			
			$product_manufacturers = json_decode($file);
			foreach($product_manufacturers as $product_manufacturer_obj)
			{
				$this->model_install_product_manufacturer->install($product_manufacturer_obj);	
			}
		} 
	}
	
	private function installDesignColors()
	{
		if($file = @file_get_contents('zip://'.$this->request->files['Filedata']['tmp_name'].'#'.'design_colors.json'))
		{
			$this->load->model('install/design_color');
			
			$overwrite = (empty($this->request->post['overwrite']))?false:true;
			
			$design_colors = json_decode($file);
			foreach($design_colors as $design_color_obj)
			{
				$this->model_install_design_color->install($design_color_obj, $overwrite);	
			}
		} 
	}
	
}
?>