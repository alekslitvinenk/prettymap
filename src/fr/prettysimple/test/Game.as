package fr.prettysimple.test
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class Game extends Sprite
	{
		private var map:Map;
		private var zoomIn:DisplayObject;
		private var zoomOut:DisplayObject;
		private var newTask:DisplayObject;
		
		private var dragging:Boolean;
		private var startDragTouchPoint:Point;
		private var startDragMapPoint:Point;
		private var dragRect:Rectangle;
		
		public function Game()
		{
			if(stage)
			{
				init();
			}else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAdded);
			}
		}
		
		private function init():void
		{
			createMap();
			createTools();
		}
		
		private function createMap():void
		{
			var bmp:Bitmap = new Assets.new_york_map();
			var bmd:BitmapData = bmp.bitmapData;
			
			var textures:Vector.<Texture> = new Vector.<Texture>();
			
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
			map.initScale(stage.stageWidth/Config.mapWidth);
			map.addEventListener(TouchEvent.TOUCH, onMapTouch);
		}
		
		private function createTools():void
		{
			addChild(zoomIn = new Image(Texture.fromBitmap(new Assets.zoom_in())));
			zoomIn.x = stage.stageWidth - zoomIn.width;
			zoomIn.addEventListener(TouchEvent.TOUCH, onZoomIn);
			
			addChild(zoomOut = new Image(Texture.fromBitmap(new Assets.zoom_out())));
			zoomOut.x = stage.stageWidth - zoomOut.width;
			zoomOut.y = 70;
			zoomOut.addEventListener(TouchEvent.TOUCH, onZoomOut);
			
			addChild(newTask = new TaskView());
			newTask.x = stage.stageWidth - 80;
			newTask.y = 140;
		}
		
		//events
		private function onAdded(evt:Event):void
		{
			init();
		}
		
		private function onZoomIn(evt:TouchEvent):void
		{
			var touch:Touch = evt.getTouch(stage);
			if(!touch) return;
			
			if(touch.phase == TouchPhase.ENDED)
			{
				map.zoomIn();
			}
			
		}
		
		private function onZoomOut(evt:TouchEvent):void
		{
			var touch:Touch = evt.getTouch(stage);
			if(!touch) return;
			
			if(touch.phase == TouchPhase.ENDED)
			{
				map.zoomOut();
			}
		}
		
		private function onMapTouch(evt:TouchEvent):void
		{
			var touch:Touch = evt.getTouch(stage);
			
			if(!touch) return;
			
			if(touch.phase == TouchPhase.BEGAN)
			{
				dragging = true;
				startDragMapPoint = new Point(map.x, map.y);
				startDragTouchPoint = touch.getLocation(stage);
				dragRect = new Rectangle(stage.stageWidth - map.width, stage.stageHeight - map.height, map.width - stage.stageWidth, map.height - stage.stageHeight);
			}
			
			if(touch.phase == TouchPhase.MOVED)
			{
				if(dragging)
				{
					var pt:Point = touch.getLocation(stage);
					var delta:Point = pt.subtract(startDragTouchPoint);
					var dest:Point = startDragMapPoint.add(delta);
					
					/*if(dest.x > 0)
					{
						startDragTouchPoint.x -= -delta.x;
						dest.x = 0;
					}
					
					if(delta.x <= (stage.stageWidth - (map.x + map.width)))
					{
						dest.x = -map.width + stage.stageWidth;
					}
					
					if(dest.y > 0)
					{
						startDragTouchPoint.y -= -delta.y;
						dest.y = 0;
					}*/
					
					map.x = dest.x;
					map.y = dest.y;
				}
			}
			
			if(touch.phase == TouchPhase.ENDED)
			{
				dragging = false;
			}
		}
	}
}