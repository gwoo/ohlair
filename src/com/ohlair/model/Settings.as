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
	import com.fake.model.ResultSet;
	
	import flash.net.SharedObject;

	public class Settings extends Model
	{
		public var username:String;

		public var key:String;
		public var secret:String;

		public var oauth_token:String;
		public var oauth_token_secret:String;

		private var cookie:SharedObject = SharedObject.getLocal("cookie");

		public function Settings()
		{
			super();
			// You can put you own information below or allow the Settings panel to open
			this.key = "b5e8ceeb67ec93ed97bf3b4830da6f39bbc7ec90";
			this.secret = "UxhXK691aJn02639gSlDelEsEJZichrTf27D3gfxoYU";

			for (var prop:* in vo)
			{
				if (!this[prop] && cookie.data.hasOwnProperty(prop))
				{
					this[prop] = cookie.data[prop];
				}
			}
		}

		public function save(data:Object):void
		{
			ro = data;

			for (var key:* in data)
			{
				cookie.data[key] = data[key];
			}
		}
		
		public function user(result:ResultSet = null):Object
		{
			var consumer:OhConsumer = new OhConsumer();
			consumer.post("/accounts/me.xml", user, {});
			
			return result;
		}
	}
}