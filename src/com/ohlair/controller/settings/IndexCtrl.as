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
package com.ohlair.controller.settings
{
	import com.ohlair.FakeApp;
	
	import mx.containers.TitleWindow;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	public class IndexCtrl extends TitleWindow
	{
		public var txti_username:TextInput;
		public var txti_key:TextInput;

		public function IndexCtrl()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		public function init(event:FlexEvent):void
		{
			if (FakeApp.instance.cookie.data.hasOwnProperty("username"))
			{
				txti_username.text = FakeApp.instance.cookie.data.username;
			}
			if (FakeApp.instance.cookie.data.hasOwnProperty("key"))
			{
				txti_key.text = FakeApp.instance.cookie.data.key;
			}
		}
		
		public function close():void
		{
			PopUpManager.removePopUp(this);
		}
		
		public function submit():void
		{
			FakeApp.instance.cookie.data.username = txti_username.text;
			FakeApp.instance.cookie.data.key = txti_key.text;
			close();
		}
	}
}
