package utils
{
	import mx.utils.ArrayUtil;

	public class ArrayUtil
	{
		public static function addToArray(target:Object, array:Array):Array
		{
			var index:int = mx.utils.ArrayUtil.getItemIndex(target, array);
			if(index==-1) //if no exists
				array.push(target);
			return array;
		}
		public static function removeFromArray(target:Object, array:Array):Array
		{
			var index:int = mx.utils.ArrayUtil.getItemIndex(target, array);
			if(index>=0) //if exists
				array.splice(index,1);
			return array;
		}
		
	}
}