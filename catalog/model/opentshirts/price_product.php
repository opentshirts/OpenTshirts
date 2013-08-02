<?php
class ModelOpentshirtsPriceProduct extends Model {
	
	public function getMinQuantity($product_id) 
	{
		$sql="SELECT quantity FROM ".DB_PREFIX."printable_product_quantity WHERE product_id='".$product_id."' ORDER BY quantity ASC LIMIT 1 "; 
		$query = $this->db->query($sql);
		if($query->num_rows==0) {
			return false;
		} else {
			return $query->row["quantity"];
		}
	}
	/**
	* return an array where key=id_product_color_group, value=price
	*/
	public function getColorGroupsPriceFromQuantity($product_id, $quantity)
	{
		$sql=" SELECT quantity_index FROM ".DB_PREFIX."printable_product_quantity  "; 
		$sql.=" WHERE product_id='".$product_id."' AND quantity<=".(int)$quantity." ";
		$sql.=" ORDER BY quantity DESC  "; 
		$sql.=" LIMIT 1 "; 
		$query = $this->db->query($sql);
		
		if($query->num_rows==0) {
			return false;
		} else {
			$quantity_index = $query->row["quantity_index"]; //column to take prices from
			
			$sql=" SELECT price, id_product_color_group FROM  ".DB_PREFIX."printable_product_quantity_price "; 
			$sql.=" WHERE product_id='".$product_id."' AND quantity_index='".$quantity_index."' ";
			$query = $this->db->query($sql);
			
			if($query->num_rows==0) {
				return false;
			} else {
				$prices = array();
				foreach ($query->rows as $result) {
					$prices[$result['id_product_color_group']] = $result["price"];
				}	
				return $prices;
			}
		}
	}
		
	public function getSizesUpcharge($product_id) 
	{
		$sql="SELECT id_product_size, upcharge FROM ".DB_PREFIX."printable_product_size_upcharge WHERE product_id='".$product_id."' "; 
		$query = $this->db->query($sql);
		$upcharge = array();
		foreach ($query->rows as $result) {
			$upcharge[$result["id_product_size"]] = $result["upcharge"];
    	}	
		return $upcharge;		
	}

	public function getPrice($product_id) 
	{
		$price = array();
		
		foreach ($this->getQuantities($product_id) as $index => $quantity) {
			$sql = "SELECT * FROM " . DB_PREFIX . "printable_product_quantity_price pp WHERE product_id='".$product_id."' AND quantity_index ='".$index."'  "; //q.quantity='".$quantity."' AND q.quantity_index=pp.quantity_index  "; 
			$query = $this->db->query($sql);
			foreach ($query->rows as $result) {
				$price[$result['id_product_color_group']][$index] = $result['price'];
			}
    	}	
		return $price;
	}
	public function getQuantities($product_id) 
	{
		$sql = "SELECT * FROM " . DB_PREFIX . "printable_product_quantity WHERE product_id='".$product_id."' ORDER BY quantity ASC "; 
		$query = $this->db->query($sql);
		
		$array = array();
		foreach ($query->rows as $result) {
			$array[$result['quantity_index']] = $result['quantity'];
    	}	
		return $array;
	}
	
}
?>