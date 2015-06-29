package fr.prettysimple.test
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class TaskView extends Sprite
	{
		private var exclam:MovieClip;
		
		public function TaskView()
		{
			init();
		}
		
		private function init():void
		{
			var exAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new Assets.exclam_png()), XML(new Assets.exclam_xml()));
			
			addChild(exclam = new MovieClip(exAtlas.getTextures("exclamation_anim"), 18));
			
			Starling.juggler.add(exclam);
		}
	}
}