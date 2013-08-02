<?php
class ModelInstallProductCategory extends Model {
	public function install($category_obj)
	{
		
		$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "category_description` WHERE name = '".$category_obj->description."' ");
		if($query->num_rows>0)
		{
			return $query->row['category_id'];
		}
		
		
		$sql  = "INSERT INTO `" . DB_PREFIX . "category` SET ";
		$sql .= " `image` = '',";
		$sql .= " `parent_id` = 0,";
		$sql .= " `top` = 0,";
		$sql .= " `column` = 0,";
		$sql .= " `sort_order` = 0,";
		$sql .= " `status` = 1,";
		$sql .= " `date_added` = NOW(),";
		$sql .= " `date_modified` = NOW() ";

		$query = $this->db->query($sql);

		$category_id = $this->db->getLastId();	


		global $languages;
		foreach($languages as $language) {
			$data['category_description'][$language['language_id']] = array(
				'name'=>$category_obj->description,
				'meta_keyword'=>$category_obj->description,
				'meta_description'=>$category_obj->description,
				'description'=>$category_obj->description
				);
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

				
		return $category_id;
	}
	public function update_parent($category_id, $parent_id)
	{
		$sql  = "UPDATE " . DB_PREFIX . "category SET parent_id = '" . $parent_id . "' WHERE category_id = '" . $category_id . "' LIMIT 1 ";
		$query = $this->db->query($sql);
	}
	
	public function dump($id_category)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_category WHERE id_category='".$id_category."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				$response = $row;
			} else {
				throw new ErrorException("ERROR: product category doesnt exists: id_category=".$id_category);
			}
		}
		return $response;
	}


}
?>