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

	[Bindable]
	public dynamic class News extends Model
	{
		public var gravatar:String;
		public var body:String;
		public var date:String;
		public var url:String;
		public var author:String;

		public function News(data:Object = null)
		{
			super();
			if (data)
			{
				gravatar = data.avatar.uri;
				body = data.body;
				date = data.created_at;
				url = data.account.uri;
				author = data.account.value;
			}

		}


		public function find(listener:Function, account:String, args:Object=null):void
		{
			call("accounts/" + account + "/news.xml", listener, args);
		}

	}
}