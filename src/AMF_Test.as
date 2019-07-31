
package {
	import flash.display.Sprite;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	public class AMF_Test extends Sprite {
		private var myService:NetConnection
		
		public function AMF_Test(){
			this.init();
		}
		
		public function init():void {
			var gatewayUrl:String = "http://localhost/flashservices/gateway.php";
			var myResponder:Responder = new Responder(onResult, onFault);
			
			var params:Object = new Object();
			params.sMessage = "HI";
			
			myService = new NetConnection();
			myService.objectEncoding = ObjectEncoding.AMF0;
			myService.connect(gatewayUrl);
			
			myService.call("HelloWorld.say", myResponder, params);
		}
		
		private function onResult(result:Object):void {
			trace(result);
		}
		
		private function onFault(fault:Object):void {
			trace(fault);
		}
	}
}