package com.game.global 
{
	/**
	 * ...
	 * @author ...
	 */
	public class GlobalStats {
		
		private static var _level:uint;
		private static var _xp:uint;
		private static var _coins:uint;
		private static var _candy:uint;
		private static var _cash:uint;
		private static var _energy:uint;
		
		public static function get level():uint 		{ return _level; }
		public static function set level(val:uint):void { _level = val;	GlobalObjects.uiStats.statLevel = _level; }
		
		public static function get xp():uint 			{ return _xp; }
		public static function set xp(val:uint):void 	{ _xp = val;	GlobalObjects.uiStats.statXP = _xp; }
		
		public static function get coins():uint 		{ return _coins; }
		public static function set coins(val:uint):void { _coins = val;	GlobalObjects.uiStats.statCoins = _coins; }
		
		public static function get candy():uint 		{ return _candy; }
		public static function set candy(val:uint):void { _candy = val;	GlobalObjects.uiStats.statCandy = _candy; }
		
		public static function get cash():uint 			{ return _cash; }
		public static function set cash(val:uint):void 	{ _cash = val; 	GlobalObjects.uiStats.statCash = _cash; }
		
		public static function get energy():uint 		{ return _energy; }
		public static function set energy(val:uint):void{ _energy = val; 	GlobalObjects.uiStats.statEnergy = _energy; }
	}

}