<?php
class ModelOpentshirtsClipart extends Model {

	public function getClipart($id_clipart)
	{
		$query = $this->db->query('SELECT * FROM '.DB_PREFIX.'clipart WHERE id_clipart="'.$id_clipart.'" ');
		if($query->num_rows>0) {
			$clipart = array(
				'id_clipart'	=> $query->row['id_clipart'],
				'name'			=> $query->row['name'],
				'status'		=> $query->row['status'],
				'swf_file'		=> $query->row['swf_file'],
				'vector_file'		=> $query->row['vector_file'],
				'vector_file_2'		=> $query->row['vector_file_2'],
				'image_file'		=> $query->row['image_file'],
				'date_added'	=> $query->row['date_added']
			);
		} else {
			$clipart = false;
		}
		return $clipart;
	}

	public function getCliparts($data) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$cliparts = array();
		foreach ($query->rows as $result) {
			$cliparts[$result['id_clipart']] = array(
				'id_clipart'	=> $result['id_clipart'],
				'name'		=> $result['name'],
				'image_file'		=> $result['image_file']
			);
		}	
		return $cliparts;
	}

	
	public function getTotalcliparts($data) 
	{
		$sql = "SELECT COUNT(*) AS total ";
		$tables = "FROM ".DB_PREFIX."clipart c  "; 
		$condition = " WHERE c.deleted=0 ";
		
		///add category filter
		if(!empty($data['filter_category'])) {
			$tables .= ", ".DB_PREFIX."clipart_clipart_category cxc ";
			$condition .= " AND cxc.id_category='".$data['filter_category']."' AND c.id_clipart=cxc.id_clipart ";
		}
		
		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND c.status='".$data['filter_status']."' ";
		}
		
		///add keyword filter
		$match = '';
		if (!empty($data['filter_keyword']))
		{
			$array_keywords=explode(" ",$data['filter_keyword']);
			$num_words=count($array_keywords);
			$ids_from_keyword=$this->getIdsFromKeywords($data['filter_keyword']);
			if ($num_words==1)
			{
				$condition .= " AND  ( LCASE(c.name) LIKE '%".$this->db->escape(utf8_strtolower($data['filter_keyword']))."%' ".$ids_from_keyword." ) ";
			}
			else
			{
				$order = 'score';
				$match = " , MATCH ( c.name ) AGAINST ( '".$this->db->escape(utf8_strtolower($data['filter_keyword']))."' ) AS score ";
				$condition .= " AND (  MATCH ( c.name ) AGAINST ( '".$this->db->escape(utf8_strtolower($data['filter_keyword']))."' ) ".$ids_from_keyword." )";
			}		
		}
		
		$sql .= $match.$tables.$condition;
		
		$query = $this->db->query($sql);
		return $query->row['total'];
	}

	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM ".DB_PREFIX."clipart c  "; 
		$condition = " WHERE c.deleted=0 ";
		
		///add category filter
		if(!empty($data['filter_category'])) {
			$tables .= ", ".DB_PREFIX."clipart_clipart_category cxc ";
			$condition .= " AND cxc.id_category='".$data['filter_category']."' AND c.id_clipart=cxc.id_clipart ";
		}
		
		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND c.status='".$data['filter_status']."' ";
		}
		
		///add keyword filter
		$match = '';
		if (!empty($data['filter_keyword']))
		{
			$array_keywords=explode(" ",$data['filter_keyword']);
			$num_words=count($array_keywords);
			$ids_from_keyword=$this->getIdsFromKeywords($data['filter_keyword']);
			if ($num_words==1)
			{
				$condition .= " AND  ( LCASE(c.name) LIKE '%".$this->db->escape(utf8_strtolower($data['filter_keyword']))."%' ".$ids_from_keyword." ) ";
			}
			else
			{
				$order = 'score';
				$match = " , MATCH ( c.name ) AGAINST ( '".$this->db->escape(utf8_strtolower($data['filter_keyword']))."' ) AS score ";
				$condition .= " AND (  MATCH ( c.name ) AGAINST ( '".$this->db->escape(utf8_strtolower($data['filter_keyword']))."' ) ".$ids_from_keyword." )";
			}		
		}
		
		$sql .= $match.$tables.$condition;
		
		$sort_data = array(
			'c.date_added',
			'c.name',
			'c.status',
			'c.id_clipart',
			'RAND()',
			'score'
		);
		
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY RAND()";
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
			$sql = "SELECT DISTINCT(id_clipart) FROM ".DB_PREFIX."clipart_keyword WHERE LCASE(keyword) LIKE '%".$this->db->escape(utf8_strtolower($key))."%' ";
			$query = $this->db->query($sql);
			foreach ($query->rows as $result) {
				$values[]="'".$result['id_clipart']."'";	
			}
		}
		
		if ($values)
		{
			return ' OR c.id_clipart IN ('.implode(',',$values).') ';		
		}	
	}
}
?>