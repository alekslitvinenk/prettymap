package fr.prettysimple.test
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Map extends Sprite
	{
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
						addChild(image);
					}
				}
			}
			
			flatten();
		}
	}
}