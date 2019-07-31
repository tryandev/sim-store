package com.game.ui.panels 
{
	import away3d.core.filter.IPrimitiveVolumeBlockFilter;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class uiNeisGroup extends Sprite{
		
		private var _neis:Array;
		private var _maxScroll:int;
		private var _scrolling:Boolean;
		private var _hitEdgeFunction:Function;
		
		public var gap:int;
		public var widthCount:int;
		public var xOffset:int;
		
		
		public function uiNeisGroup(inGap:int, inCount:int) {
			
			gap = inGap;
			widthCount = inCount;
			_neis = new Array();
			for (var i:int = 0; i < inCount+4; i++ ) {
				var tempNei:uiNeiBox = new uiNeiBox();
				//tempNei.text = Math.random();
				tempNei.text = tempNei.text + " " + i + "" + i + "" + i;
				//tempNei.text = i;
				tempNei.x = (uiNeiBox.BOX_WIDTH + inGap) * _neis.length;
				addChild(tempNei);
				_neis.push(tempNei);
			}
			_maxScroll = (_neis.length - inCount) * (uiNeiBox.BOX_WIDTH + gap);
			
		}
		
		public function scroll(val:int):void {
			if (_scrolling) return;
			_scrolling = true;
			var targetX:int = this.x - (gap + uiNeiBox.BOX_WIDTH) * val;
			targetX = limitTargetX(targetX);
			if (targetX == x) {
				scrollDone();
				return;
			}
			TweenNano.to(this, 0.3, {x: targetX, onComplete: scrollDone});
		}
		
		private function limitTargetX(val:int):int {
			if (val >= xOffset) {
				val = xOffset;
				if (_hitEdgeFunction != null) {
					_hitEdgeFunction(0);
				}
			}else if (val <= xOffset -_maxScroll) {
				val = xOffset - _maxScroll;
				if (_hitEdgeFunction != null) {
					_hitEdgeFunction(2);
				}
			}else {
					_hitEdgeFunction(1);
			}
			return val;
		}
		private function scrollDone():void {
			_scrolling = false;
		}
		
		public function setOffset():void {
			xOffset = this.x;
			scroll(0);
		}
		
		public function hitEdge(inFunction:Function):void {
			_hitEdgeFunction = inFunction;
		}
		
		public override function get height():Number {
			return uiNeiBox.BOX_HEIGHT;
		}
	}

}