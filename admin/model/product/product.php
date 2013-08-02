<?php
class ModelProductProduct extends Model {
public function editProduct($product_id, $data) {
		
		//remove printable product
		$this->removeProduct($product_id);

		$sql  = "INSERT INTO " . DB_PREFIX . "printable_product SET ";
		$sql .= " product_id = '" . $this->db->escape($product_id) . "',";
		$sql .= " default_view = '0',"; //will be updated below
		$sql .= " default_region = '0',"; //will be updated below
		$sql .= " default_color = '" . $this->db->escape($data['default_color']) . "',";
		$sql .= " colors_number = '" . $this->db->escape($data['colors_number']) . "', ";
		$sql .= " printable_status = '" . $this->db->escape($data['printable_status']) . "' ";
		$this->db->query($sql);
		
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_product_color_product_size WHERE product_id = '" . $product_id . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_option WHERE product_id = '" . (int)$product_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "product_option_value WHERE product_id = '" . (int)$product_id . "'");
		
		if(isset($data['color_size']))
		{
			$this->load->model('product/color');
			$validColors = $this->model_product_color->getColors(array('filter_num_colors' => $data['colors_number']));

			$this->load->model('product/size');
			$validSizes = $this->model_product_size->getSizes();
			
			if($this->config->get('product_color_option_id')) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_option SET product_id = '" . (int)$product_id . "', option_id = '" . (int)$this->config->get('product_color_option_id') . "', required = '1'");
				
				$product_option_id_color = $this->db->getLastId();
			}
			if($this->config->get('product_size_option_id')) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "product_option SET product_id = '" . (int)$product_id . "', option_id = '" . (int)$this->config->get('product_size_option_id') . "', required = '1'");
				
