package com.game.ui.button 
{
	import com.zl.font.Fonts;
	public class uiButtonClose extends uiButtonText
	{
		
		public function uiButtonClose() 
		{
			text = 'Ò';
			textBorderColor = 0x770000;
			fillColor		= 0xFF0000;
			fillColor2		= 0xAA0000;
			fillBorderColor = 0x770000;
			paddingX = 6;
			paddingY = 5;
			textSize = 20;
			_format.font = new Fonts().Wingdings2();
			//super(init);
			shadeAlpha = 0.2;
			redraw();
		}
		public override function redraw():void {
			super.redraw();
		}
	}

}