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
	import com.fake.controller.CanvasController;
	import com.ohlair.FakeApp;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.containers.ViewStack;
	import mx.controls.LinkButton;
	import mx.core.Container;
	import mx.events.FlexEvent;

	public class IndexCtrl extends CanvasController
	{
		public var vs:ViewStack;
		public var btn_switch:LinkButton;

		public function IndexCtrl()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, handleSwitch);
		}

		public function handleSwitch(event:Event):void
		{
			if (event is MouseEvent)
			{
				if (vs.selectedIndex == 0)
				{
					vs.selectedIndex = 1;
				}
				else
				{
					vs.selectedIndex = 0;
				}
			}

			var next:Container;
			if (vs.selectedIndex == 0)
			{
				next = vs.getChildAt(1) as Container;
				FakeApp.instance.current = "view";
			}
			else
			{
				next = vs.getChildAt(0) as Container;
				FakeApp.instance.current = "add";
			}

			btn_switch.label = next.label;
		}
	}
}
