<?php
class ModelProductRegion extends Model {

	public function getRegions($data) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$regions = array();
    		foreach ($query->rows as $result) {
				$regions[] = array(
        			'product_id'	=> $result['product_id'],
        			'view_index'	=> $result['view_index'],
        			'region_index'	=> $result['region_index'],
        			'name'		=> $result['name'],
        			'x'		=> $result['x'],
        			'y'		=> $result['y'],
        			'width'		=> $result['width'],
        			'height'	=> $result['height'],
        			'mask'	=> $result['mask']
        		);
    		}	
		return $regions;
	}

	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM " . DB_PREFIX . "printable_product_view_region "; 
		$condition = " WHERE 1=1 ";
		

		if(isset($data['product_id'])) {
			$condition .= " AND product_id='".$data['product_id']."' ";
		}

		if(isset($data['view_index'])) {
			$condition .= " AND view_index='".$data['view_index']."' ";
		}

		if(isset($data['region_index'])) {
			$condition .= " AND region_index='".$data['region_index']."' ";
		}
		
		if(!empty($data['order'])) {
			if($data['order'] === 'ID') {
				$data['order'] = ' region_index ';
			}
		} else {
			$data['order'] = ' region_index ';
		}
		
		if(empty($data['asc_desc'])) {
			$data['asc_desc'] = ' ASC ';
		}
		
		$sql .= $tables.$condition." ORDER BY ".$this->db->escape($data['order'])." ".$this->db->escape($data['asc_desc']);
		
		return $sql;
	}
	

}
?>