<?php
class ModelProductView extends Model {

	public function getViews($data) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$views = array();
    		foreach ($query->rows as $result) {
			$views[] = array(
        			'product_id'	=> $result['product_id'],
        			'view_index'	=> $result['view_index'],
        			'name'			=> $result['name'],
        			'regions_scale'	=> $result['regions_scale'],
        			'shade'			=> $result['shade'],
        			'underfill'			=> $result['underfill']
        		);
    		}	
		return $views;
	}
	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM " . DB_PREFIX . "printable_product_view "; 
		$condition = " WHERE 1=1 ";
		
		if(isset($data['product_id'])) {
			$condition .= " AND product_id='".$data['product_id']."' ";
		}
		
		if(isset($data['view_index'])) {
			$condition .= " AND view_index='".$data['view_index']."' ";
		}
		
		if(!empty($data['order'])) {
			if($data['order'] === 'ID') {
				$data['order'] = ' view_index ';
			}
		} else {
			$data['order'] = ' view_index ';
		}
		
		if(empty($data['asc_desc'])) {
			$data['asc_desc'] = ' ASC ';
		}
		
		$sql .= $tables.$condition." ORDER BY ".$this->db->escape($data['order'])." ".$this->db->escape($data['asc_desc']);
				
		return $sql;
	}
	

}
?>