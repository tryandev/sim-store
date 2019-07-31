package com.game.ui.panels 
{
	import com.game.containers.World;
	import com.game.global.GlobalObjects;
	import com.game.grid.Map;
	import com.game.ui.button.uiRectangle;
	import com.game.ui.gauge.uiGauge;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.filters.DropShadowFilter
	import com.zl.font.Fonts;
	/**
	 * ...
	 * @author 
	 */
	public class uiActionGauge extends Sprite {
		private var _format:TextFormat;
		private var _tf:TextField;
		private var _bg:uiRectangle;
		private var _gauge:uiGauge;
		
		public function uiActionGauge()  {
			this.visible = false;
			_format = new TextFormat();
			_format.font =  new Fonts().Klaven();
			_format.align = TextFormatAlign.CENTER;
			_format.color = 0xFFFFFF;
			_format.size = 13;
			
			_tf = new TextField();
			_tf.embedFonts  = true;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.antiAliasType = AntiAliasType.NORMAL;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			_tf.defaultTextFormat = _format;
			_tf.filters = [new DropShadowFilter(0, 0, 0/*_textBorderColor*/, 1, 4, 4, 15)];
			
			var	bgObject:Object = {
				cornerRadius: 7, 
				borderAlpha: 1, 
				borderSize: 2, 
				borderColor: 0x785a3c,//0x5b3e28,//3d2a15,
				fillColor: 0xad8d60, 
				fillColor2: 0x9d7d50, 
				width: 120, 
				height: 32, 
				specColor: 0xFFFFFF, 
				specAlpha: 0.3, 
				specSize: 1.2, 
				shadeColor: 0xFFFFFF, 
				shadeAlpha: 0.5, 
				shadeSize: 1.5, 
				angle: 90 
			};
			
			var	gaugeObject:Object = {
				width:	bgObject['width'] - 12, 
				height:	bgObject['height'] - 12,
				cornerRadius:	5
			};
			
			_bg = new uiRectangle(bgObject);
			_bg.x = -_bg.width / 2;
			_bg.y = -_bg.height / 2;
			
			_gauge = new uiGauge(gaugeObject);
			_gauge.x = -_gauge.width / 2;
			_gauge.y = -_gauge.height / 2;
			
			addChild(_bg);
			addChild(_gauge);
			addChild(_tf);
			text = "Doing";
			percent = 0.5;
		}
		public function followItemXY(inX:Number, inY:Number, inPercent:Number):void {
			var actionGauge:uiActionGauge = GlobalObjects.actionGauge;
			var world:World = GlobalObjects.world;
			var map:Map = GlobalObjects.world.map;
			this.visible = true;
			this.percent = inPercent;
			var scale:Number = world.scaleX;
			this.x = Math.round((map.x + inX) * scale + 380);
			this.y = Math.round((map.y + inY - 75) * scale + stage.stageHeight/2);
		}
		public function set text(value:String):void {
			_tf.text = value;
			_tf.x = -Math.round(_tf.width / 2);
			_tf.y = -Math.round(_tf.height / 2) - 0.2;
		}
		
		public function set percent(value:Number):void {
			_gauge.percent = value;
		}
	}

}