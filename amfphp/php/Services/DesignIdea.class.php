<?php

class DesignIdea {

	private $db;
	var $data;
	var $last_error;
	var $designs;
	
	function __construct($db)
	{
		$this->db = $db;
		$this->designs = array();
	}
			
	function setFieldsData($data)
	{
		foreach($data as $key => $value) 	
		{
			$this->data[$key]  = $value;
		}
	}

	function save()
	{
		if(isset($this->data["id_composition"]))
		{
			return $this->update();
		}else
		{
			return $this->insert();
		}
	}
	public function insert() {
		
		$query = $this->db->query('SELECT UUID()');
		$this->data["id_composition"] = $query->row['UUID()'];
		
		$sql  = "INSERT INTO " . DB_PREFIX . "composition SET ";
		$sql .= " id_composition = '" . $this->data["id_composition"] . "',";
		$sql .= " name = '" . $this->db->escape($this->data['name']) . "',";
		$sql .= " id_author = '" . $this->db->escape($this->data['id_author']) . "',";
		$sql .= " id_product_color = '" . $this->db->escape($this->data['id_product_color']) . "',";
		$sql .= " product_id = '" . $this->db->escape($this->data['product_id']) . "' ";

		if($this->db->query($sql)) {
			if($this->saveDesigns())
			{
				return $this->data["id_composition"];
			} else {
				return false;
			}
		} else {
			unset($this->data["id_composition"]);
			$this->last_error="Error inserting data into database: ";
			return false;
		}
	}


	public function update() {

		$sql  = "UPDATE " . DB_PREFIX . "composition SET ";
		$sql .= " name = '" . $this->db->escape($this->data['name']) . "',";
		$sql .= " id_author = '" . $this->db->escape($this->data['id_author']) . "',";
		$sql .= " id_product_color = '" . $this->db->escape($this->data['id_product_color']) . "',";
		$sql .= " product_id = '" . $this->db->escape($this->data['product_id']) . "' ";
		$sql .= " WHERE id_composition = '" . $this->data["id_composition"] . "' ";

		if($this->db->query($sql)) {
			if($this->clearDesigns() && $this->saveDesigns())
			{
				return $this->data["id_composition"];
			} else {
				return false;
			}
		} else {
			$this->last_error="Error updating data into database: ";
			return false;
		}
	}
			
	function getDesigns()
	{
		$sql = "SELECT * FROM ".DB_PREFIX."design d  WHERE d.id_composition='".$this->data["id_composition"]."' ";
    	$query = $this->db->query($sql);
		
		$designs = array();
		foreach ($query->rows as $result) {
			$designs[] = $result["id_design"];
		}
		return $designs;
	}
	function addDesign($design)
	{
		$this->designs[] = $design;
	}
	function saveDesigns()
	{
		foreach($this->designs as $design)
		{
			$design->setComposition($this->data["id_composition"]);
			if(!$design->save())
			{
				$this->last_error = $design->last_error;
				return false;
			}
		}
		return true;
	}
	
	function clearDesigns()
	{
		$designs = $this->getDesigns();
		if(is_array($designs))
		{
			foreach($this->getDesigns() as $id_design)
			{
				$design = new Design($this->db);
				$design->setId($id_design);
				if(!$design->delete())
				{
					$this->last_error = $design->last_error;
					return false;
				}
			}
			return true;
		}else
		{
			$this->last_error="Empty Design Array: ".$this->last_error;
			return false;
		}
	}

	public function compositionExists($id)
	{
		$sql = "SELECT id_composition FROM ".DB_PREFIX."composition WHERE id_composition='".$id."' ";
		$query = $this->db->query($sql);
		if($query->num_rows>0)
		{
			return true;
		}
		return false;
	}
	
        
}
?>