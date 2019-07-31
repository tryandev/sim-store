package com.game.animation{
	import away3d.core.project.MovieClipSpriteProjector;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	//import TextureMC;
	
	public class Textures {
		//[Embed(source='assets/swf/LibArt-Character.swf',mimeType="application/octet-stream")]
		//[Embed(source="Assets.swf", symbol="MySymbol")]   
		//[Embed(source="Assets.swf", symbol="MySymbol")]   
		[Embed(source='../../../assets/swf/LibArt-Character.swf', symbol="mc_character")]
		private static const swfTextureAvatar:Class;
		
		public static const INDEX_SKIN:uint = 0;
		public static const INDEX_HAIRCOLOR:uint = 1;
		public static const INDEX_SCALP:uint = 2;
		public static const INDEX_BROWS:uint = 3;
		public static const INDEX_EYES:uint = 4;
		public static const INDEX_EYECOLOR:uint = 5;
		public static const INDEX_NOSE:uint = 6;
		public static const INDEX_MOUTH:uint = 7;
		public static const INDEX_FACIAL:uint = 8;
		public static const INDEX_MARKS1:uint = 9;
		public static const INDEX_MARKS2:uint = 10;
		public static const INDEX_EYEWARE:uint = 11;
		public static const INDEX_SHIRT:uint = 12;
		public static const INDEX_PANTS:uint = 13;
		public static const INDEX_SHOES:uint = 14;
		public static const MC_NAMES:Array = [
			'mc_skin',		// 0
			'mc_hair',		// 1
			'mc_scalp',		// 2
			'mc_brows',		// 3
			'mc_eyes',		// 4
			'mc_eyecolor',	// 5
			'mc_nose',		// 6
			'mc_mouth',		// 7
			'mc_facial',	// 8
			'mc_marks1',	// 9
			'mc_marks2',	// 10
			'mc_eyeware',	// 11
			'mc_shirt',		// 12
			'mc_pants',		// 13
			'mc_shoes'		// 14
		];
		
		public static function textureAvatar():MovieClip {
			var newMC:MovieClip = MovieClip(new swfTextureAvatar());
			var childMC:MovieClip;
			newMC.stop();
			for (var i:uint = 0; i < newMC.numChildren; i++ ) {
				childMC = newMC.getChildAt(i) as MovieClip;
				childMC.stop();
			}
			
			return newMC;
		}
	}
}