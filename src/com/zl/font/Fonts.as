package com.zl.font 
{
	import flash.text.Font;
	/**
	 * ...
	 * @author ...
	 */
	public class Fonts 
	{
		//[Embed(source="../../../assets/font/grobold.ttf", fontFamily="grobold")] 
		//public static const FONT_GROBOLD:Class;
		
		[Embed(source="../../../assets/font/KlavenRegular.ttf", fontFamily="Klaven", unicodeRange='U+0020-U+007E')] 
		public static const FONT_KLAVEN:Class;
		
		[Embed(source="../../../assets/font/webdings.ttf", fontFamily="Webdings", unicodeRange='U+0072')] 
		public static const FONT_WEBDINGS:Class;
		
		[Embed(source="../../../assets/font/wingdings2.ttf", fontFamily="Wingdings2", unicodeRange='U+00D2')] 
		public static const FONT_WEBDINGS2:Class;
		
		[Embed(source="../../../assets/font/Helvetica_75_Bold.ttf", fontFamily="Helvetica", unicodeRange='U+0020-U+007E', fontWeight="bold")] 
		public static const FONT_HELVETICA:Class;
		
		[Embed(source="../../../assets/font/head0867.ttf", fontFamily="Header", unicodeRange='U+0020-U+007E')] 
		public static const FONT_HEADER:Class;
		
		[Embed(source="../../../assets/font/ITCAvantGardeStd-Bold.ttf", fontFamily="ITC", fontWeight="bold", unicodeRange='U+0020-U+007E')] 
		public static const FONT_ITC:Class;
		
		//[Embed(source="../../../assets/font/ITC Avant Garde Gothic Demi.ttf", fontFamily="ITC", unicodeRange='U+0020-U+007E')] 
		//public static const FONT_ITC:Class;
		
		public function Fonts():void {
			
		}
		public function Grobold():String {
			return 'grobold';
		}
		public function Klaven():String {
			return 'Klaven';
		}
		public function Header():String {
			return 'Header';
		}
		public function Helvetica():String {
			return 'Helvetica';
		}
		public function ITCDemi():String {
			return 'ITC';
		}
		public function Webdings():String {
			return 'Webdings';
		}
		public function Wingdings2():String {
			return 'Wingdings2';
		}
	}

}