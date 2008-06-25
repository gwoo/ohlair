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
package com.ohlair.controller.tools
{
	import com.fake.controller.VBoxController;
	import com.fake.model.ResultSet;
	import com.ohlair.FakeApp;
	import com.ohlair.model.Tool;
	
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.ObjectProxy;

	public class ViewCtrl extends VBoxController
	{
		[Bindable] public var key:String;
		[Bindable] public var services:Array;

		public var service:ComboBox;
		public var vb_response:VBox;
		public var form_options:Form;


		public function ViewCtrl()
		{
			super();
			addEventListener(FlexEvent.INITIALIZE, init);
		}

		private function init(event:FlexEvent):void
		{
			FakeApp.instance.current = "Tools";
			
			var tool:Tool = new Tool();
			 services = tool.services;
		}

		public function change(event:Event):void
		{
			var tool:Tool = new Tool();

			if (event.currentTarget.selectedItem) {
				form_options.removeAllChildren();

				for each(var option:String in tool.options(event.currentTarget.selectedItem.data))
				{
					var formItem:FormItem = new FormItem();
					var input:TextInput = new TextInput();
					formItem.label = option;
					formItem.addChild(input);
					form_options.addChild(formItem);
				}
			}
		}

		public function submit():void
		{
			//var data:Object = FakeApp.instance.cookie.data;
			var data:Object = FakeApp.instance.settings;

			if (!data.hasOwnProperty("key") && !data.key) {
				Alert.show("You need to add you API key");
				//FakeApp.instance.openSettings();
				return;
			}

			var key:String = data.key;

			var tool:Tool = new Tool();

			var fields:Array = findByType([TextInput], form_options);
			var params:Array = [];

			for each(var field:TextInput in fields)
			{
				params.push(field.text);
			}

			tool.call(service.selectedItem.data, onResult, {params: params , api_key : key, v:1});
		}

		protected function onResult(result:ResultSet):void
		{
			if (result.data == null) {
				Alert.show("There were no results for your query");
				return;
			}
			vb_response.removeAllChildren();

			if (result.response.status == 'success')
			{
				vb_response.addChild(handleResponse(result.response.result));
			}
			else
			{
				Alert.show(result.response.error, 'Error');
			}
		}

		protected function handleResponse(response:Object, parent:TextArea = null):UIComponent
		{
			var text:TextArea = new TextArea();
			text.percentWidth = 100;
			text.percentHeight = 100;
			for (var key:* in response)
			{
				var value:* = response[key];

				if (value is ObjectProxy)
				{
					if (parent)
					{
						handleResponse(value, parent);
					}
					else
					{
						handleResponse(value, text);
					}
				}
				else
				{
					if (parent)
					{
						parent.text += key + ":" + value +"\n";
					}
					else
					{
						text.text += key + ": " + value +"\n";
					}
				}
			}
			return text;
		}
	}
}