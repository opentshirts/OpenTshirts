<?php
class ModelOpentshirtsBitmapCategory extends Model {
	
	public function getCategoriesByParentId($parent=false) {
		if($parent) {
			$where = "WHERE parent_category='".$parent."' ";
		} else {
			$where = "WHERE parent_category IS NULL";
		}
		
		$sql = "SELECT id_category, description FROM ".DB_PREFIX."bitmap_category ".$where." ORDER BY description ASC";
		$query = $this->db->query($sql);
		
		$categories = array();
    		foreach ($query->rows as $result) {
			
			$categories[$result['id_category']] = array(
        			'id_category'	=> $result['id_category'],
        			'description'	=> "   ".$result['description'],
					'children'	=> $this->getCategoriesByParentId($result['id_category']),
        		);
						
			/*$children = $this->getCategoriesByParentId($result['id_category'], $nested_level+1);
			
			if ($children) {
				foreach($children as $val)
				{
					$categories[$val['id_category']] = $val;
				}
			}*/
    		}
		return $categories;
	}
}
?>