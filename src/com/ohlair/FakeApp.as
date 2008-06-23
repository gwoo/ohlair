/**
 * Description
 *
 * Ohlair
 * Copyright 2008, Garrett Woodworth
 *
 * Licensed under The MIT License, http://www.opensource.org/licenses/mit-license.php
 * Redistributions of files must retain the above copyright notice.
 *
 */
package com.ohlair
{
	import com.ohlair.config.Environment;
	import com.ohlair.view.settings.Index;

	import flash.net.SharedObject;

	import mx.core.Application;
	import mx.core.WindowedApplication;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.managers.PopUpManager;

	public class FakeApp extends WindowedApplication
	{
		[Bindable] public var cookie:SharedObject = SharedObject.getLocal("cookie");

		public var current:String;

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
			Application.application.addEventListener(FlexEvent.APPLICATION_COMPLETE, onAppComplete);
		}

		private function onPreinitialize(event:FlexEvent):void
		{
			var environment:Environment = new Environment();
		}

		private function onCreationComplete(event:FlexEvent):void
		{

		}

		private function onAppComplete(event:FlexEvent):void
		{
			if (!cookie.data.hasOwnProperty("oauth_token"))
			{
				openSettings();
			}
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