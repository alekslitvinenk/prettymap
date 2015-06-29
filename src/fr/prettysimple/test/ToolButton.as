package fr.prettysimple.test
{	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * Base class for tools 
	 * @author Alexander Litvinenko
	 * 
	 */	
	public class ToolButton extends Sprite
	{
		private var content:DisplayObject;
		
		public function ToolButton(content:DisplayObject)
		{
			this.content = content;
			
			init();
		}
		
		private function init():void
		{
			addChild(content);
			
			x += width >> 1;
			y += height >> 1;
			
			pivotX = width >> 1;
			pivotY = height >> 1;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(evt:TouchEvent):void
		{
			var touchHover:Touch = evt.getTouch(this, TouchPhase.HOVER);
			
			if(touchHover)
			{
				this.scaleX = this.scaleY = 1.15;
			}else
			{
				this.scaleX = this.scaleY = 1.0;
			}
		}
	}
}