package com.game.items {
	
	import com.game.global.GlobalObjects;
	import com.game.uiTimer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.game.global.MCLoader;
	import flash.events.MouseEvent
	import flash.filters.ColorMatrixFilter;
	
	public class MapItemCrop extends Sprite {
		public static const STATUS_0_GROWING:int 	= 0;
		public static const STATUS_1_RIPE:int		= 1;
		public static const STATUS_2_WITHERED:int 	= 2;
		public static const STATUS_3_REVIVED:int 	= 3;
		
		private var _mcURL:String;
		
		private var _uiTimer:uiTimer;
		private var _mc:MovieClip;
		
		private var _destroyed:Boolean;
		
		private var _status:int;
		private var _prepareTime:int;
		
		
		public function MapItemCrop(mcURL:String, secondsTotal:int, doneRatio:Number, inStatus:int = 0) {
			status = inStatus;
			_prepareTime = secondsTotal;
			if (status < STATUS_2_WITHERED) {
				_uiTimer =  new uiTimer(secondsTotal, doneRatio);
				_uiTimer.addEventListener(uiTimer.PROGRESS, progress, false, 0, true);
				_uiTimer.addEventListener(uiTimer.DONE, timerDone, false, 0, true);
				_uiTimer.start();
			}
			_mcURL = mcURL;
			
			MCLoader.getInstance().add(_mcURL, mcLoaded);
			MCLoader.getInstance().start();
		}
		
		public function actionExecute():void { }
		public function actionEnqueue():void { }
		public function actionPrompt():void { }
		
		public function actable():Boolean {
			if (_status != STATUS_0_GROWING) {
				return true;
			}
			return false;
		}
		
		private function mouseClickHandle(e:Event):void { 	/*dispatchEvent(new Event(ITEM_MOUSE_CLICK));	if (_map) { _map.itemMouseEvent(this, e); }*/}
		private function mouseOverHandle(e:Event):void { 	/*dispatchEvent(new Event(ITEM_MOUSE_OVER));	if (_map) { _map.itemMouseEvent(this, e); }*/}
		private function mouseOutHandle(e:Event):void { 	/*dispatchEvent(new Event(ITEM_MOUSE_OUT));		if (_map) { _map.itemMouseEvent(this, e); }*/}

		private function mcLoaded():void {
			//trace(this + " mcLoaded")
			if (_destroyed) {
				return;
			}
			if (!_mc) {
				_mc = MCLoader.getInstance().getMC(_mcURL);
				_mc.addEventListener(MouseEvent.CLICK,		mouseClickHandle, false, 0, true);
				_mc.addEventListener(MouseEvent.MOUSE_OVER,	mouseOverHandle, false, 0, true);
				_mc.addEventListener(MouseEvent.MOUSE_OUT,	mouseOutHandle, false, 0, true);
				addChild(_mc);
			}
			progress(null);
		}
		
		private function timerDone(e:Event):void {
			//trace('uiTimer Done');
			if (_uiTimer){
				_uiTimer.removeEventListener(uiTimer.PROGRESS, progress, false);
				_uiTimer.removeEventListener(uiTimer.DONE, timerDone, false);
				_uiTimer.destroy();
			}
			
			if (status == STATUS_0_GROWING) {
				status = STATUS_1_RIPE;
				_uiTimer = new uiTimer(_prepareTime,0);
				_uiTimer.addEventListener(uiTimer.PROGRESS, progress, false, 0, true);
				_uiTimer.addEventListener(uiTimer.DONE, timerDone, false, 0, true);
				_uiTimer.start();
			}else if (status == STATUS_1_RIPE) {
				status = STATUS_2_WITHERED;
			}
		}
		
		private function progress(e:Event):void {
			if (_mc) {
				var mcSub:MovieClip = _mc.getChildAt(0) as MovieClip;
				var numFrames:int = mcSub.totalFrames
				if(status == STATUS_0_GROWING) {
					mcSub.stop();
					mcSub.gotoAndStop(Math.floor(_uiTimer.percent * (numFrames - 1)) + 1);
					//trace('preparing.percent: ' + _uiTimer.percent +"\t" + (_uiTimer.percent * (numFrames - 1)) + " " + _uiTimer._rand + " " + parent);
				}else if (mcSub.currentFrame != numFrames) {
					mcSub.gotoAndStop(numFrames);
					//trace('ready.percent: ' + _uiTimer.percent +"\t" + (_uiTimer.percent * (numFrames - 1)) + " " + _uiTimer._rand + " " + parent);
				}
			}
		}
		
		public function destroy():void {
			//trace('MapItemCrop destroy');
			_destroyed =  true;
			if (_mc) {
				_mc.removeEventListener(MouseEvent.CLICK,		mouseClickHandle, false);
				_mc.removeEventListener(MouseEvent.MOUSE_OVER,	mouseOverHandle, false);
				_mc.removeEventListener(MouseEvent.MOUSE_OUT,	mouseOutHandle, false);
				removeChild(_mc);
				_mc = null;				
			}
			if (_uiTimer) {
				_uiTimer.removeEventListener(uiTimer.DONE, timerDone, false);
				_uiTimer.removeEventListener(uiTimer.PROGRESS, progress, false);
				_uiTimer.destroy();
				_uiTimer = null;
			}
		}
		
		public function sellPrompt():void {
			this.destroy();
		}
		
		public function get status():int {
			return _status;
		}
		
		public function set status(value:int):void {
			_status = value;
			if (_status == STATUS_2_WITHERED) {
				this.filters = [new ColorMatrixFilter(
					[
						0.2225, 0.7169, 0.0606, 0, 0,
						0.2225, 0.7169, 0.0606, 0, 0,
						0.2225, 0.7169, 0.0606, 0, 0,
						0, 0, 0, 1, 0
					]
				)];
			}else {
				this.filters = null;
			}
		}
		
	}

}