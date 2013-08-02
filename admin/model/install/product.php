<?php
class ModelInstallProduct extends Model {
	public function install($product_obj, $file, $overwrite = false)
	{
		
		/*if(isset($product_obj->product->id_product)) { //if already exists just return
			$query = $this->db->query("SELECT product_id FROM `" . DB_PREFIX . "printable_product` WHERE product_id='".$product_obj->product->id_product."' ");
			if($query->num_rows>0)
			{
				if($overwrite) {
					$this->load->model('product/product');
					$this->model_product_product->removeProduct($product_obj->product->id_product);
				} else {
					return false;
				}
			}
		}*/

		global $languages;
		foreach($languages as $language) {
			$data['product_description'][$language['language_id']] = array(
				'name'=>$product_obj->product->name,
				'meta_keyword'=>$product_obj->product->name,
				'meta_description'=>$product_obj->product->name,
				'description'=>$product_obj->product->description,
				'tag'=>implode(',', $product_obj->keywords)
				);
		}		
		
		$fields = "INSERT INTO `" . DB_PREFIX . "product` (`model`,`sku`,`upc`,`location`,`quantity`,`stock_status_id`,`image`,`manufacturer_id`,`shipping`,`price`,`points`,`tax_class_id`,`date_available`,  `weight`,  `weight_class_id`,  `length`,  `width`,  `height`,  `length_class_id`,  `subtract`,  `minimum`,  `sort_order`,  `status`,  `date_added`,  `date_modified`,  `viewed`) ";
		$values = " VALUES ('', '', '', '', 999, 5, 'data/products/" . $this->db->escape($product_obj->product->image) . "', 0, 1, 1000, 0, 0, NOW(), '" . $this->db->escape($product_obj->product->weight) . "', '" . $this->db->escape($this->config->get('config_weight_class_id')) . "', 0, 0, 0, '" . $this->db->escape($this->config->get('config_length_class_id')) . "', 0, 1, 0, 1, NOW(), NOW(), 0 ); ".PHP_EOL;
		$sql = $fields.$values;		
		$query = $this->db->query($sql);

		$product_id = $this->db->getLastId();		

		foreach ($data['product_description'] as $language_id => $value) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "product_description SET product_id = '" . (int)$product_id . "', language_id = '" . (int)$language_id . "', name = '" . $this->db->escape($value['name']) . "', meta_keyword = '" . $this->db->escape($value['meta_keyword']) . "', meta_description = '" . $this->db->escape($value['meta_description']) . "', description = '" . $this->db->escape($value['description']) . "', tag = '" . $this->db->escape($value['tag']) . "'");
		}

		$this->db->query("INSERT INTO " . DB_PREFIX . "product_to_store SET product_id = '" . (int)$product_id . "', store_id = '0'");



		$sql  = "INSERT INTO " . DB_PREFIX . "printable_product SET ";
		$sql .= " product_id = '" . $product_id . "',";
		$sql .= " default_view = '" . $this->db->escape($product_obj->product->default_view) . "',";
		$sql .= " default_region = '" . $this->db->escape($product_obj->product->default_region) . "',";
		$sql .= " default_color = '" . $this->db->escape($product_obj->product->default_color) . "',";
		$sql .= " colors_number = '" . $this->db->escape($product_obj->product->colors_number) . "' ";
		$this->db->query($sql);


		$ID = $product_id;
		
		
		@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/products/'.$product_obj->product->image,  DIR_IMAGE . 'data/products/'.$product_obj->product->image);
		
		
	
		/*foreach($product_obj->keywords as $keyword)
		{
			$fields = 'INSERT INTO `' . DB_PREFIX . 'product_keyword` ';
			$fields .= '(`product_id`,`keyword`)';
			$values = ' VALUES (';
			$values .= '\''.$ID.'\',';
			$values .= '\''.$this->db->escape($keyword).'\'';
			$values .= ');'.PHP_EOL;
			
			$sql = $fields.$values;
		
			$query = $this->db->query($sql);
		}*/
		
		foreach($product_obj->views as $view_obj)
		{
			$fields = 'INSERT INTO `' . DB_PREFIX . 'printable_product_view` (`product_id`,`view_index`,`name`,`regions_scale`,`shade`) ';
			$values = ' VALUES (\''.$ID.'\', \''.$view_obj->view->view_index.'\', \''.$this->db->escape($view_obj->view->name).'\',\''.$view_obj->view->regions_scale.'\',\''.$this->db->escape($view_obj->view->shade).'\'); '.PHP_EOL;
			$sql = $fields.$values;
		
			$query = $this->db->query($sql);
			
			@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/products/'.$view_obj->view->shade,  DIR_IMAGE . 'data/products/'.$view_obj->view->shade);
			
			foreach($view_obj->regions as $region_obj)
			{
				$fields = 'INSERT INTO `' . DB_PREFIX . 'printable_product_view_region` (`product_id`,`view_index`,`region_index`,`name`,`x`,`y`,`width`,`height`) ';
				$values = ' VALUES (\''.$ID.'\', \''.$region_obj->view_index.'\', \''.$region_obj->region_index.'\', \''.$this->db->escape($region_obj->name).'\',\''.$region_obj->x.'\',\''.$region_obj->y.'\',\''.$region_obj->width.'\',\''.$region_obj->height.'\'); '.PHP_EOL;
				$sql = $fields.$values;
			
				$query = $this->db->query($sql);

			}
			
			foreach($view_obj->view_fill as $fill_obj)
			{
				$fields = 'INSERT INTO `' . DB_PREFIX . 'printable_product_view_fill` (`product_id`,`view_index`,`view_fill_index`,`file`) ';
				$values = ' VALUES (\''.$ID.'\', \''.$fill_obj->view_index.'\', \''.$fill_obj->view_fill_index.'\',\''.$this->db->escape($fill_obj->file).'\'); '.PHP_EOL;
				$sql = $fields.$values;
			
				$query = $this->db->query($sql);

				@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/products/'.$fill_obj->file,  DIR_IMAGE . 'data/products/'.$fill_obj->file);

			}
		}
		
		foreach($product_obj->colors_sizes as $color_size)
		{
			$fields = 'INSERT INTO `' . DB_PREFIX . 'printable_product_product_color_product_size` ';
			$fields .= '(`product_id`,`id_product_color`,`id_product_size`)';
			$values = ' VALUES (';
			$values .= '\''.$ID.'\',';
			$values .= '\''.$color_size->id_product_color.'\',';
			$values .= '\''.$color_size->id_product_size.'\'';
			$values .= ');'.PHP_EOL;
			
			$sql = $fields.$values;
		
			$query = $this->db->query($sql);
		}
		
		/*foreach($product_obj->sizes_upcharge as $upcharge)
		{
			$fields = 'INSERT INTO `' . DB_PREFIX . 'product_size_upcharge` ';
			$fields .= '(`product_id`,`id_product_size`,`upcharge`)';
			$values = ' VALUES (';
			$values .= '\''.$ID.'\',';
			$values .= '\''.$upcharge->id_product_size.'\',';
			$values .= '\''.$upcharge->upcharge.'\'';
			$values .= ');'.PHP_EOL;
			
			$sql = $fields.$values;
		
			$query = $this->db->query($sql);
		}
		
		foreach($product_obj->quantities as $quantity)
		{
			$fields = 'INSERT INTO `' . DB_PREFIX . 'product_quantity` ';
			$fields .= '(`product_id`,`quantity_index`,`quantity`)';
			$values = ' VALUES (';
			$values .= '\''.$ID.'\',';
			$values .= '\''.$quantity->quantity_index.'\',';
			$values .= '\''.$quantity->quantity.'\'';
			$values .= ');'.PHP_EOL;
			
			$sql = $fields.$values;
		
			$query = $this->db->query($sql);
			
			foreach($quantity->prices as $price)
			{
				$fields = 'INSERT INTO `' . DB_PREFIX . 'product_quantity_price` ';
				$fields .= '(`product_id`,`quantity_index`,`id_product_color_group`,`price`)';
				$values = ' VALUES (';
				$values .= '\''.$ID.'\',';
				$values .= '\''.$quantity->quantity_index.'\',';
				$values .= '\''.$price->id_product_color_group.'\',';
				$values .= '\''.$price->price.'\'';
				$values .= ');'.PHP_EOL;
				
				$sql = $fields.$values;
			
				$query = $this->db->query($sql);				
			}
			
		}*/
		
		return $ID;
	}
	
	public function get_files($product_id)
	{
		$files = array();
		$query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product WHERE product_id='".$product_id."' ");
		
		if($query->row['image'] && file_exists(DIR_IMAGE . 'data/products/' . $query->row['image'])) {
			$files[] = array('source'=>DIR_IMAGE . 'data/products/' . $query->row['image'], 'dest'=> basename(DIR_IMAGE) . '/data/products/' . $query->row['image']);
		}
		
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_view WHERE product_id='".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result) {
					$files[] = array('source'=>DIR_IMAGE . 'data/products/' . $result['shade'], 'dest'=> basename(DIR_IMAGE) . '/data/products/' . $result['shade']);
					if($query_view_fill = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_view_fill WHERE product_id='".$product_id."' AND view_index='".$result['view_index']."' "))
					{
						foreach ($query_view_fill->rows as $result_view_fill) {
							$files[] = array('source'=>DIR_IMAGE . 'data/products/' . $result_view_fill['file'], 'dest'=> basename(DIR_IMAGE) . '/data/products/' . $result_view_fill['file']);
						}
					}
				}
			} else {
				throw new ErrorException("ERROR: product without views");
			}
		}
		return $files;
	}	

	
	public function dump($product_id)
	{
		$this->load->model('install/view');
		
		$response = array();
		$response['product'] = $this->dump_product_fields($product_id);
		/*$response['categories'] = $this->dump_product_categories($product_id);
		$response['keywords'] = $this->dump_product_keywords($product_id);
		$response['colors_sizes'] = $this->dump_product_colors_sizes($product_id);
		$response['sizes_upcharge'] = $this->dump_product_sizes_upcharge($product_id);
		$response['quantities'] = $this->dump_product_quantities($product_id);
		$response['views'] = $this->model_install_view->dump($product_id);*/
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
				$response = $row;
			} else {
				throw new ErrorException("ERROR: product ID: $product_id doesnt exists");
			}
		}
		return $response;
	}
	
	private function dump_product_categories($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_product_category WHERE product_id='".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$response[] = $result['id_category'];
				}	
			}
		}
		return $response;
	}
	
	private function dump_product_keywords($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_keyword WHERE product_id='".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$response[] = $result['keyword'];
				}	
			}
		}
		return $response;
	}
	private function dump_product_colors_sizes($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_product_color_product_size WHERE product_id='".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$response[] = $result;
				}	
			}
		}
		return $response;
	}

	private function dump_product_sizes_upcharge($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_size_upcharge WHERE product_id='".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$response[] = $result;
				}	
			}
		}
		return $response;
	}

	private function dump_product_quantities($product_id)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_quantity WHERE product_id='".$product_id."' ORDER BY quantity ASC "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$quantity['product_id'] = $result['product_id'];
					$quantity['quantity_index'] = $result['quantity_index'];
					$quantity['quantity'] = $result['quantity'];
					$quantity['prices'] = $this->dump_quantity_prices($product_id, $result['quantity_index']);
					$response[] = $quantity;
				}	
			} else {
				throw new ErrorException("ERROR: Product without quantities");
			}
		}
		return $response;
	}
	private function dump_quantity_prices($product_id, $quantity_index)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_quantity_price WHERE product_id='".$product_id."' AND quantity_index='".$quantity_index."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$response[] = $result;
				}	
			}
		}
		return $response;
	}


}
?>