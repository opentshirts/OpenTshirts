<?php
class ModelInstallProductManufacturer extends Model {
	public function install($manufacturer_obj)
	{
		if(isset($manufacturer_obj->id_manufacturer)) { //if already exists just return
			$query = $this->db->query("SELECT id_manufacturer FROM `" . DB_PREFIX . "product_manufacturer` WHERE id_manufacturer='".$manufacturer_obj->id_manufacturer."' ");
			if($query->num_rows>0)
			{
				return false;
			}
		}
		
		$ID = $manufacturer_obj->id_manufacturer;
		
		$sql  = "INSERT INTO " . DB_PREFIX . "product_manufacturer SET ";
		$sql .= " id_manufacturer = '" . $ID . "',";
		$sql .= " name = '" . $this->db->escape($manufacturer_obj->name) . "' ";
		
		$query = $this->db->query($sql);
				
		return $ID;
	}
	
	public function dump($id_manufacturer)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_manufacturer WHERE id_manufacturer='".$id_manufacturer."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				$response = $row;
			} else {
				throw new ErrorException("ERROR: product manufacturer doesnt exists: id_manufacturer=".$id_manufacturer);
			}
		}
		return $response;
	}


}
?>