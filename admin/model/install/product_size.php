<?php
class ModelInstallProductSize extends Model {
	public function install($size_obj)
	{
		if(isset($size_obj->id_product_size)) { //if already exists just return
			$query = $this->db->query("SELECT id_product_size FROM `" . DB_PREFIX . "printable_product_size` WHERE id_product_size='".$size_obj->id_product_size."' ");
			if($query->num_rows>0)
			{
				return false;
			}
		}

		if($this->config->get('product_size_option_id')) {
			$option_id = $this->config->get('product_size_option_id');
			$this->db->query("INSERT INTO " . DB_PREFIX . "option_value SET option_id = '" . (int)$option_id . "', image = '', sort_order = '0'");
			
			$option_value_id = $this->db->getLastId();

			global $languages;
			foreach($languages as $language) {
				$option_value['option_value_description'][$language['language_id']] = array('name'=>$size_obj->description);
			}		
			
			foreach ($option_value['option_value_description'] as $language_id => $option_value_description) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "option_value_description SET option_value_id = '" . (int)$option_value_id . "', language_id = '" . (int)$language_id . "', option_id = '" . (int)$option_id . "', name = '" . $this->db->escape($option_value_description['name']) . "'");
			}
		} else {
			$option_value_id = 0;
		}
		
		$ID = $size_obj->id_product_size;
		
		$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_size SET ";
		$sql .= " id_product_size = '" . $ID . "',";
		$sql .= " description = '" . $this->db->escape($size_obj->description) . "',";
		$sql .= " initials = '" . $this->db->escape($size_obj->initials) . "',";
		$sql .= " apply_additional_cost = '" . $this->db->escape($size_obj->apply_additional_cost) . "',";
		$sql .= " sort = '" . $this->db->escape($size_obj->sort) . "',";
		$sql .= " option_value_id = '" . $option_value_id . "'";
		
		$query = $this->db->query($sql);
				
		return $option_value_id;
	}
	
	public function dump($id_product_size)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_size WHERE id_product_size='".$id_product_size."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				$response = $row;
			} else {
				throw new ErrorException("ERROR: product size doesnt exists: id_product_size=".$id_product_size);
			}
		}
		return $response;
	}


}
?>