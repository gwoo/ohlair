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
package com.ohlair.controller.messages
{
	import com.fake.controller.VBoxController;
	import com.fake.model.ResultSet;
	import com.ohlair.FakeApp;
	import com.ohlair.model.Message;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.TextArea;
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class AddCtrl extends VBoxController
	{
		public var txta_body:TextArea;
		public var list_previous:DataGrid;

		public function AddCtrl()
		{
			super();
			data = new Array();
			Application.application.addEventListener(FlexEvent.APPLICATION_COMPLETE, __appComplete);
		}

		private function __appComplete(event:FlexEvent):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		public function submit():void
		{
			if (txta_body.text == "") {
				Alert.show("You forgot to say what you are doing");
				return;
			}
			var message:Message = new Message();

			var data:Object = FakeApp.instance.settings.vo;

			message.add(onAdd, data, {'message[body]': txta_body.text});
		}

		private function onAdd(result:ResultSet):void
		{
			if (result.data == null) {
				Alert.show("Doh! your post did not work");
				return;
			}
			var xmlResult:XML = new XML(result.data);
			if (xmlResult..status == 'success')
			{
				Alert.show("Nice!");

				if (!list_previous.dataProvider)
				{
					list_previous.dataProvider = new ArrayCollection();
				}
				ArrayCollection(list_previous.dataProvider).addItemAt({label: txta_body.text}, 0);

				txta_body.text = "";
			}
			else
			{
				Alert.show(xmlResult..error, 'Error');
			}
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			if (FakeApp.instance.current == "Post")
			{
				switch(event.keyCode)
				{
					case Keyboard.ENTER:
						submit();
					break;
				}
			}
		}
	}
}