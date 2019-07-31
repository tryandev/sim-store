package com.game.global 
{
	import away3d.core.project.MovieClipSpriteProjector;
	import away3d.events.Loader3DEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.Event
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class MCLoader extends EventDispatcher {
		public static const COMPLETE:String = Event.COMPLETE;
		private var _started:Boolean;
		private static var _instance:MCLoader;
		
		private var _classesLoaded:Dictionary;
		private var _loaders:Dictionary;
		private var _callbacks:Dictionary;
		private var _queue:Vector.<String>
		
		private var _currentKey:String;
		
		public static function getInstance():MCLoader {
			if (_instance == null) {
				_instance = new MCLoader();
			}
			return _instance;
		}
		
		public function MCLoader():void {
			if (_instance != null) throw new Error();
			_classesLoaded = new Dictionary();
			_loaders = new Dictionary();
			_callbacks = new Dictionary();
			_queue = new Vector.<String>();
		}
		public function add(key:String, callback:Function):void {
			if (!_callbacks[key]) {
				_callbacks[key] = [];
			}
			
			if (_classesLoaded[key] != null) {
				callback();
				return;
			}
			
			_callbacks[key].push(callback);
			
			if (_loaders[key] != null) {
				return ;
			}
			_loaders[key] = new Loader();
			_queue.push(key);
		}
		
		public function start():void {
			//trace(this +":start: started");
			if (_started) return;
			_started = true;
			loadNext();
		}
		private function loadNext():void {
			if (_queue.length == 0) {
				_started = false;
				return;
			}
			var key:String = _queue.shift();
			var loader:Loader = new Loader()
			_loaders[key] = loader;
			_currentKey = key;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadNextComplete, false, 0, true);
			loader.load(new URLRequest(key));
			//trace(this +":loadNext: " + key);
		}
		private function loadNextComplete(e:Event):void {
			var key:String = _currentKey;
			var className:String = 'mc';
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			var loader:Loader = loaderInfo.loader;
			_classesLoaded[key] = loader.contentLoaderInfo.applicationDomain.getDefinition(className);
			var callback:Function
			while (_callbacks[key].length) {
				callback = _callbacks[key].pop()
				callback();
			}
			delete _callbacks[key];
			delete _loaders[key];
			//trace(this +":loadNextComplete: calling back " + key);
			loadNext();
		}
		
		public function getMC(key:String):MovieClip {
			var keyClass:Class = _classesLoaded[key];
			
			var n:int
			var key:*;
			n = 0; for (key in _classesLoaded) { n++; }
			//trace("_classesLoaded: " + n);
			n = 0; for (key in _callbacks) { n++; }
			//trace("_callbacks: " + n);
			n = 0; for (key in _loaders) { n++; }
			//trace("_loaders: " + n);
			
			return new keyClass as MovieClip;
		}
	}
}