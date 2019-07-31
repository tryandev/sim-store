package {
	import com.stimuli.loading.BulkLoader;
	import com.stimuli.loading.BulkProgressEvent;
	import flash.display.Sprite
	import flash.system.Security;
	import com.game.containers.Game;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.events.Event;
	public class Main extends Sprite {
		
		//[Embed(source='assets/xml/fl_goods.mmf', mimeType='application/octet-stream')]
		//private static const cxml:Class
		
		//private var bl:BulkLoader = new BulkLoader('xxx');
		//private var path:String = '../src/assets/xml/cfg_item.mmf';
		public function Main() {
			Security.allowDomain('*');
			addChild(new Game());
			/*bl.add(path, { type:BulkLoader.TYPE_BINARY } );
			bl.addEventListener(BulkProgressEvent.COMPLETE, blFinish, false, 0, true);
			bl.start();*/
		}
		/*private function blFinish(e:Event = null):void {
			trace('blFinish()');
			var ba:ByteArray = bl.getContent(path);
			var myXML:XML = decode(ba)
			trace(myXML);
			System.setClipboard(myXML);
		}
		private function decode(param1:ByteArray) : XML
        {
            var _loc_2:String = null;
            var _loc_3:XML = null;
            param1.position = 0;
            if (param1.bytesAvailable > 0)
            {
                param1.uncompress();
                _loc_2 = param1.readUTFBytes(param1.bytesAvailable);
                _loc_3 = new XML(_loc_2);
                return _loc_3;
            }
            return null;
        }*/
		
	}
}