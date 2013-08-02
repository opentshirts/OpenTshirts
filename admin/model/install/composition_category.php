<?php
class ModelInstallCompositionCategory extends Model {
	public function install($category_obj)
	{
		if(isset($category_obj->id_category)) { //if already exists just return
			$query = $this->db->query("SELECT id_category FROM `" . DB_PREFIX . "composition_category` WHERE id_category='".$category_obj->id_category."' ");
			if($query->num_rows>0)
			{
				return false;
			}
		}
		
		$ID = $category_obj->id_category;
		
		$sql  = "INSERT INTO " . DB_PREFIX . "composition_category SET ";
		$sql .= " id_category = '" . $ID . "',";
		if($category_obj->parent_category) {
			$sql .= " parent_category = '" . $this->db->escape($category_obj->parent_category) . "',";
		}
		$sql .= " description = '" . $this->db->escape($category_obj->description) . "' ";
		
		$query = $this->db->query($sql);
				
		return $ID;
	}
	
	public function dump($id_category)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "composition_category WHERE id_category='".$id_category."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				$response = $row;
			} else {
				throw new ErrorException("ERROR: composition category doesnt exists: id_category=".$id_category);
			}
		}
		return $response;
	}


}
?>