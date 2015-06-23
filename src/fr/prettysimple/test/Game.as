package fr.prettysimple.test
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class Game extends Sprite
	{
		private var textures:Vector.<Texture>;
		private var map:Map;
		
		private var dragging:Boolean;
		private var startDragPoint:Point;
		
		public function Game()
		{
			init();
		}
		
		private function init():void
		{
			var bmp:Bitmap = new Assets.new_york_map();
			var bmd:BitmapData = bmp.bitmapData;
			
			textures = new Vector.<Texture>();
			
			for(var i:uint = 0; i < 5; i++)
			{
				for(var j:uint = 0; j < 7; j++)
				{
					var sampleBmp:BitmapData = new BitmapData(512, 1024, false, 0);
					var mtx:Matrix = new Matrix();
					mtx.translate(-j * 512, -i * 1024);
					
					sampleBmp.draw(bmd, mtx);
					
					textures.push(Texture.fromBitmapData(sampleBmp));
				}
			}
			
			addChild(map = new Map(textures));
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		//events
		private function onAdded(evt:Event):void
		{
			map.scaleX = stage.stageWidth/Config.mapWidth;
			map.scaleY = map.scaleX;
			map.addEventListener(TouchEvent.TOUCH, onMapTouch);
		}
		
		private function onMapTouch(evt:TouchEvent):void
		{
			var touch:Touch = evt.getTouch(stage);
			
			if(!touch) return;
			
			if(touch.phase == TouchPhase.BEGAN)
			{
				dragging = true;
				startDragPoint = touch.getLocation(stage).subtract(new Point(map.x, map.y));
			}
			
			if(touch.phase == TouchPhase.MOVED)
			{
				if(dragging)
				{
					var pt:Point = touch.getLocation(stage);
					var delta:Point = pt.subtract(startDragPoint);
					map.x = delta.x;
					map.y = delta.y;
				}
			}
			
			if(touch.phase == TouchPhase.ENDED)
			{
				dragging = false;
			}
		}
	}
}