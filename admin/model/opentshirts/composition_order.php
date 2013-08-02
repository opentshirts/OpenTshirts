<?php
class ModelOpentshirtsCompositionOrder extends Model {	

	public function getOrderCompositions($order_id) {
		$sql  = "SELECT * FROM " . DB_PREFIX . "composition_to_order WHERE order_id = '" . $this->db->escape($order_id) . "' ";
		$query = $this->db->query($sql);
		return $query->rows;
	}
}
?>