				$product_option_id_size = $this->db->getLastId();
			}


			$saved_sizes = array();
			foreach($data['color_size'] as $id_product_color=>$sizes)
			{
				if(isset($validColors[$id_product_color]))
				{
					if($product_option_id_color) {
						$this->db->query("INSERT INTO " . DB_PREFIX . "product_option_value SET product_option_id = '" . (int)$product_option_id_color . "', product_id = '" . $product_id . "', option_id = '" . (int)$this->config->get('product_color_option_id') . "', option_value_id = '" . (int)$validColors[$id_product_color]['option_value_id']. "', quantity = '0', subtract = '0', price = '0', price_prefix = '+', points = '0', points_prefix = '+', weight = '0', weight_prefix = '0'");
					}
							

					foreach($sizes as $id_product_size=>$value)
					{
						if($product_option_id_size) {
							if(!in_array($id_product_size, $saved_sizes)) {
								$this->db->query("INSERT INTO " . DB_PREFIX . "product_option_value SET product_option_id = '" . (int)$product_option_id_size . "', product_id = '" . $product_id . "', option_id = '" . (int)$this->config->get('product_size_option_id') . "', option_value_id = '" . (int)$validSizes[$id_product_size]['option_value_id'] . "', quantity = '0', subtract = '0', price = '0', price_prefix = '+', points = '0', points_prefix = '+', weight = '0', weight_prefix = '0'");
								$saved_sizes[] = $id_product_size;
							}
						}

						$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_product_color_product_size SET ";
						$sql .= " product_id = '" . $product_id . "',";
						$sql .= " id_product_color = '" . $id_product_color . "', ";
						$sql .= " id_product_size = '" . $id_product_size . "' ";
						$this->db->query($sql);
					}
				}
			}	
		}

		$sql  = "DELETE FROM " . DB_PREFIX . "printable_product_quantity WHERE product_id = '" . $product_id . "' ";
		$this->db->query($sql);
		$sql  = "DELETE FROM " . DB_PREFIX . "printable_product_quantity_price WHERE product_id = '" . $product_id . "' ";
		$this->db->query($sql);

		
		
		if(isset($data['quantities']) && isset($data['price']))
		{
			$price = 999999999999999999999999;

			foreach($data['quantities'] as $key => $quantity)
			{
				$quantity_index =  $key;
				
				$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_quantity SET ";
				$sql .= " product_id = '" . $product_id . "',";
				$sql .= " quantity_index = '" . $quantity_index . "',";
				$sql .= " quantity = '" . $quantity . "' ";
				$this->db->query($sql);
				
				foreach($data['price'] as $id_product_color_group => $color_group_prices)
				{					
					$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_quantity_price SET ";
					$sql .= " product_id = '" . $product_id . "',";
					$sql .= " quantity_index = '" . $quantity_index . "', ";
					$sql .= " id_product_color_group = '" . $id_product_color_group . "', ";
					$sql .= " price = '" . $color_group_prices[$quantity_index] . "' ";
					$this->db->query($sql);

					$price = min($price, $color_group_prices[$quantity_index]);
				}
				
			}

			$this->db->query("UPDATE " . DB_PREFIX . "product SET price = '" . (float)$price . "', date_modified = NOW() WHERE product_id = '" . (int)$product_id . "'");
		}



		
		$sql  = "DELETE FROM " . DB_PREFIX . "printable_product_size_upcharge WHERE product_id = '" . $product_id . "' ";
		$this->db->query($sql);
		
		if(isset($data['upcharge']))
		{
			foreach($data['upcharge'] as $id_product_size => $upcharge)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_size_upcharge SET ";
				$sql .= " product_id = '" . $product_id . "',";
				$sql .= " id_product_size = '" . $id_product_size . "', ";
				$sql .= " upcharge = '" . $upcharge . "' ";
				$this->db->query($sql);				
			}
		}
		
		$sql  = "DELETE FROM " . DB_PREFIX . "printable_product_view_fill WHERE product_id = '" . $product_id . "' ";
		$this->db->query($sql);
		$sql  = "DELETE FROM " . DB_PREFIX . "printable_product_view_region WHERE product_id = '" . $product_id . "' ";
		$this->db->query($sql);
		$sql  = "DELETE FROM " . DB_PREFIX . "printable_product_view WHERE product_id = '" . $product_id . "' ";
		$this->db->query($sql);
		if(isset($data['views']))
		{
			$view_index = 0;
			foreach($data['views'] as $form_view_index => $view)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_view SET ";
				$sql .= " product_id = '" . $product_id . "',";
				$sql .= " view_index = '" . $view_index . "', ";
				$sql .= " name = '" . $this->db->escape($view['name']) . "', ";
				$sql .= " regions_scale = '" . $view['regions_scale'] . "', ";
				$sql .= " shade = '" . $this->db->escape($view['shade']) . "', ";
				$sql .= " underfill = '" . $this->db->escape($view['underfill']) . "' ";
				$this->db->query($sql);
				
				if(isset($view['regions']))
				{
					$region_index = 0;
					foreach($view['regions'] as $form_region_index => $region)
					{
						$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_view_region SET ";
						$sql .= " product_id = '" . $product_id . "',";
						$sql .= " view_index = '" . $view_index . "', ";
						$sql .= " region_index = '" . $region_index . "', ";
						$sql .= " name = '" . $this->db->escape($region['name']) . "', ";
						$sql .= " x = '" . $region['x'] . "', ";
						$sql .= " y = '" . $region['y'] . "', ";
						$sql .= " width = '" . $region['width'] . "', ";
						$sql .= " height = '" . $region['height'] . "', ";
						$sql .= " mask = '" . $region['mask'] . "' ";
						$this->db->query($sql);
						
						if($data['default_region']==$form_view_index.'_'.$form_region_index) {
							$sql  = "UPDATE " . DB_PREFIX . "printable_product SET ";
							$sql .= " default_view = '" . $view_index . "',";
							$sql .= " default_region = '" . $region_index . "'";
							$sql .= " WHERE product_id = '" . $product_id . "' ";
							$this->db->query($sql);							
						}
						
						$region_index++;			
					}
				}
	
				if(isset($view['fills']))
				{
					$view_fill_index = 0;
					foreach($view['fills'] as $fill)
					{
						$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_view_fill SET ";
						$sql .= " product_id = '" . $product_id . "',";
						$sql .= " view_index = '" . $view_index . "', ";
						$sql .= " view_fill_index = '" . $view_fill_index . "', ";
						$sql .= " file = '" . $this->db->escape($fill) . "' ";
						$this->db->query($sql);
						
						$view_fill_index++;			
					}
				}
				
				$view_index++;
			}
		}
		
		return $product_id;
	}

	public function getProducts($data = array()) {

		$sql = "SELECT *, p.product_id AS p_id FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id)";
		
		if (!empty($data['filter_category_id'])) {
			$sql .= " LEFT JOIN " . DB_PREFIX . "product_to_category p2c ON (p.product_id = p2c.product_id)";			
		}

		$sql .= " LEFT JOIN " . DB_PREFIX . "printable_product p2pp ON (p.product_id = p2pp.product_id)";			
				
		$sql .= " WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "'"; 
		
		if (!empty($data['filter_name'])) {
			$sql .= " AND LCASE(pd.name) LIKE '" . $this->db->escape(utf8_strtolower($data['filter_name'])) . "%'";
		}

		if (!empty($data['filter_model'])) {
			$sql .= " AND LCASE(p.model) LIKE '" . $this->db->escape(utf8_strtolower($data['filter_model'])) . "%'";
		}
		
		if (!empty($data['filter_price'])) {
			$sql .= " AND p.price LIKE '" . $this->db->escape($data['filter_price']) . "%'";
		}
		
		if (isset($data['filter_quantity']) && !is_null($data['filter_quantity'])) {
			$sql .= " AND p.quantity = '" . $this->db->escape($data['filter_quantity']) . "'";
		}
		
		if (isset($data['filter_status']) && !is_null($data['filter_status'])) {
			$sql .= " AND p.status = '" . (int)$data['filter_status'] . "'";
		}

		if (isset($data['filter_printable'])) {
			if($data['filter_printable']==1) {
				$sql .= " AND p.product_id = p2pp.product_id AND p2pp.printable_status = '1' ";
			} else {
				$sql .= " AND ( p2pp.product_id IS NULL OR ( p.product_id = p2pp.product_id AND p2pp.printable_status = '0' ) ) ";
			}
		}
				
		if (!empty($data['filter_category_id'])) {
			if (!empty($data['filter_sub_category'])) {
				$implode_data = array();
				
				$implode_data[] = "category_id = '" . (int)$data['filter_category_id'] . "'";
				
				$this->load->model('catalog/category');
				
				$categories = $this->model_catalog_category->getCategories($data['filter_category_id']);
				
				foreach ($categories as $category) {
					$implode_data[] = "p2c.category_id = '" . (int)$category['category_id'] . "'";
				}
				
				$sql .= " AND (" . implode(' OR ', $implode_data) . ")";			
			} else {
				$sql .= " AND p2c.category_id = '" . (int)$data['filter_category_id'] . "'";
			}
		}
		
		$sql .= " GROUP BY p.product_id";
					
		$sort_data = array(
			'pd.name',
			'p.model',
			'p.price',
			'p.quantity',
			'p.status',
			'p.sort_order'
		);	
		
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];	
		} else {
			$sql .= " ORDER BY pd.name";	
		}
		
		if (isset($data['order']) && ($data['order'] == 'DESC')) {
			$sql .= " DESC";
		} else {
			$sql .= " ASC";
		}
	
		if (isset($data['start']) || isset($data['limit'])) {
			if ($data['start'] < 0) {
				$data['start'] = 0;
			}				

			if ($data['limit'] < 1) {
				$data['limit'] = 20;
			}	
		
			$sql .= " LIMIT " . (int)$data['start'] . "," . (int)$data['limit'];
		}	
		$query = $this->db->query($sql);
		return $query->rows;
	}

	public function getTotalProducts($data = array()) {
		$sql = "SELECT COUNT(DISTINCT p.product_id) AS total FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id)";

		if (!empty($data['filter_category_id'])) {
			$sql .= " LEFT JOIN " . DB_PREFIX . "product_to_category p2c ON (p.product_id = p2c.product_id)";			
		}

		$sql .= " LEFT JOIN " . DB_PREFIX . "printable_product p2pp ON (p.product_id = p2pp.product_id )";			
		 
		$sql .= " WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "'";
		 			
		if (!empty($data['filter_name'])) {
			$sql .= " AND LCASE(pd.name) LIKE '" . $this->db->escape(utf8_strtolower($data['filter_name'])) . "%'";
		}

		if (!empty($data['filter_model'])) {
			$sql .= " AND LCASE(p.model) LIKE '" . $this->db->escape(utf8_strtolower($data['filter_model'])) . "%'";
		}
		
		if (!empty($data['filter_price'])) {
			$sql .= " AND p.price LIKE '" . $this->db->escape($data['filter_price']) . "%'";
		}
		
		if (isset($data['filter_quantity']) && !is_null($data['filter_quantity'])) {
			$sql .= " AND p.quantity = '" . $this->db->escape($data['filter_quantity']) . "'";
		}
		
		if (isset($data['filter_status']) && !is_null($data['filter_status'])) {
			$sql .= " AND p.status = '" . (int)$data['filter_status'] . "'";
		}

		if (isset($data['filter_printable'])) {
			if($data['filter_printable']==1) {
				$sql .= " AND p.product_id = p2pp.product_id AND p2pp.printable_status = '1' ";
			} else {
				$sql .= " AND ( p2pp.product_id IS NULL OR ( p.product_id = p2pp.product_id AND p2pp.printable_status = '0' ) ) ";
			}
		}

		if (!empty($data['filter_category_id'])) {
			if (!empty($data['filter_sub_category'])) {
				$implode_data = array();
				
				$implode_data[] = "p2c.category_id = '" . (int)$data['filter_category_id'] . "'";
				
				$this->load->model('catalog/category');
				
				$categories = $this->model_catalog_category->getCategories($data['filter_category_id']);
				
				foreach ($categories as $category) {
					$implode_data[] = "p2c.category_id = '" . (int)$category['category_id'] . "'";
				}
				
				$sql .= " AND (" . implode(' OR ', $implode_data) . ")";			
			} else {
				$sql .= " AND p2c.category_id = '" . (int)$data['filter_category_id'] . "'";
			}
		}
		
		$query = $this->db->query($sql);

		return $query->row['total'];
	}	

	public function getProduct($product_id)
	{
		$query = $this->db->query('SELECT * FROM '.DB_PREFIX.'printable_product WHERE product_id="'.$product_id.'" ');
		if($query->num_rows > 0) {
			$product = array(
				'product_id'	=> $query->row['product_id'],
				'colors_number'		=> $query->row['colors_number'],
				'default_view'		=> $query->row['default_view'],
				'default_region'		=> $query->row['default_region'],
				'default_color'		=> $query->row['default_color'],
				'printable_status' => $query->row['printable_status']
			);
			return $product;
		} else {
			return false;
		}
	}

	
	public function getPrintableProducts() {
		$products = array();
		$sql = "SELECT product_id FROM " . DB_PREFIX . "printable_product WHERE printable_status = '1' ";
		$query = $this->db->query($sql);
		if($query->num_rows > 0) {
			foreach ($query->rows as $result) {
				$products[$result['product_id']] = true;
	    	}	
		}
		return $products;
	}

	public function setToDefaultProduct($product_id)
	{
		$query = $this->db->query("UPDATE " . DB_PREFIX . "setting SET `value` = '".$product_id."' WHERE `key`='default_product' LIMIT 1 ");
	}
	
	public function removeProduct($product_id)
	{		
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product WHERE product_id = '" . $product_id . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_product_color_product_size WHERE product_id = '" . $product_id . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_quantity WHERE product_id = '" . $product_id . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_quantity_price WHERE product_id = '" . $product_id . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_size_upcharge WHERE product_id = '" . $product_id . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_view WHERE product_id = '" . $product_id . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_view_fill WHERE product_id = '" . $product_id . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_view_region WHERE product_id = '" . $product_id . "' ");	

	}

	public function getColorsSizes($product_id) 
	{
		$sql = "SELECT id_product_color, id_product_size FROM " . DB_PREFIX . "printable_product_product_color_product_size WHERE product_id='".$product_id."'  "; 
		$query = $this->db->query($sql);
		
		$col_sizes = array();
		foreach ($query->rows as $result) {
			$col_sizes[$result['id_product_color']][$result["id_product_size"]] = true;
    	}	
		return $col_sizes;
	}
	public function getPrice($product_id) 
	{
		$price = array();
		
		foreach ($this->getQuantities($product_id) as $index => $quantity) {
			$sql = "SELECT * FROM " . DB_PREFIX . "printable_product_quantity_price pp WHERE product_id='".$product_id."' AND quantity_index ='".$index."'  "; //q.quantity='".$quantity."' AND q.quantity_index=pp.quantity_index  "; 
			$query = $this->db->query($sql);
			foreach ($query->rows as $result) {
				$price[$result['id_product_color_group']][$index] = $result['price'];
			}
    	}	
		return $price;
	}
	public function getQuantities($product_id) 
	{
		$sql = "SELECT * FROM " . DB_PREFIX . "printable_product_quantity WHERE product_id='".$product_id."' ORDER BY quantity ASC "; 
		$query = $this->db->query($sql);
		
		$array = array();
		foreach ($query->rows as $result) {
			$array[$result['quantity_index']] = $result['quantity'];
    	}	
		return $array;
	}
	
	public function getUpcharge($product_id) 
	{
		$sql = "SELECT id_product_size, upcharge FROM " . DB_PREFIX . "printable_product_size_upcharge WHERE product_id='".$product_id."' "; 
		$query = $this->db->query($sql);
		
		$array = array();
		foreach ($query->rows as $result) {
			$array[$result['id_product_size']] = $result['upcharge'];
    	}	
		return $array;
	}
	public function getSizes($product_id) 
	{
		$sql="SELECT DISTINCT(ppcps.id_product_size) FROM " . DB_PREFIX . "printable_product_product_color_product_size ppcps, " . DB_PREFIX . "printable_product_size ps WHERE ps.id_product_size=ppcps.id_product_size AND product_id='".$product_id."' ORDER BY ps.sort ASC ";
		$query = $this->db->query($sql);
		
		$sizes = array();
		foreach ($query->rows as $result) {
			$sizes[] = $result["id_product_size"];
    	}	
		return $sizes;
	}

	public function getColors($product_id) 
	{
		$sql="SELECT DISTINCT(ppcps.id_product_color) FROM " . DB_PREFIX . "printable_product_product_color_product_size ppcps, " . DB_PREFIX . "printable_product_color pc WHERE pc.id_product_color=ppcps.id_product_color AND product_id='".$product_id."'  ORDER BY pc.name ASC ";
		$query = $this->db->query($sql);
		
		$colors = array();
		foreach ($query->rows as $result) {
			$colors[] = $result["id_product_color"];
    	}	
		return $colors;
	}

}
?>