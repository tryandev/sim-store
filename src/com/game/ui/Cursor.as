package com.game.ui 
{
	import away3d.core.stats.Stats;
	import com.game.global.GlobalObjects;
	import com.game.ui.icons.stats;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author ...
	 */
	public class Cursor extends Sprite
	{
		//private var _iconDefault:Sprite;
		private var _iconMove:Sprite;
		private var _iconRotate:Sprite;
		private var _iconSell:Sprite;
		private var _iconStore:Sprite;
		
		public function Cursor () {
			//_iconDefault = new stats.ARROW_DEFAULT;
			var outline1:GlowFilter = new GlowFilter(0xFFFFFF, 1, 3, 3, 5);
			var outline2:GlowFilter = new GlowFilter(0x2F4E59, 1, 5, 5, 10);
			
			_iconMove = new stats.ARROW_MOVE;
			_iconRotate = new stats.ARROW_ROTATE;
			_iconSell = new stats.COINS;
			_iconStore = new stats.STORE;
			
			
			_iconMove.scaleX = 1.2;		_iconMove.scaleY = 1.2;		_iconMove.filters = 	[outline1,new GlowFilter(0x2F4E59, 1, 5, 5, 10)];
			_iconRotate.scaleX = 1.2;	_iconRotate.scaleY = 1.2;	_iconRotate.filters = 	[outline1,new GlowFilter(0x0E4917, 1, 5, 5, 10)];
			_iconSell.scaleX = 1.2;		_iconSell.scaleY = 1.2;		_iconSell.filters = 	[outline1,new GlowFilter(0x664817, 1, 5, 5, 10)];
			_iconStore.scaleX = 1.2;	_iconStore.scaleY = 1.2;	_iconStore.filters = 	[outline1,new GlowFilter(0x5E2E1A, 1, 5, 5, 10)];
			
			//trace('new cursor');
		}
		
		public function showDefault():void {
			clearIcon();
			//this.addChild(_iconDefault);
			//follow();
		}
		public function showMove():void {
			clearIcon();
			this.addChild(_iconMove);
			//trace('showMove Added');
			follow();
			//trace('followed');
		}
		public function showRotate():void {
			clearIcon();
			this.addChild(_iconRotate);
			//trace('showRotate Added');
			follow();
		}
		public function showSell():void {
			clearIcon();
			this.addChild(_iconSell);
			//trace('showSell Added');
			follow();
		}
		public function showStore():void {
			clearIcon();
			this.addChild(_iconStore);
			//trace('showStore Added');
			follow();
		}
		private function clearIcon():void {
			if (this.numChildren > 0) this.removeChild(this.getChildAt(0));
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandle, true);
			//trace('clearIcon() done');
		}
		private function follow():void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandle, true, 0, true);
			mouseMoveHandle(null);
			//trace('follow() done');
		}
		private function mouseMoveHandle(e:Event):void {
			this.x = stage.mouseX+10 //- GlobalObjects.world.x;
			this.y = stage.mouseY+25 //- GlobalObjects.world.y;
			//trace('xxx');
		}
	}
}