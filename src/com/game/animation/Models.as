package com.game.animation {
	//import away3d.loaders.Obj;
	public class Models {
		
		[Embed(source="../../../assets/md2/guy6.md2",mimeType="application/octet-stream")]
		private static const ModelBodyThin:Class;
		
		[Embed(source="../../../assets/md2/guy6.md2",mimeType="application/octet-stream")]
		private static const ModelBodyNormal:Class;
		
		[Embed(source="../../../assets/md2/guy6.md2",mimeType="application/octet-stream")]
		private static const ModelBodyWide:Class;
		
		[Embed(source="../../../assets/md2/hair_combover3.md2",mimeType="application/octet-stream")]
		private static const ModelHairCombover:Class;
		
		[Embed(source="../../../assets/md2/hair_mohawk3.md2",mimeType="application/octet-stream")]
		private static const ModelHairMohawk:Class;
		
		[Embed(source="../../../assets/md2/hair_sidehawk2.md2",mimeType="application/octet-stream")]
		private static const ModelHairHalfshave:Class;
		
		[Embed(source="../../../assets/md2/hair_flat2.md2",mimeType="application/octet-stream")]
		private static const ModelHairFlat:Class;
		
		[Embed(source="../../../assets/md2/pivot.md2",mimeType="application/octet-stream")]
		private static const ModelPivot:Class;
		
		public static const INDEX_BODY:uint = 0;
			public static const INDEX_BODY_NORMAL:uint = 	0;
			public static const INDEX_BODY_THIN:uint = 		1;
			public static const INDEX_BODY_WIDE:uint = 		2;
		public static const INDEX_HAIR:uint = 1;
			public static const INDEX_HAIR_NONE:uint =		0;
			public static const INDEX_HAIR_COMBOVER:uint =	1;
			public static const INDEX_HAIR_MOHAWK:uint = 	2;
			public static const INDEX_HAIR_FLAT:uint = 		3;
			//public static const INDEX_HAIR_HALFSHAVE:uint =	3;
		public static const INDEX_MISC:uint = 2;
			public static const INDEX_MISC_PIVOT:uint =		0;
		
		public function Models() {
			//no constructor
		}
		
		public static function modelFromIndex(inModelType:uint, inModelIndex:uint):Object {
			switch (inModelType) {
				case INDEX_BODY:
					switch (inModelIndex) {
						case INDEX_BODY_NORMAL:
							return ModelBodyNormal;
							break;
						case INDEX_BODY_THIN:
							return ModelBodyThin;
							break;
						case INDEX_BODY_WIDE:
							return ModelBodyWide;
							break;
					}
					break;
				case INDEX_HAIR:
					switch (inModelIndex) {
						case INDEX_HAIR_NONE:
							return null;
							break;
						case INDEX_HAIR_COMBOVER:
							return ModelHairCombover;
							break;
						case INDEX_HAIR_MOHAWK:
							return ModelHairMohawk;
							break;
						/*case INDEX_HAIR_HALFSHAVE:
							return ModelHairHalfshave;
							break;*/
						case INDEX_HAIR_FLAT:
							return ModelHairFlat;
							break;
					}
					break;
				case INDEX_MISC:
					switch (inModelIndex) {
						case INDEX_MISC_PIVOT:
							return ModelPivot;
							break;
					}
					break;
			}			
			new Error("invalid model indices");
			return null;
		}
	}
}