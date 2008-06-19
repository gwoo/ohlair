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
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import mx.containers.Panel;

	public class EntryCtrl extends Panel
	{
		public function EntryCtrl()
		{
			super();
		}

		public function link(url:String):void
		{
			navigateToURL(new URLRequest(url), "_new");
		}
	}
}