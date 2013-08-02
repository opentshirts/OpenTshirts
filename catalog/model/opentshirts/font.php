<?php
class ModelOpentshirtsFont extends Model {
	
	public function getFonts($data  = array()) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$fonts = array();
		foreach ($query->rows as $result) {
			$fonts[$result['id_font']] = array(
				'id_font' => $result['id_font'],
				'name' => $result['name'],
				'swf_file' => $result['swf_file'],
				'ttf_file' => $result['ttf_file']		
			);
		}	
		return $fonts;
	}
		
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM ". DB_PREFIX ."font f  "; 
		$condition = " WHERE f.deleted=0 ";
		
		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND f.status='".$data['filter_status']."' ";
		}

		///add category filter
		if(!empty($data['category'])) {
			$tables .= ", ". DB_PREFIX ."font_font_category fxc ";
			$condition .= " AND fxc.id_category='".$data['category']."' AND f.id_font=fxc.id_font ";
		}
		///add keyword filter
		$match = '';
		if (!empty($data['keyword']))
		{
			$array_keywords=explode(" ",$data['keyword']);
			$num_words=count($array_keywords);
			$ids_from_keyword=$this->getIdsFromKeywords($data['keyword']);
			if ($num_words==1)
			{
				$condition .= " AND  ( f.name LIKE '%".$this->db->escape($data['keyword'])."%' ".$ids_from_keyword." ) ";
			}
			else
			{
				$order = 'score';
				$match = " , MATCH ( f.name ) AGAINST ( '".$this->db->escape($data['keyword'])."' ) AS score ";
				$condition .= " AND (  MATCH ( f.name ) AGAINST ( '".$this->db->escape($data['keyword'])."' ) ".$ids_from_keyword." )";
			}		
		}
		
		$sql .= $match.$tables.$condition;
		
		$sort_data = array(
			'f.date_added',
			'f.name',
			'score'
		);
		
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY f.date_added";
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
	
	
	private function getIdsFromKeywords($keyword)
	{
		$array_keywords=explode(" ",$keyword); ///split by words
		$values=array();
		
		foreach($array_keywords as $key) {
			$sql = "SELECT DISTINCT(id_font) FROM ". DB_PREFIX ."font_keyword WHERE keyword LIKE '%".$this->db->escape($key)."%' ";
			$query = $this->db->query($sql);
			foreach ($query->rows as $result) {
				$values[]="'".$result['id_font']."'";	
			}
		}
		
		if ($values)
		{
			return ' OR f.id_font IN ('.implode(',',$values).') ';		
		}	
	}
	
}
?>