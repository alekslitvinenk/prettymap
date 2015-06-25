package fr.prettysimple.test
{
	import flash.geom.Point;
	
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
		
		private var zoomPoint:Point;
		private var mapPoint:Point;
		
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
			madison.x = Config.MADISON_SQUARE.x;
			madison.y = Config.MADISON_SQUARE.y;
			madison.pivotX = madison.width >> 1;
			madison.pivotY = madison.height >> 1;
			madison.stop();
			Starling.juggler.add(madison);
			
			var arAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new Assets.arrow_png()), XML(new Assets.arrow_xml()));
			
			addChild(arrow = new MovieClip(arAtlas.getTextures("arrow_anim"), 18));
			arrow.addEventListener(TouchEvent.TOUCH, onMadisonTouch);
			arrow.x = Config.MADISON_SQUARE.x;
			arrow.y = Config.MADISON_SQUARE.y;
			arrow.pivotX = arrow.width >> 1;
			arrow.pivotY = arrow.height;
			arrow.touchable = false;
			
			Starling.juggler.add(arrow);
			
			_data = textures;
			commitData();
		}
		
		public function initScale(val:Number):void
		{
			this.scaleY = this.scaleX = val;
			
			trace(val);
		}
		
		public function zoomIn():void
		{
			zoomPoint = globalToLocal(new Point(stage.stageWidth/2, stage.stageHeight/2));
			mapPoint = new Point(x, y);
			
			var tween:Tween = new Tween(this, 0.3);
			tween.scaleTo(this.scaleX * 1.3);
			tween.onUpdate = updateAfterZoom;
			
			Starling.juggler.removeTweens(this);
			Starling.juggler.add(tween);
			
			trace("zoomIn");
		}
		
		public function zoomOut():void
		{
			zoomPoint = globalToLocal(new Point(stage.stageWidth >> 1, stage.stageHeight >> 1));
			mapPoint = new Point(x, y);
			
			var tween:Tween = new Tween(this, 0.3);
			tween.scaleTo(this.scaleX * 0.8);
			tween.onUpdate = updateAfterZoom;
			
			Starling.juggler.removeTweens(this);
			Starling.juggler.add(tween);
		}
		
		public function scrollTo(dest:Point):void
		{
			var center:Point = new Point(stage.stageWidth >> 1, stage.stageHeight >> 1);
			var delta:Point = localToGlobal(dest).subtract(center);
			
			var tween:Tween = new Tween(this, 0.3);
			tween.moveTo(this.x - delta.x, this.y - delta.y);
			
			//Starling.juggler.removeTweens(this);
			Starling.juggler.add(tween);
		}
		
		private function updateAfterZoom():void
		{
			var changePt:Point = globalToLocal(new Point(stage.stageWidth >> 1, stage.stageHeight >> 1));
			var delta:Point = changePt.subtract(zoomPoint);
			
			trace(delta);
			
			this.x += delta.x/2;
			this.y += delta.y/2;
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