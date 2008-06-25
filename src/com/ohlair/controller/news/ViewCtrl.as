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
package com.ohlair.controller.news
{
	import com.fake.controller.VBoxController;
	import com.fake.model.ResultSet;
	import com.ohlair.FakeApp;
	import com.ohlair.model.News;
	import com.ohlair.view.news.Entry;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class ViewCtrl extends VBoxController
	{
		public var chk_filter:CheckBox;
		public var txti_account:TextInput;

		public var cv_results:Canvas;
		public var vb_results:VBox;

		private var __currentPage:Number = 0;

		public function ViewCtrl()
		{
			super();
			Application.application.addEventListener(FlexEvent.APPLICATION_COMPLETE, __appComplete);
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
			addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
		}

		private function init(event:FlexEvent):void
		{
			txti_account.text = FakeApp.instance.settings.username;
		}

		private function onUpdateComplete(event:FlexEvent):void
		{
			FakeApp.instance.current = "news";
		}

		private function __appComplete(event:FlexEvent):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		public function submit(page:Number = 0):void
		{
			if (txti_account.text == "")
			{
				Alert.show("Enter an account name. Maybe your own?");
				return;
			}

			if (page == 0)
			{
				page = 1;
				vb_results.removeAllChildren();
			} else {
				scroll('end');
			}

			__currentPage += page;
			var args:Object = {page: __currentPage, sort: "created_at"};

			var news:News = new News();

			news.find(onResult, txti_account.text, args);
		}

		private function onResult(result:ResultSet):void
		{
			if (result.data == null)
			{
				Alert.show("There aint no news");
				return;
			}

			for each (var item:Object in result.response.result.message)
			{
				if (!chk_filter.selected || (chk_filter.selected && item.account.value != txti_account.text))
				{
					var entry:Entry = new Entry();
					entry.data = new News(item);
					vb_results.addChild(entry);
				}
			}

			FakeApp.instance.settings.save({username: txti_account.text});
		}

		private function scroll(direction:String = "down"):void
		{
			switch(direction)
			{
				case 'up':
					cv_results.verticalScrollPosition = cv_results.verticalScrollPosition - 40;
				break;
				case 'down':
					cv_results.verticalScrollPosition = cv_results.verticalScrollPosition + 40;
				break;
				case 'start':
					cv_results.verticalScrollPosition = 0;
				break;
				case 'end':
					cv_results.verticalScrollPosition = cv_results.maxVerticalScrollPosition;
				break;
			}
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			if (FakeApp.instance.current == "news")
			{
				switch(event.keyCode)
				{
					case Keyboard.ENTER:
						submit();
					break;

					case Keyboard.DOWN:
						if (event.shiftKey) {
							scroll('end');
						} else {
							scroll('down');
						}
					break;

					case Keyboard.UP:
						if (event.shiftKey) {
							scroll('start');
						} else {
							scroll('up');
						}
					break;

					case Keyboard.SPACE:
						if (event.shiftKey) {
							scroll('up');
						} else {
							scroll('down');
						}
					break;
				}
			}
		}
	}
}
