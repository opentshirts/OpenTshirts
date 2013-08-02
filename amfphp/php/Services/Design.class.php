<?php

class Design {

	private $db;
	var $data;
	var $last_error;
	private $snapshotStream;
	private $snapshotDesignStream;
	private $design_elements;
	private $num_colors;
	private $need_white_base;
	
	function __construct($db)
	{
		$this->db = $db;
		$this->design_elements = array();
	}
			
	function setId($id)
	{
		$this->data["id_design"] = $id;
	}
	function setXML($xml)
	{
		$this->data["xml"] = $xml;
	}
	function setComposition($id_comp)
	{
		$this->data["id_composition"] = $id_comp;  
	}
	function setSnapshot($stream)
	{
		$this->snapshotStream = $stream;
	}
	function setOnlyDesignSnapshot($stream)
	{
		$this->snapshotDesignStream = $stream;
	}
	function setNumColors($num_colors)
	{
		$this->data["num_colors"] = $num_colors;
	}
	function setNeedWhiteBase($need_white_base)
	{
		$this->data["need_white_base"] = $need_white_base;
	}


	function addDesignElement($deObj)
	{
		$this->design_elements[] = $deObj;
	}
	
	function save()
	{
		
		$query = $this->db->query('SELECT UUID()');
		$this->data["id_design"] = $query->row['UUID()'];
		
		$sql  = "INSERT INTO " . DB_PREFIX . "design SET ";
		$sql .= " id_composition = '" . $this->data["id_composition"] . "',";
		$sql .= " id_design = '" . $this->data["id_design"] . "',";
		$sql .= " num_colors = '" . $this->data["num_colors"] . "',";
		$sql .= " need_white_base = '" . $this->data["need_white_base"] . "',";
		$sql .= " xml = '" . $this->db->escape($this->data['xml']) . "' ";

		if($this->db->query($sql)) {
			if($this->saveSnapshot() && $this->saveDesignElements())
			{
				return $this->data["id_design"];
			}else
			{
				return false;
			}
		}else
		{
			$this->last_error="Error inserting data into database: ";
			return false;
		}
	}
	
	function saveDesignElements()
	{
		$i = 1;
		foreach($this->design_elements as $design_element)
		{
			$design_element->setDesign($this->data["id_design"]);
			$design_element->setSorting($i);
			if(!$design_element->save())
			{
				error_log('error');
				$this->last_error = $design_element->last_error;
				return false;
			}
			$i++;
		}
		return true;
	}
	function getDesignElements()
	{
		$sql = "SELECT * FROM ".DB_PREFIX."design_element WHERE id_design='".$this->data["id_design"]."' ORDER BY sorting ASC  ";
		$query = $this->db->query($sql);

		$elements = array();
		foreach ($query->rows as $result) {
			$designElement = new DesignElement($this->db);
			$designElement->setType($result["type"]);
			$designElement->setDesign($result["id_design"]);
			$designElement->setDesignElement($result["id_design_element"]);
			$designElement->setSorting($result["sorting"]);
			$elements[] = $designElement;
		}
		
		return $elements;
	}
	
	
	function delete() {
		$elements = $this->getDesignElements();
		if(is_array($elements))
		{
			foreach($this->getDesignElements() as $designElement)
			{
				if(!$designElement->delete())
				{
					$this->last_error = $designElement->last_error;
					return false;
				}
			}
		} else {
			return false;
		}
		
		$sql="DELETE FROM ".DB_PREFIX."design WHERE id_design='".$this->data["id_design"]."' ";
		if($query = $this->db->query($sql)) {
			$dir = DIR_IMAGE.'data/designs/design_'.$this->data["id_design"];
			@unlink ($dir."/snapshot.png");
			@unlink ($dir."/design_image.png");
			@unlink ($dir);
			return true;
		}else
		{
			$this->last_error="Error trying to delete: ";
			return false;
		}		
	}
	
	function saveSnapshot($compressed = false)
	{
		$dir = DIR_IMAGE.'data/designs/design_'.$this->data["id_design"];
		if(!is_dir($dir)){
			if(!mkdir($dir)) {
				trigger_error ("error trying to create dir ".$dir, E_USER_ERROR);
			} else {
				if(!chmod($dir, 0777)) {
					trigger_error ("error trying to change permission dir ".$dir, E_USER_ERROR);
				}
			}
		}
		
		if($data = $this->snapshotStream->data)
		{
			if($compressed)
			{
				if(function_exists(gzuncompress))
				{
					$data = gzuncompress($data);
				} else {
					trigger_error ("gzuncompress method does not exists, please send uncompressed data", E_USER_ERROR);
				}
			}
			if(!file_put_contents($dir."/snapshot.png", $data))
			{
				$this->last_error="file_put_contents error: ".$dir."/snapshot.png";
				return false;
			}
		}else
		{
			$this->last_error="null snapshotStream (ByteArray): ".$this->snapshotStream;
			return false;
		}
		
		if($data = $this->snapshotDesignStream->data)
		{
			if($compressed)
			{
				if(function_exists(gzuncompress))
				{
					$data = gzuncompress($data);
				} else {
					trigger_error ("gzuncompress method does not exists, please send uncompressed data", E_USER_ERROR);
				}
			}
			if(!file_put_contents($dir."/design_image.png", $data))
			{
				$this->last_error="file_put_contents error: ".$dir."/design_image.png";
				return false;
			}
		}else
		{
			$this->last_error="null snapshotDesignStream (ByteArray): ".$this->snapshotDesignStream;
			return false;
		}
		return true;
	}
}
?>