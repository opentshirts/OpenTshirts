<?php
class ModelOpentshirtsProductExport extends Model {
	private $languages = array();
	
	public function get_files($product_id)
	{
		$files = array();
		$query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product WHERE product_id = '".$product_id."' ");
		
		if($query->row['image'] && file_exists(DIR_IMAGE . $query->row['image'])) {
			$files[] = array('source' => DIR_IMAGE . $query->row['image'], 'dest'=> basename(DIR_IMAGE) . '/' . $query->row['image']);
		}
		
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_image WHERE product_id = '".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result) {
					$files[] = array('source' => DIR_IMAGE . $result['image'], 'dest'=> basename(DIR_IMAGE) . '/' . $result['image']);
				}
			}
		}
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_view WHERE product_id = '".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result) {
					$files[] = array('source' => DIR_IMAGE . 'data/products/' . $result['shade'], 'dest'=> basename(DIR_IMAGE) . '/data/products/' . $result['shade']);
					if($query_view_fill = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_view_fill WHERE product_id='".$product_id."' AND view_index='".$result['view_index']."' "))
					{
						foreach ($query_view_fill->rows as $result_view_fill) {
							$files[] = array('source'=>DIR_IMAGE . 'data/products/' . $result_view_fill['file'], 'dest'=> basename(DIR_IMAGE) . '/data/products/' . $result_view_fill['file']);
						}
					}
				}
			}
		}
		return $files;
	}	

	private function load_languages()
	{
		$this->load->model('localisation/language');
		$languages = $this->model_localisation_language->getLanguages();
		foreach ($languages as $code => $language) {
			$this->languages[$language['language_id']] = $language;
		}
	}
	
	public function dump($product_id)
	{
		$this->load_languages();
		
		$response = array();
		$response['product'] = $this->dump_product_fields($product_id);
		$response['product_description'] = $this->dump_product_description_fields($product_id);
		$response['product_to_category'] = $this->dump_product_categories($product_id);
		$response['product_image'] = $this->dump_product_images($product_id);
		$response['printable_product'] = $this->dump_printable_product($product_id);
		$response['printable_product_product_color_product_size'] = $this->dump_product_colors_sizes($product_id);
		$response['printable_product_size_upcharge'] = $this->dump_product_sizes_upcharge($product_id);
		$response['printable_product_quantity'] = $this->dump_product_quantities($product_id);
		$response['printable_product_view'] = $this->dump_product_views($product_id);
		return $response;
	}
	
	private function dump_product_fields($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product WHERE product_id = '".$product_id."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				unset($row['product_id']);
				$response = $row;
			} else {
				throw new ErrorException("ERROR: product ID: $product_id doesnt exists");
			}
		}
		return $response;
	}

	private function dump_product_description_fields($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_description WHERE product_id='".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$language_code = $this->languages[$result['language_id']]['code'];
					unset($result['product_id']);
					unset($result['language_id']);
					$response[$language_code] = $result;
				}	
			}
		}
		return $response;
	}
	
	private function dump_product_categories($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_to_category WHERE product_id='".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$response[] = $result['category_id'];
				}	
			}
		}
		return $response;
	}

	private function dump_product_images($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_image WHERE product_id='".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					unset($result['product_image_id']);
					unset($result['product_id']);
					$response[] = $result;
				}	
			}
		}
		return $response;
	}

	private function dump_printable_product($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product WHERE product_id = '".$product_id."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				unset($row['product_id']);
				$response = $row;
			}
		}
		return $response;
	}
	
	private function dump_product_colors_sizes($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_product_color_product_size WHERE product_id='".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					unset($result['product_id']);
					$response[] = $result;
				}	
			}
		}
		return $response;
	}

	private function dump_product_sizes_upcharge($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_size_upcharge WHERE product_id='".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					unset($result['product_id']);
					$response[] = $result;
				}	
			}
		}
		return $response;
	}

	private function dump_product_quantities($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_quantity WHERE product_id='".$product_id."' ORDER BY quantity ASC "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$quantity['quantity_index'] = $result['quantity_index'];
					$quantity['quantity'] = $result['quantity'];
					$quantity['prices'] = $this->dump_quantity_prices($product_id, $result['quantity_index']);
					$response[] = $quantity;
				}	
			}
		}
		return $response;
	}

	private function dump_quantity_prices($product_id, $quantity_index)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_quantity_price WHERE product_id='".$product_id."' AND quantity_index='".$quantity_index."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					unset($result['product_id']);
					unset($result['quantity_index']);
					$response[] = $result;
				}	
			}
		}
		return $response;
	}

	private function dump_product_views($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_view WHERE product_id='".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$view_index = $result['view_index'];
					unset($result['product_id']);
					$view = $result;
					$view['regions'] = $this->dump_product_regions($product_id, $view_index);
					$view['fills'] = $this->dump_product_fills($product_id, $view_index);
					$response[] = $view;
				}	
			}
		}
		return $response;
	}	

	private function dump_product_regions($product_id, $view_index)
	{		
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_view_region WHERE product_id='".$product_id."' AND view_index='".$view_index."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					unset($result['product_id']);
					unset($result['view_index']);
					$response[] = $result;
				}	
			} else {
				throw new ErrorException("ERROR: View without regions product_id $product_id, view_index $view_index");
			}
		}
		return $response;
	}	

	private function dump_product_fills($product_id, $view_index)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_view_fill WHERE product_id='".$product_id."' AND view_index='".$view_index."' ORDER BY view_fill_index ASC "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					unset($result['product_id']);
					unset($result['view_index']);
					$response[] = $result;
				}
			} else {
				throw new ErrorException("ERROR: View without fills product_id $product_id, view_index $view_index");
			}
		}
		return $response;
	}

	public function dump_category($category_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "category WHERE category_id='".$category_id."' "))
		{
			if($query->num_rows==1)
			{
				$row['category'] = $query->row;
				$row['category_description'] = $this->dump_category_description($category_id);
				$response = $row;
			} else {
				throw new ErrorException("ERROR: product category doesnt exists: category_id=".$category_id);
			}
		}
		return $response;
	}

	private function dump_category_description($category_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "category_description WHERE category_id='".$category_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$language_code = $this->languages[$result['language_id']]['code'];
					unset($result['category_id']);
					unset($result['language_id']);
					$response[$language_code] = $result;
				}	
			} else {
				throw new ErrorException("ERROR: product category description doesnt exists: category_id=".$category_id);
			}
		}
		return $response;
	}

	public function dump_category_files($category_id)
	{
		$files = array();
		$query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "category WHERE category_id = '".$category_id."' ");
		
		if($query->row['image'] && file_exists(DIR_IMAGE . $query->row['image'])) {
			$files[] = array('source' => DIR_IMAGE . $query->row['image'], 'dest'=> basename(DIR_IMAGE) . '/' . $query->row['image']);
		}

		return $files;
	}	

	public function dump_product_color($id_product_color)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_color WHERE id_product_color='".$id_product_color."' "))
		{
			if($query->num_rows==1)
			{
				$row['color'] = $query->row;
				unset($row['color']['option_value_id']);
				unset($row['color']['deleted']);
				$row['flat_color'] = $this->dump_flat_color($id_product_color);
				$response = $row;
			} else {
				throw new ErrorException("ERROR: product color doesnt exists: id_product_color=".$id_product_color);
			}
		}
		return $response;
	}
	
	private function dump_flat_color($id_product_color)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_color_flat_color WHERE id_product_color='".$id_product_color."' ORDER BY flat_color_index ASC "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					unset($result['id_product_color']);
					$response[] = $result;
				}	
			} else {
				throw new ErrorException("ERROR:  product color without flat colors: id_product_color=".$id_product_color);
			}
		}
		return $response;
	}

	public function dump_product_size($id_product_size)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_size WHERE id_product_size='".$id_product_size."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				unset($row['option_value_id']);
				unset($row['deleted']);
				$response = $row;
			} else {
				throw new ErrorException("ERROR: product size doesnt exists: id_product_size=".$id_product_size);
			}
		}
		return $response;
	}

	public function dump_manufacturer($manufacturer_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "manufacturer WHERE manufacturer_id='".$manufacturer_id."' "))
		{
			if($query->num_rows==1)
			{
				$row['manufacturer'] = $query->row;
				$response = $row;
			} else {
				throw new ErrorException("ERROR: product manufacturer doesnt exists: manufacturer_id=".$manufacturer_id);
			}
		}
		return $response;
	}


	public function dump_manufacturer_files($manufacturer_id)
	{
		$files = array();
		$query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "manufacturer WHERE manufacturer_id = '".$manufacturer_id."' ");
		
		if($query->row['image'] && file_exists(DIR_IMAGE . $query->row['image'])) {
			$files[] = array('source' => DIR_IMAGE . $query->row['image'], 'dest'=> basename(DIR_IMAGE) . '/' . $query->row['image']);
		}

		return $files;
	}	


	/** ----------------------------------   **/
	/** ----------  IMPORT  --------------   **/
	/** ----------------------------------   **/


	public function import_category($category, $file)
	{

		foreach ($category['category_description'] as $code => $description) {
			$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "category_description` WHERE name = '".$description['name']."' AND  description = '".$description['description']."' AND  meta_description = '".$description['meta_description']."' AND  meta_keyword = '".$description['meta_keyword']."' ");
			if($query->num_rows>0)
			{
				//echo "existe".$query->row['category_id'].$description['description']."<br>";
				return $query->row['category_id'];
			}
		}
		
		$sql  = "INSERT INTO `" . DB_PREFIX . "category` SET ";
		$sql .= " `image` = '".$category['category']['image']."',";
		$sql .= " `parent_id` = 0,";//update parents later
		$sql .= " `top` = ".(int)$category['category']['top'].",";
		$sql .= " `column` = ".(int)$category['category']['column'].",";
		$sql .= " `sort_order` = ".(int)$category['category']['sort_order'].",";
		$sql .= " `status` = ".(int)$category['category']['status'].",";
		$sql .= " `date_added` = NOW(),";
		$sql .= " `date_modified` = NOW() ";

		$query = $this->db->query($sql);

		$category_id = $this->db->getLastId();	

		if($category['category']['image']) {
			@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/'.$category['category']['image'],  DIR_IMAGE .$category['category']['image']);
		}

		$this->load->model('localisation/language');
		$languages = $this->model_localisation_language->getLanguages();
		foreach($languages as $code => $language) {
			if(isset($category['category_description'][$code])) {
				$data['category_description'][$language['language_id']] = array(
					'name'=>$category['category_description'][$code]['name'],
					'meta_keyword'=>$category['category_description'][$code]['meta_keyword'],
					'meta_description'=>$category['category_description'][$code]['meta_description'],
					'description'=>$category['category_description'][$code]['description']
					);
			} else {
				$data['category_description'][$language['language_id']] = array(
					'name'=>$category['category_description']['en']['name'],
					'meta_keyword'=>$category['category_description']['en']['meta_keyword'],
					'meta_description'=>$category['category_description']['en']['meta_description'],
					'description'=>$category['category_description']['en']['description']
				);
			}
			
		}	
		$data['category_store'] = array(0);	


		foreach ($data['category_description'] as $language_id => $value) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "category_description SET category_id = '" . (int)$category_id . "', language_id = '" . (int)$language_id . "', name = '" . $this->db->escape($value['name']) . "', meta_keyword = '" . $this->db->escape($value['meta_keyword']) . "', meta_description = '" . $this->db->escape($value['meta_description']) . "', description = '" . $this->db->escape($value['description']) . "'");
		}
		
		if (isset($data['category_store'])) {
			foreach ($data['category_store'] as $store_id) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "category_to_store SET category_id = '" . (int)$category_id . "', store_id = '" . (int)$store_id . "'");
			}
		}
		$this->cache->delete('category');
				
		return $category_id;
	}
	public function update_category_parent($category_id, $parent_id)
	{
		$sql  = "UPDATE " . DB_PREFIX . "category SET parent_id = '" . $parent_id . "' WHERE category_id = '" . $category_id . "' LIMIT 1 ";
		$query = $this->db->query($sql);

		$this->cache->delete('category');
	}

	public function import_manufacturer($manufacturer, $file)
	{

		$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "manufacturer` WHERE name = '".$manufacturer['manufacturer']['name']."' ");
		if($query->num_rows>0)
		{
			return $query->row['manufacturer_id'];
		}
		
		
		$sql  = "INSERT INTO `" . DB_PREFIX . "manufacturer` SET ";
		$sql .= " `name` = '".$manufacturer['manufacturer']['name']."',";
		$sql .= " `image` = '".$manufacturer['manufacturer']['image']."',";
		$sql .= " `sort_order` = ".(int)$manufacturer['manufacturer']['sort_order']." ";

		$query = $this->db->query($sql);

		$manufacturer_id = $this->db->getLastId();	

		$path = '';
			
		$directories = explode('/', dirname(str_replace('../', '', $manufacturer['manufacturer']['image'])));

		foreach ($directories as $directory) {
			$path = $path . '/' . $directory;

			if (!file_exists(DIR_IMAGE . $path)) {
				@mkdir(DIR_IMAGE . $path, 0777);
			}		
		}

		@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/'.$manufacturer['manufacturer']['image'],  DIR_IMAGE . $manufacturer['manufacturer']['image']);

		$data['manufacturer_store'] = array(0);	
		
		if (isset($data['manufacturer_store'])) {
			foreach ($data['manufacturer_store'] as $store_id) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "manufacturer_to_store SET manufacturer_id = '" . (int)$manufacturer_id . "', store_id = '" . (int)$store_id . "'");
			}
		}

		$this->cache->delete('manufacturer');
				
		return $manufacturer_id;
	}

	public function import_color($color)
	{
		if(isset($color['color']['id_product_color'])) { //if already exists just return
			$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "printable_product_color` WHERE id_product_color='".$color['color']['id_product_color']."' ");
			if($query->num_rows>0)
			{
				return $query->row['option_value_id'];
			}
		}

		if($this->config->get('product_color_option_id')) {
			$option_id = $this->config->get('product_color_option_id');

			$this->db->query("INSERT INTO " . DB_PREFIX . "option_value SET option_id = '" . (int)$option_id . "', image = '', sort_order = '0'");
			
			$option_value_id = $this->db->getLastId();

			$this->load->model('localisation/language');
			$languages = $this->model_localisation_language->getLanguages();
			foreach($languages as $language) {
				$option_value['option_value_description'][$language['language_id']] = array('name'=>$color['color']['name']);
			}		
			
			foreach ($option_value['option_value_description'] as $language_id => $option_value_description) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "option_value_description SET option_value_id = '" . (int)$option_value_id . "', language_id = '" . (int)$language_id . "', option_id = '" . (int)$option_id . "', name = '" . $this->db->escape($option_value_description['name']) . "'");
			}
		} else {
			$option_value_id = 0;
		}
		
		$ID = $color['color']['id_product_color'];
		
		$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_color SET ";
		$sql .= " id_product_color = '" . $ID . "',";
		$sql .= " name = '" . $this->db->escape($color['color']['name']) . "',";
		$sql .= " num_colors = '" . $this->db->escape($color['color']['num_colors']) . "',";
		$sql .= " need_white_base = '" . $this->db->escape($color['color']['need_white_base']) . "',";
		$sql .= " id_product_color_group = '" . $this->db->escape($color['color']['id_product_color_group']) . "',";
		$sql .= " option_value_id = '" . $option_value_id . "'";
		
		$query = $this->db->query($sql);
		
		foreach($color['flat_color'] as $flat_color)
		{
			$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_color_flat_color SET ";
			$sql .= " id_product_color = '" . $ID . "',";
			$sql .= " flat_color_index = '" . $this->db->escape($flat_color['flat_color_index']) . "',";
			$sql .= " hexa = '" . $this->db->escape($flat_color['hexa']) . "' ";
			
			$query = $this->db->query($sql);
		}
				
		return $option_value_id;
	}

	public function import_size($size)
	{
		if(isset($size['id_product_size'])) { //if already exists just return
			$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "printable_product_size` WHERE id_product_size='".$size['id_product_size']."' ");
			if($query->num_rows>0)
			{
				return $query->row['option_value_id'];
			}
		}

		if($this->config->get('product_size_option_id')) {
			$option_id = $this->config->get('product_size_option_id');
			$this->db->query("INSERT INTO " . DB_PREFIX . "option_value SET option_id = '" . (int)$option_id . "', image = '', sort_order = '0'");
			
			$option_value_id = $this->db->getLastId();

			$this->load->model('localisation/language');
			$languages = $this->model_localisation_language->getLanguages();
			foreach($languages as $language) {
				$option_value['option_value_description'][$language['language_id']] = array('name'=>$size['description']);
			}		
			
			foreach ($option_value['option_value_description'] as $language_id => $option_value_description) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "option_value_description SET option_value_id = '" . (int)$option_value_id . "', language_id = '" . (int)$language_id . "', option_id = '" . (int)$option_id . "', name = '" . $this->db->escape($option_value_description['name']) . "'");
			}
		} else {
			$option_value_id = 0;
		}
		
		$ID = $size['id_product_size'];
		
		$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_size SET ";
		$sql .= " id_product_size = '" . $ID . "',";
		$sql .= " description = '" . $this->db->escape($size['description']) . "',";
		$sql .= " initials = '" . $this->db->escape($size['initials']) . "',";
		$sql .= " apply_additional_cost = '" . $this->db->escape($size['apply_additional_cost']) . "',";
		$sql .= " sort = '" . $this->db->escape($size['sort']) . "',";
		$sql .= " option_value_id = '" . $option_value_id . "'";
		
		$query = $this->db->query($sql);
				
		return $option_value_id;
	}

	public function import_product($product, $file, $updated_ids) {
		
		/*if(isset($product->product->id_product)) { //if already exists just return
			$query = $this->db->query("SELECT product_id FROM `" . DB_PREFIX . "printable_product` WHERE product_id='".$product->product->id_product."' ");
			if($query->num_rows>0)
			{
				if($overwrite) {
					$this->load->model('product/product');
					$this->model_product_product->removeProduct($product->product->id_product);
				} else {
					return false;
				}
			}
		}*/


		
		$sql  = "INSERT INTO " . DB_PREFIX . "product SET ";
		$sql .= " model = '" . $this->db->escape($product['product']['model']) . "',";
		$sql .= " sku = '" . $this->db->escape($product['product']['sku']) . "',";
		$sql .= " upc = '" . $this->db->escape($product['product']['upc']) . "',";
		$sql .= " location = '" . $this->db->escape($product['product']['location']) . "',";
		$sql .= " quantity = '" . (int)$product['product']['quantity'] . "',";
		$sql .= " stock_status_id = '" . (int)$product['product']['stock_status_id'] . "',";
		$sql .= " image = '" . $this->db->escape($product['product']['image']) . "',";
		if(isset($updated_ids['manufacturers'][$product['product']['manufacturer_id']])) {
			$sql .= " manufacturer_id = '" . (int)$updated_ids['manufacturers'][$product['product']['manufacturer_id']] . "',";
		} else {
			$sql .= " manufacturer_id = '0',";
		}
		$sql .= " shipping = '" . (int)$product['product']['shipping'] . "',";
		$sql .= " price = '1000',";
		$sql .= " points = '" . (int)$product['product']['points'] . "',";
		$sql .= " tax_class_id = '0',";
		$sql .= " date_available = NOW(),";
		$sql .= " weight = '" . (float)$product['product']['weight'] . "',";
		$sql .= " weight_class_id = '" . (int)$this->config->get('config_weight_class_id') . "',";
		$sql .= " length = '" . (float)$product['product']['length'] . "',";
		$sql .= " width = '" . (float)$product['product']['width'] . "',";
		$sql .= " height = '" . (float)$product['product']['height'] . "',";
		$sql .= " length_class_id = '" . (int)$this->config->get('config_length_class_id') . "',";
		$sql .= " subtract = '" . (int)$product['product']['subtract'] . "',";
		$sql .= " minimum = '" . (int)$product['product']['minimum'] . "',";
		$sql .= " sort_order = '" . (int)$product['product']['sort_order'] . "',";
		$sql .= " status = '" . (int)$product['product']['status'] . "',";
		$sql .= " date_added = NOW(),";
		$sql .= " date_modified = NOW(),";
		$sql .= " viewed = 0 ".PHP_EOL;

		$query = $this->db->query($sql);

		$product_id = $this->db->getLastId();	

		if($product['product']['image']) {
			@copy('zip://'.$file.'#'.basename(DIR_IMAGE) .'/'. $product['product']['image'],  DIR_IMAGE . $product['product']['image']);
		}

		$this->load->model('localisation/language');
		$languages = $this->model_localisation_language->getLanguages(); //defined on index.php
		foreach($languages as $code => $language) {
			if(isset($product['product_description'][$code])) {
				$data['product_description'][$language['language_id']] = array(
					'name'=>$product['product_description'][$code]['name'],
					'meta_keyword'=>$product['product_description'][$code]['meta_keyword'],
					'meta_description'=>$product['product_description'][$code]['meta_description'],
					'description'=>$product['product_description'][$code]['description'],
					'tag'=>$product['product_description'][$code]['tag']
					);
			} else {
				$data['product_description'][$language['language_id']] = array(
					'name'=>$product['product_description']['en']['name'],
					'meta_keyword'=>$product['product_description']['en']['meta_keyword'],
					'meta_description'=>$product['product_description']['en']['meta_description'],
					'description'=>$product['product_description']['en']['description'],
					'tag'=>$product['product_description']['en']['tag']
				);
			}
			
		}		

		foreach ($data['product_description'] as $language_id => $value) {
			$sql  = "INSERT INTO " . DB_PREFIX . "product_description SET ";
			$sql .= " product_id = '" . (int)$product_id . "',";
			$sql .= " language_id = '" . (int)$language_id . "',";
			$sql .= " name = '" . $this->db->escape($value['name']) . "',";
			$sql .= " meta_keyword = '" . $this->db->escape($value['meta_keyword']) . "',";
			$sql .= " meta_description = '" . $this->db->escape($value['meta_description']) . "',";
			$sql .= " description = '" . $this->db->escape($value['description']) . "',";
			$sql .= " tag = '" . $this->db->escape($value['tag']) . "' ";
			$this->db->query($sql);
		}

		$this->db->query("INSERT INTO " . DB_PREFIX . "product_to_store SET product_id = '" . (int)$product_id . "', store_id = '0'");

		foreach ($product['product_to_category'] as $category_id) {
			if(isset($updated_ids['categories'][$category_id])) {
				$sql  = "INSERT INTO " . DB_PREFIX . "product_to_category SET ";
				$sql .= " product_id = '" . (int)$product_id . "',";
				$sql .= " category_id = '" . (int)$updated_ids['categories'][$category_id] . "'";
				$this->db->query($sql);
			}
		}

		foreach ($product['product_image'] as $product_image) {
			$sql  = "INSERT INTO " . DB_PREFIX . "product_image SET ";
			$sql .= " product_id = '" . (int)$product_id . "',";
			$sql .= " image = '" . $this->db->escape($product_image['image']) . "',";
			$sql .= " sort_order = '" . (int)$product_image['sort_order'] . "'";
			$this->db->query($sql);
			
			@copy('zip://'.$file.'#'.basename(DIR_IMAGE) .'/'. $product_image['image'],  DIR_IMAGE . $product_image['image']);
		}

		if($product['printable_product']) {

			$sql  = "INSERT INTO " . DB_PREFIX . "printable_product SET ";
			$sql .= " product_id = '" . $product_id . "',";
			$sql .= " default_view = '" . $this->db->escape($product['printable_product']['default_view']) . "',";
			$sql .= " default_region = '" . $this->db->escape($product['printable_product']['default_region']) . "',";
			$sql .= " default_color = '" . $this->db->escape($product['printable_product']['default_color']) . "',";
			$sql .= " colors_number = '" . $this->db->escape($product['printable_product']['colors_number']) . "' ";
			$this->db->query($sql);


			if($this->config->get('product_color_option_id')) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_option SET product_id = '" . (int)$product_id . "', option_id = '" . (int)$this->config->get('product_color_option_id') . "', required = '1'");
				
				$product_option_id_color = $this->db->getLastId();
			}
			if($this->config->get('product_size_option_id')) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_option SET product_id = '" . (int)$product_id . "', option_id = '" . (int)$this->config->get('product_size_option_id') . "', required = '1'");
				
				$product_option_id_size = $this->db->getLastId();
			}

			$saved_sizes = array();
			$saved_colors = array();
			foreach($product['printable_product_product_color_product_size'] as $color_size)
			{

				if($product_option_id_size) {
					if(!in_array($color_size['id_product_size'], $saved_sizes) && isset($updated_ids['sizes'][$color_size['id_product_size']])) {
						$this->db->query("INSERT INTO " . DB_PREFIX . "product_option_value SET product_option_id = '" . (int)$product_option_id_size . "', product_id = '" . (int)$product_id . "', option_id = '" . (int)$this->config->get('product_size_option_id') . "', option_value_id = '" . (int)$updated_ids['sizes'][$color_size['id_product_size']] . "', quantity = '0', subtract = '0', price = '0', price_prefix = '+', points = '0', points_prefix = '+', weight = '0', weight_prefix = '0'");
						$saved_sizes[] = $color_size['id_product_size'];
					}
				}

				if($product_option_id_color) {
					if(!in_array($color_size['id_product_color'], $saved_colors) && isset($updated_ids['colors'][$color_size['id_product_color']])) {
						$this->db->query("INSERT INTO " . DB_PREFIX . "product_option_value SET product_option_id = '" . (int)$product_option_id_color . "', product_id = '" . (int)$product_id . "', option_id = '" . (int)$this->config->get('product_color_option_id') . "', option_value_id = '" . (int)$updated_ids['colors'][$color_size['id_product_color']] . "', quantity = '0', subtract = '0', price = '0', price_prefix = '+', points = '0', points_prefix = '+', weight = '0', weight_prefix = '0'");
						$saved_colors[] = $color_size['id_product_color'];
					}
				}

				$fields = 'INSERT INTO `' . DB_PREFIX . 'printable_product_product_color_product_size` ';
				$fields .= '(`product_id`,`id_product_color`,`id_product_size`)';
				$values = ' VALUES (';
				$values .= '\''.$product_id.'\',';
				$values .= '\''.$color_size['id_product_color'].'\',';
				$values .= '\''.$color_size['id_product_size'].'\'';
				$values .= ');'.PHP_EOL;
				
				$sql = $fields.$values;
			
				$query = $this->db->query($sql);
			}

			
			foreach($product['printable_product_view'] as $view)
			{
				
				$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_view SET ";
				$sql .= " product_id = '" . $product_id . "',";
				$sql .= " view_index = '" . (int)$view['view_index'] . "',";
				$sql .= " name = '" . $this->db->escape($view['name']) . "',";
				$sql .= " regions_scale = '" . $view['regions_scale'] . "',";
				$sql .= " shade = '" . $this->db->escape($view['shade']) . "' ";		
				$query = $this->db->query($sql);
				
				@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/products/'.$view['shade'],  DIR_IMAGE . 'data/products/' . $view['shade']);
				
				foreach($view['regions'] as $region)
				{
					$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_view_region SET ";
					$sql .= " product_id = '" . $product_id . "',";
					$sql .= " view_index = '" . (int)$view['view_index'] . "',";
					$sql .= " region_index = '" . (int)$region['region_index'] . "',";
					$sql .= " name = '" . $this->db->escape($region['name']) . "',";
					$sql .= " x = '" . $this->db->escape($region['x']) . "',";
					$sql .= " y = '" . $this->db->escape($region['y']) . "',";
					$sql .= " width = '" . $this->db->escape($region['width']) . "',";
					$sql .= " height = '" . $this->db->escape($region['height']) . "' ";		
					$query = $this->db->query($sql);

				}
				
				foreach($view['fills'] as $fill)
				{

					$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_view_fill SET ";
					$sql .= " product_id = '" . $product_id . "',";
					$sql .= " view_index = '" . (int)$view['view_index'] . "',";
					$sql .= " view_fill_index = '" . (int)$fill['view_fill_index'] . "',";
					$sql .= " file = '" . $this->db->escape($fill['file']) . "' ";		
					$query = $this->db->query($sql);

					@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/products/'.$fill['file'],  DIR_IMAGE . 'data/products/'. $fill['file']);

				}
			}

			//set default price in case it has no price
			if(empty($product['printable_product_quantity'])) {
				$prices = array();
				$prices[] = array(
					'id_product_color_group' => 1,
					'price' => 5
				);
				$prices[] = array(
					'id_product_color_group' => 2,
					'price' => 5
				);
				$prices[] = array(
					'id_product_color_group' => 3,
					'price' => 5
				);

				$product['printable_product_quantity'] = array();
				$product['printable_product_quantity'][] = array(
					'quantity_index' => 0,
					'quantity' => 0,
					'prices' => $prices
				);
				
			} 

			foreach($product['printable_product_quantity'] as $quantity)
			{

				$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_quantity SET ";
				$sql .= " product_id = '" . $product_id . "',";
				$sql .= " quantity_index = '" . (int)$quantity['quantity_index'] . "',";
				$sql .= " quantity = '" . (int)$quantity['quantity'] . "'";	
				$query = $this->db->query($sql);

				foreach($quantity['prices'] as $price)
				{

					$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_quantity_price SET ";
					$sql .= " product_id = '" . $product_id . "',";
					$sql .= " quantity_index = '" . (int)$quantity['quantity_index'] . "',";
					$sql .= " id_product_color_group = '" . (int)$price['id_product_color_group'] . "',";
					$sql .= " price = '" . (float)$price['price'] . "'";	
					$query = $this->db->query($sql);
				}
			}

			foreach($product['printable_product_size_upcharge'] as $upcharge)
			{

				$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_size_upcharge SET ";
				$sql .= " product_id = '" . $product_id . "',";
				$sql .= " id_product_size = '" . $upcharge['id_product_size'] . "',";
				$sql .= " upcharge = '" . (float)$upcharge['upcharge'] . "'";	
				$query = $this->db->query($sql);
			}
		}
		
		return $product_id;
	}
}
?>