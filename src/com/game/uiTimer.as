package com.game 
{
	import away3d.blockers.ConvexBlock;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	public class uiTimer extends Sprite{
		public static const DONE:String = "uiTimerDone";
		public static const PROGRESS:String = 'uiTimerProgess';
		
		private var _totalMili:Number;
		private var _percentStart:Number;
		private var _updateInterval:Number;
		
		private var _startTime:Number;
		private var _endTime:Number;
		
		private var _date:Date;
		private var _interval:uint;
		
		//private var _destroyed:Boolean;
		
		public var _rand:Number = Math.random();
		
		public function uiTimer(totalSeconds:Number = 60, percentStart:Number = 0, progressInterval:Number = 1000) {
			_totalMili = totalSeconds * 1000;
			_percentStart = percentStart;
			_updateInterval = progressInterval;
		}
		public function start():void {
			_date = new Date();
			_startTime = _date.valueOf() - _percentStart * _totalMili;
			_endTime = _startTime + _totalMili;
			_interval = setInterval(_enterFrame, _updateInterval);
		}
		
		public function stop():void {
			clearInterval(_interval);
		}
		
		public function destroy():void {
			//trace('uiTimer destroy ' + _rand);
			//_destroyed = true;
			clearInterval(_interval);
			stop();
		}
		
		public function get percent():Number {
			var now:Number = new Date().valueOf();
			var  _percent:Number = Math.abs(now - _startTime) / Math.abs(_endTime - _startTime);
			if (_percent >= 1) return 1;
			if (_percent <= 0) return 0;
			return _percent;
		}
		
		private function _enterFrame(e:Event = null):void {
			//if (_destroyed) return;
			//trace('frame ' + Math.random());
			dispatchEvent(new Event(PROGRESS));
			if (percent >= 1) {
				stop();
				dispatchEvent(new Event(DONE));
			}
		}
	}

}