package com.scaleform.hud {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.utils.getDefinitionByName;
	import flash.external.ExternalInterface;

	public class SpellIcon extends MovieClip {

		// Constructor code
		public function SpellIcon() {
		//	trace("found SpellIcon");
			super();
		}
		
		public function MyMe()
		{
			trace("hiho");
		}

		// Change spell image - called from Unreal Script
		public function setSpellIconImage(iconimagename:String):void
		{
			ExternalInterface.call("SendToUC", iconimagename + " hi my spell name");
			// Remove current Image
			removeChildAt(0);	
		
			// Set new Image
			var spellimage:Bitmap = new Bitmap();
			
			// Get Image name from library
			var iconimageclass:Class = getDefinitionByName(iconimagename) as Class;
		
			// Set width and height
			var iconinstance:BitmapData = new iconimageclass(100, 100);
			
		
			spellimage.bitmapData = iconinstance;
			addChild(spellimage);
			
			spellimage.width = 100;
			spellimage.height = 100;
		}


	}
}
