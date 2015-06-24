package fr.prettysimple.test
{
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Map extends Sprite
	{
		//layers
		private var graund:Sprite;
		private var madison:MovieClip;
		private var arrow:MovieClip;
		
		private var _data:Vector.<Texture>;

		public function get data():Vector.<Texture>
		{
			return _data;
		}

		public function set data(value:Vector.<Texture>):void
		{
			_data = value;
			commitData();
		}

		
		public function Map(textures:Vector.<Texture>)
		{
			addChild(graund = new Sprite());
			
			var mtAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new Assets.madison_png()), XML(new Assets.madison_xml()));
			
			addChild(madison = new MovieClip(mtAtlas.getTextures("madison_anim")));
			madison.addEventListener(TouchEvent.TOUCH, onMadisonTouch);
			madison.x = 1335;
			madison.y = 1630;
			madison.stop();
			Starling.juggler.add(madison);
			
			var arAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new Assets.arrow_png()), XML(new Assets.arrow_xml()));
			
			addChild(arrow = new MovieClip(arAtlas.getTextures("arrow_anim"), 18));
			arrow.addEventListener(TouchEvent.TOUCH, onMadisonTouch);
			arrow.x = 1355;
			arrow.y = 1200;
			arrow.touchable = false;
			
			Starling.juggler.add(arrow);
			
			_data = textures;
			commitData();
		}
		
		private function commitData():void
		{
			if(_data && _data.length)
			{
				for(var i:uint = 0; i < 5; i++)
				{
					for(var j:uint = 0; j < 7; j++)
					{
						var image:Image = new Image(_data[j + i * 7]);
						image.x = 512 * j;
						image.y = 1024 * i;
						graund.addChild(image);
					}
				}
			}
			
			graund.flatten();
		}
		
		//events
		private function onMadisonTouch(evt:TouchEvent):void
		{
			var touchHover:Touch = evt.getTouch(madison, TouchPhase.HOVER);
			
			if(touchHover)
			{
				madison.play();
			}else
			{
				madison.stop();
			}
		}
	}
}