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
	import mx.controls.TextArea;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.events.ValidationResultEvent;
	import mx.validators.Validator;

	public class AddCtrl extends VBoxController
	{

		[Bindable] public var txta_body:TextArea;
		public var bodyValidator:Validator;

		public function AddCtrl()
		{
			super();
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
			message.add(onAdd, FakeApp.instance.cookie.data, {'message[body]': txta_body.text});
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
				txta_body.text = "";
				Alert.show("Nice!");
			}
			else
			{
				Alert.show(xmlResult..error, 'Error');
			}
		}

		protected function onKeyDown(event:KeyboardEvent):void
		{
			if (FakeApp.instance.current == "add")
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