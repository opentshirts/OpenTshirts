<?php
class ModelInstallDesignColor extends Model {
	public function install($design_color_obj, $overwrite = false)
	{
		if(isset($design_color_obj->id_design_color)) {
			$query = $this->db->query("SELECT id_design_color FROM `" . DB_PREFIX . "design_color` WHERE id_design_color='".$design_color_obj->id_design_color."' ");
			if($query->num_rows>0)
			{
				if($overwrite) {
					$this->load->model('design_color/design_color');
					$this->model_design_color_design_color->remove($design_color_obj->id_design_color);
				} else {
					return false;
				}
			}
		}
		
		$ID = $design_color_obj->id_design_color;
		
		$sql  = "INSERT INTO " . DB_PREFIX . "design_color SET ";
		$sql .= " id_design_color = '" . $ID . "',";
		$sql .= " name = '" . $this->db->escape($design_color_obj->name) . "',";
		$sql .= " hexa = '" . $this->db->escape($design_color_obj->hexa) . "',";
		$sql .= " alpha = '" . $this->db->escape($design_color_obj->alpha) . "',";
		$sql .= " code = '" . $this->db->escape($design_color_obj->code) . "',";
		$sql .= " need_white_base = '" . $this->db->escape($design_color_obj->need_white_base) . "',";
		$sql .= " isdefault = '" . $this->db->escape($design_color_obj->isdefault) . "',";
		$sql .= " available = '" . $this->db->escape($design_color_obj->available) . "',";
		$sql .= " deleted = '" . $this->db->escape($design_color_obj->deleted) . "' ";
		
		$query = $this->db->query($sql);
				
		return $ID;
	}
	
	public function dump($id_design_color)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "design_color WHERE id_design_color='".$id_design_color."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				$response = $row;
			} else {
				throw new ErrorException("ERROR: design_color doesnt exists: id_design_color=".$id_design_color);
			}
		}
		return $response;
	}


}
?>