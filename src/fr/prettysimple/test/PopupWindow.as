package fr.prettysimple.test
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * Popup window 
	 * @author Alexander Litvinenko
	 * 
	 */	
	public class PopupWindow extends Sprite
	{
		private var border:DisplayObject;
		private var closeBtn:Button;
		
		public function PopupWindow()
		{
			init();
		}
		
		private function init():void
		{
			addChild(border = new Image(Texture.fromBitmap(new Assets.window_png())));
			
			var cbATlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new Assets.close_png()), XML(new Assets.close_xml()));
			
			addChild(closeBtn = new Button(cbATlas.getTexture("CloseButton0000"), "", cbATlas.getTexture("CloseButton0002"), cbATlas.getTexture("CloseButton0001")));
			closeBtn.x = border.width - closeBtn.width * 0.7;
			closeBtn.y = -closeBtn.height * 0.4;
			closeBtn.addEventListener(Event.TRIGGERED, onClose);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function arrange():void
		{
			x = stage.stageWidth - border.width >> 1;
			y = stage.stageHeight - border.height >> 1;
		}
		
		private function jump():Tween
		{
			var tween:Tween = new Tween(this, 0.15, Transitions.EASE_IN);
			tween.moveTo(this.x, this.y - 40);
			tween.reverse = true;
			tween.repeatCount = 2;
			
			Starling.juggler.add(tween);
			
			return tween;
		}
		
		private function close():void
		{
			removeFromParent();
		}
		
		//events
		private function onAdded(evt:Event):void
		{
			arrange();
			jump();
		}
		
		private function onClose(evt:Event):void
		{
			jump().onComplete = close;
		}
	}
}