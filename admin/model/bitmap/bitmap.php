<?php
class ModelBitmapBitmap extends Model {
	
	public function addBitmap($data) {

		$query = $this->db->query('SELECT UUID()');
		$id_bitmap = $query->row['UUID()'];
		
		$sql  = "INSERT INTO " . DB_PREFIX . "bitmap SET ";
		$sql .= " id_bitmap = '" . $id_bitmap . "',";
		$sql .= " status = '" . $this->db->escape($data['status']) . "',";
		$sql .= " name = '" . $this->db->escape($data['name']) . "',";
		$sql .= " image_file = '" . $this->db->escape($data['image_file']) . "', ";
		$sql .= " colors = '" . $this->db->escape(serialize($data['colors'])) . "' ";

		$this->db->query($sql);
		
		if(!empty($data['keywords']))
		{
			$keywords = explode(",", $data['keywords']);
			foreach($keywords as $keyword)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "bitmap_keyword SET ";
				$sql .= " id_bitmap = '" . $id_bitmap . "',";
				$sql .= " keyword = '" . $this->db->escape($keyword) . "' ";
				$this->db->query($sql);
			}	
		}
		
		if(isset($data['selected_categories']))
		{
			foreach($data['selected_categories'] as $id_category)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "bitmap_bitmap_category SET ";
				$sql .= " id_bitmap = '" . $id_bitmap . "',";
				$sql .= " id_category = '" . $id_category . "' ";
				$this->db->query($sql);
			}	
		}
		
		return $id_bitmap;
		
	}
	public function editBitmap($id_bitmap, $data) {
		$sql  = "UPDATE " . DB_PREFIX . "bitmap SET ";
		$sql .= " status = '" . $this->db->escape($data['status']) . "',";
		$sql .= " name = '" . $this->db->escape($data['name']) . "',";
		$sql .= " image_file = '" . $this->db->escape($data['image_file']) . "', ";
		$sql .= " colors = '" . $this->db->escape(serialize($data['colors'])) . "' ";
		$sql .= " WHERE id_bitmap = '" . $id_bitmap . "' ";
		$this->db->query($sql);
		
		$sql  = "DELETE FROM " . DB_PREFIX . "bitmap_keyword WHERE id_bitmap = '" . $id_bitmap . "' ";
		$this->db->query($sql);
		
		if(!empty($data['keywords']))
		{
			$keywords = explode(",", $data['keywords']);
			foreach($keywords as $keyword)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "bitmap_keyword SET ";
				$sql .= " id_bitmap = '" . $id_bitmap . "',";
				$sql .= " keyword = '" . $this->db->escape($keyword) . "' ";
				$this->db->query($sql);
			}	
		}
		
		$sql  = "DELETE FROM " . DB_PREFIX . "bitmap_bitmap_category WHERE id_bitmap = '" . $id_bitmap . "' ";
		$this->db->query($sql);
		
		if(isset($data['selected_categories']))
		{
			foreach($data['selected_categories'] as $id_category)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "bitmap_bitmap_category SET ";
				$sql .= " id_bitmap = '" . $id_bitmap . "',";
				$sql .= " id_category = '" . $id_category . "' ";
				$this->db->query($sql);
			}	
		}
		
		return $id_bitmap;
		
	}

	public function deleteBitmap($id_bitmap)
	{
		$query = $this->db->query("UPDATE " . DB_PREFIX . "bitmap SET deleted = '1' WHERE id_bitmap='".$id_bitmap."' LIMIT 1 ");
	}
	
	public function remove($id_bitmap)
	{
		$result = $this->getBitmap($id_bitmap);
		
		$query = $this->db->query("DELETE FROM " . DB_PREFIX . "bitmap WHERE id_bitmap='".$id_bitmap."' ");
		$query = $this->db->query("DELETE FROM " . DB_PREFIX . "bitmap_bitmap_category WHERE id_bitmap='".$id_bitmap."' ");
		$query = $this->db->query("DELETE FROM " . DB_PREFIX . "bitmap_keyword WHERE id_bitmap='".$id_bitmap."' ");
		
		$bitmap_dir = DIR_IMAGE . 'data/bitmaps';
		if($result['image_file']) {
			@unlink( $bitmap_dir.'/'.$result['image_file']);
		}

	}
	
	public function getBitmap($id_bitmap)
	{
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "bitmap WHERE id_bitmap='".$id_bitmap."' ");
		$result = $query->row;
		
		$bitmap = array(
				'id_bitmap' => $result['id_bitmap'],
				'name' => $result['name'],
				'image_file' => $result['image_file'],
				'colors' => (unserialize($result['colors']))?unserialize($result['colors']):array(),
				'status'		=> $result['status'],
				'date_added'		=> $result['date_added']
			);
		return $bitmap;
	}
	
	public function getSource($id_bitmap)
	{
		$source = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "bitmap WHERE id_bitmap='".$id_bitmap."' ");
		if($query->row) {
			$source[] = array(
						'link' => HTTP_CATALOG . 'image/data/bitmaps/'.$query->row['image_file'], 
						'description' => $query->row['image_file']
					);
		} else {
			$source[] = array(
						'link' => '#', 
						'description' => 'bitmap deleted'
					);
		}
		
		return $source;
	}
	
	public function getBitmaps($data  = array()) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$bitmaps = array();
    		foreach ($query->rows as $result) {
			$bitmaps[$result['id_bitmap']] = array(
        			'id_bitmap' => $result['id_bitmap'],
        			'name' => $result['name'],
					'image_file' => $result['image_file'],
					'status'		=> $result['status'],
					'date_added'		=> $result['date_added']
      			);
    		}	
		return $bitmaps;
	}
	
	public function getTotalBitmaps($data) 
	{
		$sql = "SELECT COUNT(*) AS total ";
		$tables = "FROM " . DB_PREFIX . "bitmap b  "; 
		$condition = " WHERE b.deleted=0 ";
		
		///add category filter
		if(isset($data['filter_id_category'])) {
			$tables .= ", " . DB_PREFIX . "bitmap_bitmap_category bxc ";
			$condition .= " AND bxc.id_category='".$this->db->escape($data['filter_id_category'])."' AND b.id_bitmap=bxc.id_bitmap ";
		}

		///add id filter
		if(isset($data['filter_id_bitmap'])) {
			$condition .= " AND b.id_bitmap='".$this->db->escape($data['filter_id_bitmap'])."' ";
		}

		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND b.status='".$this->db->escape($data['filter_status'])."' ";
		}

		///add from_customer filter
		if(isset($data['filter_from_customer'])) {
			$condition .= " AND b.from_customer='".$this->db->escape($data['filter_from_customer'])."' ";
		}

		///add keyword filter
		$match = '';
		if (isset($data['filter_keyword']))
		{
			$array_keywords=explode(" ",$data['filter_keyword']);
			$num_words=count($array_keywords);
			$ids_from_keyword=$this->getIdsFromKeywords($data['filter_keyword']);
			if ($num_words==1)
			{
				$condition .= " AND  ( b.name LIKE '%".$this->db->escape($data['filter_keyword'])."%' ".$ids_from_keyword." ) ";
			}
			else
			{
				$order = 'score';
				$match = " , MATCH ( b.name ) AGAINST ( '".$this->db->escape($data['filter_keyword'])."' ) AS score ";
				$condition .= " AND (  MATCH ( b.name ) AGAINST ( '".$this->db->escape($data['filter_keyword'])."' ) ".$ids_from_keyword." )";
			}		
		}
		
		$sql .= $match.$tables.$condition;
		$query = $this->db->query($sql);
		return $query->row['total'];
	}
	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM " . DB_PREFIX . "bitmap b  "; 
		$condition = " WHERE b.deleted=0 ";
		
		///add category filter
		if(isset($data['filter_id_category'])) {
			$tables .= ", " . DB_PREFIX . "bitmap_bitmap_category bxc ";
			$condition .= " AND bxc.id_category='".$this->db->escape($data['filter_id_category'])."' AND b.id_bitmap=bxc.id_bitmap ";
		}

		///add id filter
		if(isset($data['filter_id_bitmap'])) {
			$condition .= " AND b.id_bitmap='".$this->db->escape($data['filter_id_bitmap'])."' ";
		}

		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND b.status='".$this->db->escape($data['filter_status'])."' ";
		}

		///add from_customer filter
		if(isset($data['filter_from_customer'])) {
			$condition .= " AND b.from_customer='".$this->db->escape($data['filter_from_customer'])."' ";
		}

		///add keyword filter
		$match = '';
		if (isset($data['filter_keyword']))
		{
			$array_keywords=explode(" ",$data['filter_keyword']);
			$num_words=count($array_keywords);
			$ids_from_keyword=$this->getIdsFromKeywords($data['filter_keyword']);
			if ($num_words==1)
			{
				$condition .= " AND  ( b.name LIKE '%".$this->db->escape($data['filter_keyword'])."%' ".$ids_from_keyword." ) ";
			}
			else
			{
				$order = 'score';
				$match = " , MATCH ( b.name ) AGAINST ( '".$this->db->escape($data['filter_keyword'])."' ) AS score ";
				$condition .= " AND (  MATCH ( b.name ) AGAINST ( '".$this->db->escape($data['filter_keyword'])."' ) ".$ids_from_keyword." )";
			}		
		}
		
		$sql .= $match.$tables.$condition;
		
		$sort_data = array(
			'RAND()',
			'b.date_added',
			'b.name',
			'b.status',
			'b.id_bitmap',
			'score'
		);
		
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY b.date_added";
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
			$sql = "SELECT DISTINCT(id_bitmap) FROM " . DB_PREFIX . "bitmap_keyword WHERE keyword LIKE '%".$this->db->escape($key)."%' ";
			$query = $this->db->query($sql);
			foreach ($query->rows as $result) {
				$values[]="'".$result['id_bitmap']."'";	
			}
		}
		
		if ($values)
		{
			return ' OR b.id_bitmap IN ('.implode(',',$values).') ';		
		}	
	}

	public function getBitmapCategories($id_bitmap) 
	{
		$query = $this->db->query("SELECT id_category FROM " . DB_PREFIX . "bitmap_bitmap_category WHERE id_bitmap = '".$id_bitmap."' ");
		
		$cats = array();
    	foreach ($query->rows as $result) {
			$cats[] = $result['id_category'];
    	}	
		return $cats;
	}

	public function getBitmapKeywords($id_bitmap) 
	{
		$query = $this->db->query("SELECT keyword FROM " . DB_PREFIX . "bitmap_keyword WHERE id_bitmap = '".$id_bitmap."' ");
		
		$keywords = array();
    	foreach ($query->rows as $result) {
			$keywords[] = $result['keyword'];
    	}	
		return $keywords;
	}
	


}
?>