package com.zl.oop 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Singleton 
	{
		private static var _instance:Singleton;
		public function Singleton() {
			
		}
		
		public static function getInstance():Singleton {
			if (Singleton._instance == null) {
				Singleton._instance = new Singleton();
				trace('Singleton instantiated');
			}else {
				trace('Singleton already exists');				
			}
			return Singleton._instance;
		}
		
	}

}