<?php
class ModelOpentshirtsLayer extends Model {

	public function getLayers($data) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$layers = array();
		foreach ($query->rows as $result) {
			$layers[] = array(
				'id_clipart'	=> $result['id_clipart'],
				'sorting'	=> $result['sorting'],
				'name'			=> $result['name'],
				'id_design_color'	=> $result['id_design_color']
			);
		}	
		return $layers;
	}
	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM ".DB_PREFIX."clipart_layers "; 
		$condition = " WHERE 1=1 ";
		
		if(!empty($data['id_clipart'])) {
			$condition .= " AND id_clipart='".$data['id_clipart']."' ";
		}
		
		$sql .= $tables.$condition;
		
		$sort_data = array(
			'sorting',
			'name'
		);

		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY sorting";
		}
		
		if (isset($data['order']) && ($data['order'] == 'DESC')) {
			$sql .= " DESC";
		} else {
			$sql .= " ASC";
		}
				
		return $sql;
	}
}
?>