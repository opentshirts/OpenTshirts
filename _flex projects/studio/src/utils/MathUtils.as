package utils
{
	public class MathUtils
	{
		public function MathUtils()
		{
		}
		public static function roundToMultiple( number:int, multiple:int ):int {
			var t:Number = number / multiple;
			t = Math.round( t );
			return t * multiple;
		}
		public static function toRadians(degrees:Number):Number {
			return degrees * Math.PI/180;
		}
	}
}