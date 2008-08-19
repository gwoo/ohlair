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
	import mx.containers.ControlBar;
	import mx.containers.VBox;
	import mx.containers.ViewStack;
	import mx.controls.Alert;
	import mx.controls.LinkButton;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class IndexCtrl extends VBoxController
	{
		public var username:String;

		[Bindable] public var account_form:ControlBar;
		[Bindable] public var news_results:ViewStack;
		[Bindable] public var vb_news:VBox;
		[Bindable] public var vb_me:VBox;
		[Bindable] public var vb_all:VBox;

		public var txti_account:TextInput;

		public var btn_timer:LinkButton;
		public var timerCount:uint = 60;

		[Bindable] public var time:uint;
		[Bindable] public var status:String;

		private var __currentPage:uint = 0;
		private var __timer:Timer;
		private var __previous:Array = [];
		private var __purr:Purr = new Purr(1);

		public function IndexCtrl()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
			Application.application.addEventListener(FlexEvent.APPLICATION_COMPLETE, __appComplete);
			__timer = new Timer(1000);//every second
			__timer.addEventListener(TimerEvent.TIMER, handleTimer);
		}

		private function init(event:FlexEvent):void
		{
			__timer.start();
			username = FakeApp.instance.settings.username;
			if (!username) {
				account_form.visible = true;
				account_form.includeInLayout = true;
			}
			submit(-1);
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
			if (txti_account && txti_account.text) {
				FakeApp.instance.settings.save({username: txti_account.text});
				username = txti_account.text;
				account_form.visible = false;
				account_form.includeInLayout = false;
			}

			if (username == "")
			{
				Alert.show("Enter an account name. Maybe your own?");
				return;
			}

			if (page == -1) {
				page = 0;
				__currentPage = 1;
				__previous = [];
				vb_news.removeAllChildren();
				vb_me.removeAllChildren();
				vb_all.removeAllChildren();
			} else if (page == 0) {
				__currentPage = 1;
			} else {
				scroll('end');
			}

			__currentPage += page;
			var args:Object = {page: __currentPage, sort: "created_at"};

			var news:News = new News();
			news.find(onResult, username, args);
		}

		private function onResult(result:ResultSet):void
		{
			if (result.data == null)
			{
				status = "nothing new";
				return;
			}

			var hasPrevious:Boolean = (__previous.length > 0) ? true: false;

			for each(var item:Object in result.response.result.message)
			{
				var isPrevious:int = __previous.indexOf(item.id);
				if (isPrevious == -1)
				{
					var isUser:Boolean = (item.account.value == username) ? true : false;

					var entry:Entry = new Entry();
					entry.data = new News(item);

					var entryClone:Entry = new Entry();
					entryClone.data = entry.data;

					if (hasPrevious)
					{
						if (isUser == true) {
							vb_me.addChildAt(entry, 0);
						} else {
							vb_news.addChildAt(entry, 0);
						}

						vb_all.addChildAt(entryClone, 0);
					}
					else
					{
						if (isUser == true) {
							vb_me.addChild(entry);
						} else {
							vb_news.addChild(entry);
						}
						vb_all.addChild(entryClone);
					}

					if (isUser == false && stage.nativeWindow.active == false)
					{
						var note:Notification = new Notification(entry.data.author, entry.data.body);
						note.addEventListener(NotificationClickedEvent.NOTIFICATION_CLICKED_EVENT, clearNotificationQ);
						__purr.addNotification(note);
					}

					__previous.push(item.id);
				}
			}

			status = "updated";
			vb_news.visible = true;
			vb_me.visible = true;
			vb_all.visible = true;

			news_results.selectedIndex = 0;
		}

		private function clearNotificationQ(event:NotificationClickedEvent):void
		{
			__purr.clear(null);
		}

		private function scroll(direction:String = "down"):void
		{
			var selectedResults:Canvas = news_results.selectedChild as Canvas;

			switch(direction)
			{
				case 'up':
					selectedResults.verticalScrollPosition = selectedResults.verticalScrollPosition - 40;
				break;
				case 'down':
					selectedResults.verticalScrollPosition = selectedResults.verticalScrollPosition + 40;
				break;
				case 'start':
					selectedResults.verticalScrollPosition = 0;
				break;
				case 'end':
					selectedResults.verticalScrollPosition = selectedResults.maxVerticalScrollPosition;
				break;
			}
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if (FakeApp.instance.current == "News")
			{
				switch(event.keyCode)
				{
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
