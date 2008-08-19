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
	import com.fake.utils.CloneUtil;
	import com.ohlair.FakeApp;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;
	import org.iotashan.utils.URLEncoding;

	public class OhConsumer extends Model
	{
		public var site:String;

		public function OhConsumer()
		{
			site = "http://www.ohloh.net";
			connection = "oauth";
			super();
		}

		public function getRequestToken(listener:Function, consumerData:Object):void
		{
			var path:String = "/oauth/request_token";
			var data:Object = __getRequestData(path, consumerData);
			call(path, listener, data);
		}

		public function getAuthorization(tokenData:Object):void
		{
			var params:Array = [];
			for (var param:String in tokenData) {
				params.push(param + "=" + URLEncoding.encode(tokenData[param]));
			}
			navigateToURL(new URLRequest(site + "/oauth/authorize?" + params.join("&")), "_new");
		}

		public function getAccessToken(listener:Function, consumerData:Object, tokenData:Object):void
		{
			var path:String = "/oauth/access_token";
			var data:Object = __getRequestData(path, consumerData, tokenData);
			call(path, listener, data);
		}

		public function post(path:String, listener:Function, args:Object):void
		{
			var data:Object = FakeApp.instance.settings.vo;
			
			data["params"] = CloneUtil.clone(args);

			this.config = {
				dataFormat: "text",
				requestHeaders: new Array(
					__getRequestData(path, data, data, "header"),
					new URLRequestHeader("Content-type", "application/x-www-form-urlencoded")
				)
			};

			call(path, listener, args);
		}

		private function __getRequestData(path:String, consumerData:Object, tokenData:Object = null, type:String = "post"):Object
		{
			var token:OAuthToken = null;
			if (tokenData)
			{
				token = new OAuthToken(
					tokenData.oauth_token, tokenData.oauth_token_secret
				);
			}

			var consumer:OAuthConsumer = new OAuthConsumer(
				consumerData.key, consumerData.secret
			);

			var params:Object = null;
			if (consumerData.hasOwnProperty("params"))
			{
				params = consumerData.params;
			}

			var oAuthRequest:OAuthRequest = new OAuthRequest(URLRequestMethod.POST,
				site + path, params, consumer, token
			);

			var data:Object = oAuthRequest.buildRequest(new OAuthSignatureMethod_HMAC_SHA1(), type, site);
			return data;
		}
	}
}