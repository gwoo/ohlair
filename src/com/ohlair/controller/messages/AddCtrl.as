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

	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.TextArea;
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class AddCtrl extends VBoxController
	{
		[Bindable] public var txta_body:TextArea;

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

		public function bodyClick():void {
			if (txta_body.enabled == false) {
				txta_body.text = '';
			}
			txta_body.enabled = true;
			FakeApp.instance.current = "Post";
		}

		public function submit():void
		{
			if (txta_body.text == "") {
				Alert.show("You forgot to say what you are doing");
				return;
			}

			txta_body.enabled = false;

			var message:Message = new Message();
			message.add(onAdd, {'message[body]': txta_body.text});
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
			}
			else
			{
				Alert.show(xmlResult..error, 'Error');
			}
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			if (FakeApp.instance.current == "Post" && (txta_body && txta_body.enabled == true && txta_body.text))
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