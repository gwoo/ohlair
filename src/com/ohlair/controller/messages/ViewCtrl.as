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
	import com.dougmccune.containers.CoverFlowContainer;
	import com.fake.controller.VBoxController;
	import com.fake.model.ResultSet;
	import com.fake.utils.SetUtil;
	import com.ohlair.model.Message;
	import com.ohlair.view.messages.Item;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class ViewCtrl extends VBoxController
	{
		[Bindable] public var total:Number;

		public var type:ComboBox;
		public var search:ComboBox;

		[Bindable] public var coverflow:CoverFlowContainer;

		public function ViewCtrl()
		{
			super();
			Application.application.addEventListener(FlexEvent.APPLICATION_COMPLETE, __appComplete);
		}

		private function __appComplete(event:FlexEvent):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}


		public function change(event:Event):void
		{
			if (event.currentTarget.selectedItem && event.currentTarget.selectedItem.data) {
				type.selectedItem = event.currentTarget.selectedItem.data;
			}
		}

		public function prev():void
		{
			if (coverflow.selectedIndex == 0) {
				coverflow.selectedIndex = total - 1;
			} else {
				coverflow.selectedIndex = coverflow.selectedIndex - 1;
			}
		}

		public function next():void
		{
			if (coverflow.selectedIndex == (total - 1)) {
				coverflow.selectedIndex = 0;
			} else {
				coverflow.selectedIndex = coverflow.selectedIndex + 1;
			}
		}

		public function submit():void
		{
			var message:Message = new Message();

			if (search.text) {
				if (type.selectedItem.label == 'Projects')
				{
					message.projects(onResult, {id : search.text});
				}
				else if (type.selectedItem.label == 'Accounts')
				{
					message.accounts(onResult, {id : search.text});
				}

				var searchObj:Object = {label : search.text, data: type.selectedItem};

				if(SetUtil.exists(search.dataProvider.source, searchObj.label, "label") == false) {
					search.dataProvider.source.push(searchObj);
					search.rowCount = search.dataProvider.source.length;
				}
			}
			else
			{
				Alert.show("We need a project or account.", 'No can do');
			}

		}

		protected function onResult(result:ResultSet):void
		{
			if (result.data == null)
			{
				Alert.show("Sorry we could find anything.", 'Try Again');
				search.dataProvider.source.pop();
				search.rowCount--;
				return;
			}

			data = result.rss.channel;
			total = data.item.source.length;

			coverflow.removeAllChildren();

			for each(var item:Object in data.item)
			{
				var message:Item = new Item();
				message.data = item;

				message.data.header = String(item.description).split("tags:").pop();
				message.data.pubDate = String(item.pubDate).split("+").shift();
				message.data.author = item.source.value;
				message.data.url = item.source.url;
				coverflow.addChild(message);
			}
		}

		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.RIGHT:
					next();
				break;

				case Keyboard.LEFT:
					prev();
				break;
				case Keyboard.ENTER:
					submit();
				break;
			}
		}
	}
}
