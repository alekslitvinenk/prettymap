package fr.prettysimple.test
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	/**
	 *  
	 * @author Alexander Litvinenko
	 * 
	 */	
	public class TaskView extends Sprite
	{
		private var exclam:MovieClip;
		
		public function TaskView()
		{
			init();
		}
		
		private function init():void
		{
			addChild(exclam = new MovieClip(Game.instance.atlas.getTextures("exclamation_anim"), 18));
			
			Starling.juggler.add(exclam);
		}
	}
}