package utils
{
	public class VectorUtil
	{
		public static function toArray(obj:Object):Array {
			if (!obj) {
				return [];
			} else if (obj is Array) {
				return obj as Array;
			} else if (obj is Vector.<*>) {
				var array:Array = new Array(obj.length);
				for (var i:int = 0; i < obj.length; i++) {
					array[i] = obj[i];
				}
				return array;
			} else {
				return [obj];
			}
		} 
	}
}