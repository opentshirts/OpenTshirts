<?php
class ModelProductFill extends Model {

	public function getFills($data) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$fills = array();
		foreach ($query->rows as $result) {
			$fills[] = array(
				'product_id'	=> $result['product_id'],
				'view_index'	=> $result['view_index'],
				'view_fill_index'		=> $result['view_fill_index'],
				'file'	=> $result['file']
			);
		}	
		return $fills;
	}

	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM " . DB_PREFIX . "printable_product_view_fill "; 
		$condition = " WHERE 1=1 ";
		

		if(!empty($data['product_id'])) {
			$condition .= " AND product_id='".$data['product_id']."' ";
		}

		if(isset($data['view_index'])) {
			$condition .= " AND view_index='".$data['view_index']."' ";
		}

		if(isset($data['view_fill_index'])) {
			$condition .= " AND view_fill_index='".$data['view_fill_index']."' ";
		}
		
		if(!empty($data['order'])) {
			if($data['order'] === 'ID') {
				$data['order'] = ' view_fill_index ';
			}
		} else {
			$data['order'] = ' view_fill_index ';
		}
		
		if(empty($data['asc_desc'])) {
			$data['asc_desc'] = ' ASC ';
		}
		
		$sql .= $tables.$condition." ORDER BY ".$this->db->escape($data['order'])." ".$this->db->escape($data['asc_desc']);
		
		return $sql;
	}
	

}
?>