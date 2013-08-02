<?php
class ModelOpentshirtsCompositionOrder extends Model {	

	public function addCompositionToOrder($order_id, $id_composition) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "composition_to_order WHERE  id_composition = '" . $this->db->escape($id_composition) . "' AND order_id = '" . $this->db->escape($order_id) . "' ");
		if(!$query->num_rows) {
			$sql  = "INSERT INTO " . DB_PREFIX . "composition_to_order SET id_composition = '" . $this->db->escape($id_composition) . "', order_id = '" . $this->db->escape($order_id) . "' ";
			$this->db->query($sql);
		}
	}

	public function getOrderCompositions($order_id) {
		$sql  = "SELECT * FROM " . DB_PREFIX . "composition_to_order WHERE order_id = '" . $this->db->escape($order_id) . "' ";
		$query = $this->db->query($sql);
		return $query->rows;
	}
}
?>