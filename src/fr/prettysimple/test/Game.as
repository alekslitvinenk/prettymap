package fr.prettysimple.test
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * App facade 
	 * 
	 * @author Alexander Litvinenko
	 * 
	 */	
	public class Game extends Sprite
	{
		//layers
		private var map:Map;
		private var tools:DisplayObjectContainer;
		private var windows:DisplayObjectContainer
		
		//tools
		private var zoomIn:DisplayObjectContainer;
		private var zoomOut:DisplayObjectContainer;
		private var newTask:DisplayObjectContainer;
		
		private var dragging:Boolean;
		private var startDragTouchPoint:Point;
		private var startDragMapPoint:Point;
		private var dragRect:Rectangle;
		
		private var _atlas:TextureAtlas;
		
		public function get atlas():TextureAtlas
		{
			if(!_atlas)
			{
				_atlas = new TextureAtlas(Texture.fromBitmap(new Assets.atlas_png()), XML(new Assets.atlas_xml()));
			}
			
			return _atlas;
		}
		
		private var _popupWindow:PopupWindow;

		public function get popupWindow():PopupWindow
		{
			if(!_popupWindow)
			{
				_popupWindow = new PopupWindow();
			}
			
			return _popupWindow;
		}
		
		private static var _instance:Game;

		public static function get instance():Game
		{
			return _instance;
		}
		
		public function Game()
		{
			if(stage)
			{
				init();
			}else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAdded);
			}
			
			_instance = this;
		}
		
		public function showPopup():void
		{
			windows.addChild(popupWindow);
		}
		
		private function init():void
		{
			createMap();
			createTools();
			addChild(windows = new Sprite());
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
			map.initScale(stage.stageWidth/Config.MAP_WIDTH);
			map.addEventListener(TouchEvent.TOUCH, onMapTouch);
		}
		
		private function createTools():void
		{
			addChild(tools = new Sprite());
			
			tools.addChild(zoomIn = new ToolButton(new Image(atlas.getTexture("zoom_in"))));
			zoomIn.x = stage.stageWidth - 70;
			zoomIn.addEventListener(TouchEvent.TOUCH, onZoomIn);
			
			tools.addChild(zoomOut = new ToolButton(new Image(atlas.getTexture("zoom_out"))));
			zoomOut.x = stage.stageWidth - 70;
			zoomOut.y = 130;
			zoomOut.addEventListener(TouchEvent.TOUCH, onZoomOut);
			
			tools.addChild(newTask = new ToolButton(new TaskView()));
			newTask.x = stage.stageWidth - 65;
			newTask.y = 200;
			newTask.addEventListener(TouchEvent.TOUCH, onTask);
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
		
		private function onTask(evt:TouchEvent):void
		{
			var touch:Touch = evt.getTouch(stage);
			if(!touch) return;
			
			if(touch.phase == TouchPhase.ENDED)
			{
				map.scrollTo(Config.MADISON_SQUARE);
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
					
					map.moveTo(dest);
				}
			}
			
			if(touch.phase == TouchPhase.ENDED)
			{
				dragging = false;
			}
		}
	}
}