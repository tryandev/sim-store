package com.game.ui.button {
	import adobe.utils.CustomActions;
	import away3d.core.utils.Init;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.filters.DropShadowFilter;
	
	public class uiRectangle extends Sprite {
		public var borderAlpha:Number 	= 0;
		public var borderColor:int 	= 0x000000;
		public var borderSize:Number 	= 3;
		
		public var fillAlpha:Number 	= 1;
		public var fillColor:int 		= 0x777777;
		public var fillColor2:int 		= fillColor;
		
		public var glossAlpha:Number 	= 0;
		public var cornerRadius:Number = 5;
		public var shadowAlpha:Number	= 0;
		public var shadowBlur:Number	= 5;
		
		public var specColor:int		= 0xFFFFFF;
		public var specAlpha:Number		= 0;
		public var specSize:Number		= 1.7;
		
		public var shadeColor:int		= 0x000000;
		public var shadeAlpha:Number	= 0;
		public var shadeSize:Number		= 1;
		
		public var angle:Number			= 45;
		
		private var _width:Number 		= 100;
		private var _height:Number 		= 100;
		
		/**
		 * borderAlpha, borderColor, borderSize, fillAlpha, fillColor, fillColor2, glossAlpha, cornerRadius, width, height
		 */
		public function uiRectangle(init:Object = null) {
			var ini:Init = Init.parse(init);
			borderAlpha = 	ini.getNumber(	"borderAlpha", 	borderAlpha);
			borderColor = 	ini.getInt(		"borderColor",	borderColor);
			borderSize = 	ini.getNumber(	"borderSize",	borderSize);
			cornerRadius =	ini.getNumber(	"cornerRadius", cornerRadius);
			fillAlpha = 	ini.getNumber(	"fillAlpha", 	fillAlpha);
			fillColor = 	ini.getInt(		"fillColor",	fillColor);
			fillColor2 = 	ini.getInt(		"fillColor2",	fillColor);
			glossAlpha =	ini.getNumber(	"glossAlpha", 	glossAlpha);
			_width = 		ini.getNumber(	"width", 		_width);
			_height = 		ini.getNumber(	"height", 		_height);
			shadowAlpha = 	ini.getNumber(	"shadowAlpha",	shadowAlpha);
			shadowBlur = 	ini.getNumber(	"shadowBlur", 	shadowBlur);
			
			specAlpha = 	ini.getNumber(	"specAlpha", 	specAlpha);
			specSize = 		ini.getNumber(	"specSize", 	specSize);
			specColor = 	ini.getInt(		"specColor", 	specColor);
			
			shadeAlpha = 	ini.getNumber(	"shadeAlpha", 	shadeAlpha);
			shadeSize = 	ini.getNumber(	"shadeSize", 	shadeSize);
			shadeColor = 	ini.getInt(		"shadeColor", 	shadeColor);
			
			angle = 		ini.getNumber(	"angle", 		angle);
				//trace(borderColor);
			
			redraw();
		}
		
		public override function get width():Number {return _width;}
		public override function get height():Number {return _height;}
		public override function set width(value:Number):void {_width = value;}
		public override function set height(value:Number):void {_height = value;}
		
		public function redraw():void {
			var myGraphics:Graphics = this.graphics;
			var bSize:Number = 0;
			if (borderAlpha > 0 && borderSize > 0) bSize = borderSize;
			
			myGraphics.clear();
			if (borderAlpha > 0 && bSize > 0) {
				myGraphics.beginFill(borderColor, borderAlpha);
				myGraphics.drawRoundRectComplex(0, 0, width, height, 												cornerRadius, cornerRadius, cornerRadius, cornerRadius);
				myGraphics.drawRoundRectComplex(bSize, bSize, width-bSize * 2, height-bSize * 2,cornerRadius-bSize, cornerRadius-bSize, cornerRadius-bSize, cornerRadius-bSize);
				myGraphics.endFill();
			}
			if (fillAlpha > 0) {
				if (fillColor != fillColor2) {
					var tempMatrix:Matrix = new Matrix();
					tempMatrix.createGradientBox(width, height, Math.PI/2);
					if (fillAlpha > 0) {
						myGraphics.beginGradientFill(
							GradientType.LINEAR, 
							[fillColor, fillColor2], 
							[fillAlpha, fillAlpha], 
							[0, 255],
							tempMatrix
						);
					}
				}else{
					if (fillAlpha > 0) myGraphics.beginFill(fillColor, fillAlpha);
				}
				myGraphics.drawRoundRectComplex(bSize, bSize, width-bSize * 2, height-bSize * 2,cornerRadius-bSize, cornerRadius-bSize, cornerRadius-bSize, cornerRadius-bSize);
				myGraphics.endFill();
			}
			if (glossAlpha > 0) {
					myGraphics.lineStyle();
					myGraphics.beginFill(0xFFFFFF, glossAlpha);
					myGraphics.drawRoundRectComplex(bSize, bSize, width-bSize * 2, Math.round((height-bSize * 2)/2),cornerRadius-bSize, cornerRadius-bSize, 0, 0);
					myGraphics.endFill();
			}
			if (specAlpha > 0 && specSize > 0) {
				var tempMatrix2:Matrix = new Matrix();
				var w:Number = width - bSize * 2;
				var h:Number = height - bSize * 2;
				tempMatrix2.createGradientBox(w * 1.414, h * 1.414, angle / 180 * Math.PI, -w * 0.1215, -h * 0.1215);
				tempMatrix2.tx = tempMatrix2.a * 1000*.92;
				tempMatrix2.ty = tempMatrix2.b * 1000*.92;
				myGraphics.beginGradientFill(
					GradientType.LINEAR, 
					[specColor, specColor, specColor, shadeColor, shadeColor], 
					[specAlpha, (specColor == shadeColor) ? specAlpha:shadeAlpha/3, (specColor == shadeColor) ? specAlpha:0, (specColor == shadeColor) ? specAlpha:shadeAlpha/3, shadeAlpha],
					[0, 116, 127, 138, 255],
					tempMatrix2
					/*GradientType.LINEAR, 
					[0xFF0000, specColor, specColor, 0x00FF00, shadeColor,  shadeColor, 0x00FFFF], 
					[1,1,1,1,1,1,1],//[specAlpha, specAlpha/2, 0, shadeAlpha/2, shadeAlpha],
					[0, 1, 126,127,128, 254, 255],
					tempMatrix2*/
				);
				myGraphics.lineStyle();
				var radius1:Number  = cornerRadius - bSize;
				var radius2:Number  = cornerRadius - bSize - specSize;
				myGraphics.drawRoundRectComplex(bSize, bSize, width - bSize * 2, height - bSize * 2, radius1, radius1, radius1, radius1);
				myGraphics.drawRoundRectComplex(bSize+specSize, bSize+specSize, width - (bSize+specSize) * 2, height - (bSize+specSize) * 2,radius2,radius2,radius2,radius2);// , cornerRadius - bSize-specsize, cornerRadius - bSize, cornerRadius - bSize, cornerRadius - bSize);
				myGraphics.endFill();
				//trace(tempMatrix2.toString());
			}
			if (shadowAlpha > 0 && shadowBlur > 0) {
				var myShadow:DropShadowFilter = new DropShadowFilter(0, 0, 0x000000, shadowAlpha, shadowBlur, shadowBlur, 1, 1, true, false, false);
				this.filters = [myShadow];
			}
		}
	}

}