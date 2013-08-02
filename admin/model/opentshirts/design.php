<?php
class ModelOpentshirtsDesign extends Model {

	public function getDesigns($data) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		$designs = array();
		foreach ($query->rows as $result) {			
			$designs[]['id_design'] = $result['id_design'];
		}	
		return $designs;
	}
	
	public function getDesignTotal($data) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		return $query->num_rows;
	}
	public function getTotalDesignsByID($id_design) 
	{
		$query = $this->db->query('SELECT id_design FROM '.DB_PREFIX.'design WHERE id_design="'.$id_design.'" ');
		return $query->num_rows;
	}
	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM ".DB_PREFIX."design d "; 
		$condition = " WHERE 1=1 ";
		
		///add id_composition filter
		if(!empty($data['filter_id_composition'])) {
			$condition .= " AND d.id_composition='".$data['filter_id_composition']."' ";
		}
		
		///add id filter
		if(!empty($data['filter_id_design'])) {
			$condition .= " AND d.id_design='".$data['filter_id_design']."' ";
		}
		
		$sql .= $tables.$condition;
		
		return $sql;
		
		/*$sort_data = array(
			'RAND()',
			'd.id_design',
			'd.id_composition'
		);
		
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY d.id_design";
		}
		
		if (isset($data['order']) && ($data['order'] == 'DESC')) {
			$sql .= " DESC";
		} else {
			$sql .= " ASC";
		}

		if (isset($data['start']) || isset($data['limit'])) {
			if ($data['start'] < 0) {
				$data['start'] = 0;
			}

			if ($data['limit'] < 1) {
				$data['limit'] = 20;
			}

			$sql .= " LIMIT " . (int)$data['start'] . "," . (int)$data['limit'];
		}		
		
		return $sql;*/
	}
	
	public function remove($id_design)
	{		
		$this->db->query("DELETE FROM " . DB_PREFIX . "design WHERE id_design = '" . $id_design . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "design_element WHERE id_design = '" . $id_design . "' ");
		
		$dir = __DIR_RESOURCES__.'designs/design_'.$id_design;
		@unlink ($dir."/snapshot.png");
		@unlink ($dir."/design_image.png");
		@unlink ($dir);

	}

}
?>