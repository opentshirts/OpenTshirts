<?php
class ModelOpentshirtsProductSize extends Model {
	
	public function getSizes() {
		$size_data = array();
		
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "printable_product_size WHERE deleted=0 ORDER BY sort, description ASC");
	
		foreach ($query->rows as $result) {
			$size_data[$result['id_product_size']] = array(
				'id_product_size' => $result['id_product_size'],
				'description'        => $result['description'],
				'initials'        => $result['initials'],
				'apply_additional_cost'        => $result['apply_additional_cost'],
				'sort'        => $result['sort'],
				'option_value_id' => $result["option_value_id"]
			);
		}	
		
		return $size_data;	
	}
}
?>