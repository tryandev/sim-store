package com.zl.utils 
{
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author 
	 */
	public class WebTrack 
	{
		private static var _instance:WebTrack;
		public static function getInstance():WebTrack {
			if (_instance == null) 
				_instance = new WebTrack();
			return _instance;
		}
		
		public function WebTrack() {
			if (_instance) throw Error('multiple Singleton');
		}
		
		public function track(value:String):void {
			trace('WebTrack: ' + value);
			try {
				ExternalInterface.call('webTrack', value);
			}catch (err:Error) {
				
			}
		}
	}

}