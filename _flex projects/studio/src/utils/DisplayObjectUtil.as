package utils
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;

	public class DisplayObjectUtil
	{
		public static function tint(target:DisplayObject, color:uint):void 
		{
			var colorTransform:ColorTransform = target.transform.colorTransform;
			colorTransform.color=color;
			target.transform.colorTransform = colorTransform;
		}
		public static function convertoToGrayScale(target:DisplayObject):void
		{
			const rLum:Number=0.212671;
			const gLum:Number=0.715160;
			const bLum:Number=0.072169;
			
			var matrix:Array = [rLum, gLum, bLum, 0, 0, // red
				rLum, gLum, bLum, 0, 0, // green
				rLum, gLum, bLum, 0, 0, // blue
				0,  0,  0, 1, 0 ]; // alpha
			var my_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
			target.filters=[my_filter];
		}
		
	}
}