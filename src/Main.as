package
{
	import flash.display.Sprite;
	
	import fr.prettysimple.test.Game;
	
	import starling.core.Starling;
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#000000")]
	public class Main extends Sprite
	{
		private var mStarling:Starling;
		
		public function Main()
		{
			mStarling = new Starling(Game, stage);
			mStarling.antiAliasing = 4;
			mStarling.enableErrorChecking = true;
			mStarling.start();
		}
	}
}