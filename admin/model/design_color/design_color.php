<?php
class ModelDesignColorDesignColor extends Model {
	
	public function addColor($data) {

		$query = $this->db->query('SELECT UUID()');
		$id_design_color = $query->row['UUID()'];
		
		$sql  = "INSERT INTO " . DB_PREFIX . "design_color SET ";
		$sql .= " id_design_color = '" . $id_design_color . "',";
		$sql .= " name = '" . $this->db->escape($data['name']) . "',";
		$sql .= " hexa = '" . $this->db->escape($data['hexa']) . "',";
		$sql .= " code = '" . $this->db->escape($data['code']) . "',";
		$sql .= " need_white_base = '" . $this->db->escape($data['need_white_base']) . "',";
		$sql .= " available = '" . $this->db->escape($data['status']) . "' ";

		$this->db->query($sql);
		
		return $id_design_color;
		
	}
	public function editColor($id_design_color, $data) {
		$sql  = "UPDATE " . DB_PREFIX . "design_color SET ";
		$sql .= " name = '" . $this->db->escape($data['name']) . "',";
		$sql .= " hexa = '" . $this->db->escape($data['hexa']) . "',";
		$sql .= " code = '" . $this->db->escape($data['code']) . "',";
		$sql .= " need_white_base = '" . $this->db->escape($data['need_white_base']) . "',";
		$sql .= " available = '" . $this->db->escape($data['status']) . "' ";
		$sql .= " WHERE id_design_color = '" . $id_design_color . "' ";
		$this->db->query($sql);
				
		return $id_design_color;
		
	}
	public function deleteColor($id_design_color)
	{
		$result = $this->getColor($id_design_color);
		if($result['isdefault']) {
			return false;
		}
		$query = $this->db->query("UPDATE " . DB_PREFIX . "design_color SET deleted = '1' WHERE id_design_color='".$id_design_color."' LIMIT 1 ");
	}
	
	public function remove($id_design_color)
	{
		
		$this->db->query("DELETE FROM " . DB_PREFIX . "design_color WHERE id_design_color = '" . $id_design_color . "' ");

	}	
	public function getColor($id_design_color) {
		
		$sql = "SELECT * FROM " . DB_PREFIX . "design_color WHERE id_design_color='". $id_design_color ."'  ";
		$query = $this->db->query($sql);
		
		$color = array(
			'id_design_color'	=> $query->row['id_design_color'],
			'name'		=> $query->row['name'],
			'code'		=> $query->row['code'],
			'hexa'		=> $query->row['hexa'],
			'alpha'		=> $query->row['alpha'],
			'status'		=> $query->row['available'],
			'isdefault'		=> $query->row['isdefault'],
			'sort'		=> $query->row['sort'],
			'need_white_base'		=> $query->row['need_white_base']
		);
				
		return $color;	
	}
	
	public function getColors($data  = array()) {
		
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$color_data = array();
		
		foreach ($query->rows as $result) {
			$id_design_color = $result["id_design_color"];
			$color_data[$id_design_color]["id_design_color"] = $id_design_color;
			$color_data[$id_design_color]["name"] = $result["name"];
			$color_data[$id_design_color]["code"] = $result["code"];
			$color_data[$id_design_color]["hexa"] = $result["hexa"];
			$color_data[$id_design_color]["alpha"] = $result["alpha"];
			$color_data[$id_design_color]["status"] = $result["available"];
			$color_data[$id_design_color]["sort"] = $result["sort"];
			$color_data[$id_design_color]["isdefault"] = $result["isdefault"];
			$color_data[$id_design_color]["need_white_base"] = $result["need_white_base"];
		}
		
		return $color_data;	
	}
	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM " . DB_PREFIX . "design_color "; 
		$condition = " WHERE deleted=0  ";

		///add id filter
		if(isset($data['filter_id_design_color'])) {
			$condition .= " AND id_design_color='".$this->db->escape($data['filter_id_design_color'])."' ";
		}

		///add code filter
		if(isset($data['filter_code'])) {
			$condition .= " AND code='".$this->db->escape($data['filter_code'])."' ";
		}
		
		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND available='".$this->db->escape($data['filter_status'])."' ";
		}

		
		$sql .= $tables.$condition;
		
		$sort_data = array(
			'name',
			'code',
			'id_design_color',
			'sort',
			'need_white_base'
		);
		
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY sort";
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
	
	public function getTotalColors($data) 
	{
		$sql = "SELECT COUNT(*) AS total ";
		$tables = "FROM " . DB_PREFIX . "design_color "; 
		$condition = " WHERE deleted=0  ";

		///add id filter
		if(isset($data['filter_id_design_color'])) {
			$condition .= " AND id_design_color='".$this->db->escape($data['filter_id_design_color'])."' ";
		}

		///add code filter
		if(isset($data['filter_code'])) {
			$condition .= " AND code='".$this->db->escape($data['filter_code'])."' ";
		}
		
		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND available='".$this->db->escape($data['filter_status'])."' ";
		}
		
		$sql .= $tables.$condition;
		
		$query = $this->db->query($sql);
		return $query->row['total'];
	}
	
	public function isDefault($id_design_color) {
		
		$sql = "SELECT * FROM " . DB_PREFIX . "design_color WHERE id_design_color='". $id_design_color ."'  ";
		$query = $this->db->query($sql);
				
		return $query->row['isdefault'];	
	}

	public function saveOrder($design_colors) {
		foreach ($design_colors as $sort => $id_design_color) {
			$query = $this->db->query("UPDATE " . DB_PREFIX . "design_color SET sort = '".$sort."' WHERE id_design_color='".$id_design_color."' LIMIT 1 ");
		}
	}
}
?>