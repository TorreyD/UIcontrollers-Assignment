package  com
{	
	import flash.display.MovieClip;
	
	public class PlayerImage extends MovieClip
	{
		public static var instance:MovieClip;
		
		public function PlayerImage() 
		{
			instance = this;
		}
	}
}
