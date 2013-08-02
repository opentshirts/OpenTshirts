<?php
class ModelPrintingMethodScreenprinting extends Model {
	
	public function savePrice($data) {
		$sql  = "DELETE FROM " . DB_PREFIX . "screenprinting_quantity  ";
		$this->db->query($sql);
		$sql  = "DELETE FROM " . DB_PREFIX . "screenprinting_quantity_price ";
		$this->db->query($sql);
		
		if(isset($data['quantities']) && isset($data['price']) && isset($data['screen_charges']))
		{
			foreach($data['quantities'] as $quantity_index => $quantity)
			{
				
				$sql  = "INSERT INTO " . DB_PREFIX . "screenprinting_quantity SET ";
				$sql .= " quantity_index = '" . $quantity_index . "',";
				$sql .= " quantity = '" . $quantity . "', ";
				$sql .= " screen_charge = '" . $data['screen_charges'][$quantity_index] . "' ";
				$this->db->query($sql);
				
				foreach($data['price'] as $num_colors => $price)
				{					
					$sql  = "INSERT INTO " . DB_PREFIX . "screenprinting_quantity_price SET ";
					$sql .= " quantity_index = '" . $quantity_index . "', ";
					$sql .= " num_colors = '" . $num_colors . "', ";
					$sql .= " price = '" . $price[$quantity_index] . "' ";
					$this->db->query($sql);
				}
			}
		}

	}
	public function getPrice() {
		$price = array();
		foreach ($this->getQuantities() as $quantity_index => $quantity) {
			$sql = "SELECT * FROM " . DB_PREFIX . "screenprinting_quantity_price pp, " . DB_PREFIX . "screenprinting_quantity q WHERE q.quantity='".$quantity."' AND q.quantity_index=pp.quantity_index  "; 
			$query = $this->db->query($sql);
			foreach ($query->rows as $result) {
				$price[$result['num_colors']][$quantity_index] = $result['price'];
			}
    	}	
		return $price;
	}
	public function getQuantities() {
		$sql = "SELECT quantity FROM " . DB_PREFIX . "screenprinting_quantity ORDER BY quantity ASC "; 
		$query = $this->db->query($sql);
		
		$array = array();
		foreach ($query->rows as $result) {
			$array[] = $result['quantity'];
    	}	
		return $array;
	}	
	public function getScreenCharges() {
		$sql = "SELECT screen_charge FROM " . DB_PREFIX . "screenprinting_quantity ORDER BY quantity ASC "; 
		$query = $this->db->query($sql);
		
		$array = array();
		foreach ($query->rows as $result) {
			$array[] = $result['screen_charge'];
    	}	
		return $array;
	}	
	
	public function getMaxColors()
	{
		$sql = "SELECT MAX(num_colors) as maximum FROM " . DB_PREFIX . "screenprinting_quantity_price  ";
		$query = $this->db->query($sql);
		if($query->row["maximum"]=="")
		{
			return false;
		}else
		{
			return $query->row["maximum"];
		}

	}

	public function install() {

		$this->db->query("
			CREATE TABLE `" . DB_PREFIX . "screenprinting_quantity` (
			  `quantity_index` int(11) NOT NULL,
			  `quantity` int(11) DEFAULT NULL,
			  `screen_charge` float DEFAULT NULL,
			  PRIMARY KEY (`quantity_index`)
			) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
		");

		$this->db->query("
			CREATE TABLE `" . DB_PREFIX . "screenprinting_quantity_price` (
			  `quantity_index` int(11) NOT NULL,
			  `num_colors` int(11) NOT NULL,
			  `price` float DEFAULT NULL,
			  PRIMARY KEY (`quantity_index`,`num_colors`),
			  KEY `fk_screenprinting_quantity_quantity_index` (`quantity_index`)
			) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
		");
	}

	public function uninstall() {

		$this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "screenprinting_quantity`;");
		$this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "screenprinting_quantity_price`;");

	}

}
?>