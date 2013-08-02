<?php

class DesignElement {

	public static $table = "design_element";
	var $db;
	var $data;
	var $last_error;
	
	function __construct($db)
	{
		$this->db = $db;
	}
		
	function setFieldsData($data)
	{
		foreach($data as $key => $value) 	
		{
			$this->data[$key]  = $value;
		}
	}
	function setDesign($id_design)
	{
		$this->data["id_design"] = $id_design;  
	}
	function setDesignElement($id_design_element)
	{
		$this->data["id_design_element"] = $id_design_element;  
	}
	function setType($type)
	{
		switch($type)
		{
			case 'CLIPART':
				$this->data["type"] = 1;
				break;
			case 'TEXT':
				$this->data["type"] = 2;
				break;
			case 'BITMAP':
				$this->data["type"] = 3;
				break;
		}
	}
	function setSorting($i)
	{
		$this->data["sorting"] = $i;  
	}

	function save()
	{
		
		$sql  = "INSERT INTO " . DB_PREFIX . "design_element SET ";
		$sql .= " id_design = '" . $this->data["id_design"] . "',";
		$sql .= " sorting = '" . $this->data["sorting"] . "',";
		$sql .= " id_design_element = '" . $this->data["id_design_element"] . "',";
		$sql .= " type = '" . $this->data["type"] . "' ";

		if($this->db->query($sql))
		{
			return true;
		}else
		{
			$this->last_error="Error inserting data into database: ";
			return false;
		}
	}
	function delete()
	{
		$sql="DELETE FROM ".DB_PREFIX."design_element WHERE id_design='".$this->data["id_design"]."' AND sorting='".$this->data["sorting"]."' ";
		if($query = $this->db->query($sql))
		{
			return true;
		}else
		{
			$this->last_error="Error trying to delete: ";
			return false;
		}
	}
}
?>