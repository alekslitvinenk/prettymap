package fr.prettysimple.test
{
	/**
	 * Embedded asets
	 *  
	 * @author Alexander Litvinenko
	 * 
	 */	
	public class Assets
	{
		[Embed(source="/../assets/new_york_map.jpg")]
		public static const new_york_map:Class;
		
		[Embed(source="/../assets/atlas.png")]
		public static const atlas_png:Class;
		
		[Embed(source="/../assets/atlas.xml", mimeType="application/octet-stream")]
		public static const atlas_xml:Class;
	}
}