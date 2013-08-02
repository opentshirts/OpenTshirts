<?php
class ModelOpentshirtsCompositionCategory extends Model {	
	public function getCategoriesByParentId($parent=false) {
		if($parent) {
			$where = "WHERE parent_category='".$parent."' ";
		} else {
			$where = "WHERE parent_category IS NULL";
		}
		
		$sql = "SELECT id_category, description FROM ".DB_PREFIX."composition_category ".$where." ORDER BY description ASC";
		$query = $this->db->query($sql);
		
		$categories = array();
    		foreach ($query->rows as $result) {
			
			$categories[$result['id_category']] = array(
        			'id_category'	=> $result['id_category'],
        			'description'	=> "   ".$result['description'],
					'children'	=> $this->getCategoriesByParentId($result['id_category']),
        		);
    		}
		return $categories;
	}
	
	public function getCategory($id_category) {
		$sql = "SELECT * FROM ".DB_PREFIX."composition_category WHERE id_category='".$id_category."' ";
		$query = $this->db->query($sql);
		return $query->row;
	}
}
?>