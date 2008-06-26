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
	import com.adobe.air.notification.Notification;
	import com.adobe.air.notification.NotificationClickedEvent;
	import com.adobe.air.notification.Purr;
	import com.fake.controller.VBoxController;
	import com.fake.model.ResultSet;
	import com.ohlair.FakeApp;
	import com.ohlair.model.News;
	import com.ohlair.view.news.Entry;

	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.LinkButton;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class ViewCtrl extends VBoxController
	{
		public var chk_filter:CheckBox;
		public var txti_account:TextInput;

		public var cv_results:Canvas;
		[Bindable] public var vb_results:VBox;

		public var btn_timer:LinkButton;
		public var timerCount:uint = 60;
		[Bindable] public var time:uint;

		private var __currentPage:uint = 0;
		private var __timer:Timer;
		private var __previous:Array = [];
		private var __purr:Purr = new Purr(1);

		public function ViewCtrl()
		{
			super();
			Application.application.addEventListener(FlexEvent.APPLICATION_COMPLETE, __appComplete);
			addEventListener(FlexEvent.CREATION_COMPLETE, init);

			__timer = new Timer(1000);//every second
			__timer.addEventListener(TimerEvent.TIMER, handleTimer);
		}

		private function init(event:FlexEvent):void
		{
			__timer.start();
			txti_account.text = FakeApp.instance.settings.username;
		}

		private function __appComplete(event:FlexEvent):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private function handleTimer(event:TimerEvent):void
		{
			var som:Number = __timer.currentCount;

			if (__timer.currentCount == timerCount)
			{
				submit();
				time = timerCount;
				__timer.reset();
				__timer.start();
			}
			time = timerCount -__timer.currentCount;
		}

		public function toggleTimer():void
		{
			if (__timer.running)
			{
				btn_timer.toolTip = "click to start";
				__timer.stop();
			}
			else
			{
				btn_timer.toolTip = "click to stop";
				__timer.start();
			}
		}

		public function submit(page:int = 0):void
		{
			if (txti_account.text == "")
			{
				Alert.show("Enter an account name. Maybe your own?");
				return;
			}

			if (page == -1) {
				page = 0;
				__currentPage = 1;
				__previous = new Array();
				vb_results.removeAllChildren();
			} else if (page == 0) {
				__currentPage = 1;
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
				Alert.show("Apprently, nothing new has happend.");
				return;
			}

			for each(var item:Object in result.response.result.message)
			{
				if (!chk_filter.selected
					|| (chk_filter.selected && item.account.value != txti_account.text)
					&& __previous.indexOf(item.id) == -1
				)
				{
					var entry:Entry = new Entry();
					entry.data = new News(item);
					vb_results.addChild(entry);

					if (stage.nativeWindow.active == false)
					{
						var note:Notification = new Notification(entry.data.author, entry.data.body);
						note.addEventListener(NotificationClickedEvent.NOTIFICATION_CLICKED_EVENT, FakeApp.instance.tabChange);
						note.addEventListener(NotificationClickedEvent.NOTIFICATION_CLICKED_EVENT, clearNotificationQ);
						__purr.addNotification(note);
					}

					__previous.push(item.id);
				}
			}
			vb_results.visible = true;
			FakeApp.instance.settings.save({username: txti_account.text});
		}

		private function clearNotificationQ(event:NotificationClickedEvent):void
		{
			__purr.clear(null);
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
			if (FakeApp.instance.current == "News")
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
