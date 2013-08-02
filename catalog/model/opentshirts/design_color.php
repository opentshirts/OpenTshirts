<?php
class ModelOpentshirtsDesignColor extends Model {
	
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
			'hexa',
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
		
}
?>