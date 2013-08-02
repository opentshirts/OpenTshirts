<?php
class ModelOpentshirtsDesignElement extends Model {

	public function getDesignElements($data) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$assets = array();
		foreach ($query->rows as $result) {	
			$assets[] = array(
				'id_design'			=> $result['id_design'],
				'sorting'			=> $result['sorting'],
				'id_design_element'	=> $result['id_design_element'],
				'type'				=> $result['type'],
				'source'			=>  $this->getSource($result['id_design_element'], $result['type'])
			);
		}	
		return $assets;
	}
	private function getSource($id_design_element, $type)
	{
		switch($type)
		{
			case '1':
				$this->load->model('clipart/clipart');
				$source = $this->model_clipart_clipart->getSource($id_design_element);
				break;
			case '2':
				$this->load->model('font/font');
				$source = $this->model_font_font->getSource($id_design_element);
				break;
			case '3':
				$this->load->model('bitmap/bitmap');
				$source = $this->model_bitmap_bitmap->getSource($id_design_element);
				break;
		}
		return $source;
	}
	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM ".DB_PREFIX."design_element "; 
		$condition = " WHERE 1=1 ";
		
		///add id_design filter
		if(!empty($data['filter_id_design'])) {
			$condition .= " AND id_design='".$data['filter_id_design']."' ";
		}
		
		$sql .= $tables.$condition;
		
		$sort_data = array(
			'id_design, sorting',
			'sorting',
			'type'
		);
		
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY id_design, sorting";
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
		
		return $sql;
	}

}
?>