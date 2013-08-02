<?php
class ModelPrintingMethodDtg extends Model {

	public function savePrice($data) {
		$sql  = "DELETE FROM " . DB_PREFIX . "dtg_printing_quantity  ";
		$this->db->query($sql);
		$sql  = "DELETE FROM " . DB_PREFIX . "dtg_printing_quantity_price ";
		$this->db->query($sql);
		
		if(isset($data['quantities']) && isset($data['price']))
		{
			foreach($data['quantities'] as $quantity_index => $quantity)
			{
				
				$sql  = "INSERT INTO " . DB_PREFIX . "dtg_printing_quantity SET ";
				$sql .= " quantity_index = '" . $quantity_index . "',";
				$sql .= " quantity = '" . $quantity . "' ";
				$this->db->query($sql);
				
				foreach($data['price'] as $area => $price)
				{					
					$sql  = "INSERT INTO " . DB_PREFIX . "dtg_printing_quantity_price SET ";
					$sql .= " quantity_index = '" . $quantity_index . "', ";
					$sql .= " area = '" . $area . "', ";
					$sql .= " price = '" . $price[$quantity_index] . "', ";
					$sql .= " price_whitebase_1 = '" . $data['price_1'][$area][$quantity_index] . "', ";
					$sql .= " price_whitebase_2 = '" . $data['price_2'][$area][$quantity_index] . "' ";
					$this->db->query($sql);
				}
			}
		}
	}

	public function getPrice($field = false) {
		$price = array();
		foreach ($this->getQuantities() as $quantity_index => $quantity) {
			$sql = "SELECT * FROM " . DB_PREFIX . "dtg_printing_quantity_price pp, " . DB_PREFIX . "dtg_printing_quantity q WHERE q.quantity='".$quantity."' AND q.quantity_index=pp.quantity_index  "; 
			$query = $this->db->query($sql);
			foreach ($query->rows as $result) {
				if(!$field) {
					$price[$result['area']][$quantity_index] = $result['price'];
				} else if($field==1) {
					$price[$result['area']][$quantity_index] = $result['price_whitebase_1'];
				} else {
					$price[$result['area']][$quantity_index] = $result['price_whitebase_2'];
				}
			}
    	}	
		return $price;
	}
	
	public function getQuantities() {
		$sql = "SELECT quantity FROM " . DB_PREFIX . "dtg_printing_quantity ORDER BY quantity ASC "; 
		$query = $this->db->query($sql);
		
		$array = array();
		foreach ($query->rows as $result) {
			$array[] = $result['quantity'];
    	}	
		return $array;
	}

	public function install() {

		$this->db->query("
			CREATE TABLE `" . DB_PREFIX . "dtg_printing_quantity` (
			  `quantity_index` int(11) NOT NULL,
			  `quantity` int(11) DEFAULT NULL,
			  PRIMARY KEY (`quantity_index`)
			) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
		");

		$this->db->query("
			CREATE TABLE `" . DB_PREFIX . "dtg_printing_quantity_price` (
			  `quantity_index` int(11) NOT NULL,
			  `area` float NOT NULL,
			  `price` float DEFAULT NULL,
			  `price_whitebase_1` float DEFAULT NULL,
			  `price_whitebase_2` float DEFAULT NULL,
			  PRIMARY KEY (`quantity_index`,`area`),
			  KEY `fk_dtg_printing_quantity_quantity_index` (`quantity_index`)
			) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
		");
	}

	public function uninstall() {

		$this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "dtg_printing_quantity`;");
		$this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "dtg_printing_quantity_price`;");

	}

}
?>