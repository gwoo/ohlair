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
package com.ohlair.model
{
	import com.fake.model.Model;

	public dynamic class Message extends Model
	{

		public function Message()
		{
			super();
		}

		override protected function _service(method:String, args:Object = null):String
		{
			if (args.hasOwnProperty("id")) {
				return method + '/' + args.id + '/messages.rss';
			}
			return null;
		}
	}
}
