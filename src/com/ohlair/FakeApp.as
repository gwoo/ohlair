/* SVN FILE: $Id:$ */
package com.ohlair
{
	import com.ohlair.config.Environment;
	import com.ohlair.view.settings.Index;
	
	import flash.net.SharedObject;
	
	import mx.core.WindowedApplication;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.managers.PopUpManager;

	public class FakeApp extends WindowedApplication
	{
		[Bindable] public var cookie:SharedObject = SharedObject.getLocal("cookie");
		
		private static var _instance:FakeApp;
		public static function get instance():FakeApp {
			return _instance;
		}

		public function FakeApp()
		{
			super();
			_instance = this;

			addEventListener(FlexEvent.PREINITIALIZE, onPreinitialize);
			addEventListener(FlexEvent.PREINITIALIZE, onCreationComplete);
		}
		
		public function onPreinitialize(event:FlexEvent):void
		{
			var environment:Environment = new Environment();
		}		
		
		private function onCreationComplete(event:FlexEvent):void
		{

		}
		
		public function openSettings():void
		{
			var settings:Index = new Index();
			PopUpManager.addPopUp(settings, this);
			PopUpManager.centerPopUp(settings);
		}
		
		public function tabChange(event:IndexChangedEvent):void
		{
			
		}
	}
}