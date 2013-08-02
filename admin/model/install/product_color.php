<?php
class ModelInstallProductColor extends Model {
	public function install($color_obj)
	{
		if(isset($color_obj->id_product_color)) { //if already exists just return
			$query = $this->db->query("SELECT id_product_color FROM `" . DB_PREFIX . "printable_product_color` WHERE id_product_color='".$color_obj->id_product_color."' ");
			if($query->num_rows>0)
			{
				return false;
			}
		}
		if($this->config->get('product_color_option_id')) {
			$option_id = $this->config->get('product_color_option_id');
			$this->db->query("INSERT INTO " . DB_PREFIX . "option_value SET option_id = '" . (int)$option_id . "', image = '', sort_order = '0'");
			
			$option_value_id = $this->db->getLastId();

			global $languages;
			foreach($languages as $language) {
				$option_value['option_value_description'][$language['language_id']] = array('name'=>$color_obj->name);
			}		
			
			foreach ($option_value['option_value_description'] as $language_id => $option_value_description) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "option_value_description SET option_value_id = '" . (int)$option_value_id . "', language_id = '" . (int)$language_id . "', option_id = '" . (int)$option_id . "', name = '" . $this->db->escape($option_value_description['name']) . "'");
			}
		} else {
			$option_value_id = 0;
		}
		
		$ID = $color_obj->id_product_color;
		
		$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_color SET ";
		$sql .= " id_product_color = '" . $ID . "',";
		$sql .= " name = '" . $this->db->escape($color_obj->name) . "',";
		$sql .= " num_colors = '" . $this->db->escape($color_obj->num_colors) . "',";
		$sql .= " need_white_base = '" . $this->db->escape($color_obj->need_white_base) . "',";
		$sql .= " id_product_color_group = '" . $this->db->escape($color_obj->id_product_color_group) . "',";
		$sql .= " option_value_id = '" . $option_value_id . "'";
		
		$query = $this->db->query($sql);
		
		foreach($color_obj->flat_color as $flat_color_obj)
		{
			$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_color_flat_color SET ";
			$sql .= " id_product_color = '" . $ID . "',";
			$sql .= " flat_color_index = '" . $this->db->escape($flat_color_obj->flat_color_index) . "',";
			$sql .= " hexa = '" . $this->db->escape($flat_color_obj->hexa) . "' ";
			
			$query = $this->db->query($sql);
		}
				
		return $option_value_id;
	}
	
	public function dump($id_product_color)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "printable_product_color WHERE id_product_color='".$id_product_color."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
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
					//unset($result['id_clipart']); //will be replacer for new id
					$response[] = $result;
				}	
			} else {
				throw new ErrorException("ERROR:  product color without flat colors: id_product_color=".$id_product_color);
			}
		}
		return $response;
	}

}
?>