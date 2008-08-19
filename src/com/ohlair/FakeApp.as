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
	import com.adobe.air.notification.NotificationClickedEvent;
	import com.ohlair.config.Environment;
	import com.ohlair.controller.settings.IndexCtrl;
	import com.ohlair.model.Settings;
	import com.ohlair.view.settings.Index;

	import flash.display.NativeWindowResize;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.containers.HBox;
	import mx.containers.TitleWindow;
	import mx.containers.ViewStack;
	import mx.controls.LinkButton;
	import mx.controls.TabBar;
	import mx.core.Application;
	import mx.core.WindowedApplication;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.managers.CursorManagerPriority;
	import mx.managers.PopUpManager;

	public class FakeApp extends WindowedApplication
	{
		[Bindable] public var settings:Settings;
		[Bindable] public var current:String;

		public var user:Object;

		public var resizeBar:HBox;
		public var window:TitleWindow;
		public var resizeButton:LinkButton;
		public var tabs:TabBar;
		[Bindable] public var vs:ViewStack;

		[Embed("/assets/icons/moveCursor.png")]
  		private var moveCursor:Class;
  		private var __currentCursor:int;

		private static var _instance:FakeApp;
		public static function get instance():FakeApp {
			return _instance;
		}

		public function FakeApp()
		{
			super();
			_instance = this;

			this.settings = new Settings();

			addEventListener(FlexEvent.CREATION_COMPLETE, init);
			addEventListener(FlexEvent.PREINITIALIZE, onPreinitialize);
			Application.application.addEventListener(FlexEvent.APPLICATION_COMPLETE, onAppComplete);
		}

	    private function init(event:FlexEvent):void {
	    	resizeBar.addEventListener(MouseEvent.MOUSE_OVER, showMoveCursor);
	    	resizeBar.addEventListener(MouseEvent.MOUSE_DOWN, startMove);
	    	resizeBar.addEventListener(MouseEvent.MOUSE_UP, removeMoveCursor);
	    	resizeBar.addEventListener(MouseEvent.MOUSE_OUT, removeMoveCursor);
	    	resizeButton.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
	    	//var user:Object = settings.user();
	    }

		private function showMoveCursor(event:Event = null):void {
			__currentCursor = cursorManager.setCursor(moveCursor,
  				CursorManagerPriority.HIGH, 3, 2
  			);
  		}

		private function removeMoveCursor(event:Event = null):void {
			cursorManager.removeAllCursors();
		}

		private function resizeWindow(event:MouseEvent):void {
			stage.nativeWindow.startResize(NativeWindowResize.BOTTOM_RIGHT);
		}

	   	private function startMove(event:MouseEvent):void {
	   		showMoveCursor();
	    	stage.nativeWindow.startMove();
	    }

	    private function closeEvent(event:CloseEvent):void {
	       stage.nativeWindow.close();
	    }

		private function onPreinitialize(event:FlexEvent):void
		{
			var environment:Environment = new Environment();
		}

		private function onAppComplete(event:FlexEvent):void
		{
			current = "News";
			vs.visible = true;
			if (!FakeApp.instance.settings.oauth_token)
			{
				vs.visible = false;
				if (FakeApp.instance.settings.key && FakeApp.instance.settings.secret)
				{
					var settings:IndexCtrl = new IndexCtrl();
					settings.submit();
				}
				else
				{
					openSettings();
				}
			}
		}

		public function openSettings():void
		{
			vs.visible = false;
			var settings:Index = new Index();
			PopUpManager.addPopUp(settings, this);
			//PopUpManager.centerPopUp(settings);
			settings.move (0, 50);
		}

		public function tabChange(event:Event):void
		{
			if (event is NotificationClickedEvent)
			{
				current = "News";
				tabs.selectedIndex = 2;
				return;
			}

			current = ItemClickEvent(event).label;
		}
	}
}