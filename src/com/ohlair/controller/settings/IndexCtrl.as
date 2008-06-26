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
package com.ohlair.controller.settings
{
	import com.fake.model.ResultSet;
	import com.ohlair.FakeApp;
	import com.ohlair.model.OhConsumer;
	import com.ohlair.view.settings.VerifyAccess;
	import com.ohlair.view.settings.VerifyRequest;

	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;

	public class IndexCtrl extends TitleWindow
	{
		public var txti_username:TextInput;
		public var txti_key:TextInput;
		public var txti_secret:TextInput;

		public var btn_ok:Button;

		public var token:Object = {};

		public function IndexCtrl()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}

		public function init(event:FlexEvent):void
		{
			if (txti_username)
			{
				txti_username.text = FakeApp.instance.settings.username;
				txti_key.text = FakeApp.instance.settings.key;
				txti_secret.text = FakeApp.instance.settings.secret;
			}
		}

		public function close():void
		{
			PopUpManager.removePopUp(this);
		}

		public function submit():void
		{
			var data:Object;
			if (txti_username)
			{
				data = {
					username: txti_username.text,
					key: txti_key.text,
					secret: txti_secret.text
				};

				FakeApp.instance.settings.save(data);
			}

			data = FakeApp.instance.settings.vo;

			var consumer:OhConsumer = new OhConsumer();
			consumer.getRequestToken(onRequestToken, data);

		}

		private function onRequestToken(result:ResultSet):void
		{
			if (result.data)
			{
				close();

				var verifyRequest:VerifyRequest = new VerifyRequest();
				verifyRequest.token["oauth_token"] = result.data.oauth_token;
				verifyRequest.token["oauth_token_secret"] = result.data.oauth_token_secret;
				verifyRequest.data = "Click OK to visit Ohloh and verify your request";

				PopUpManager.addPopUp(verifyRequest, FakeApp.instance);
				PopUpManager.centerPopUp(verifyRequest);
			}
			else
			{
				Alert.show("Ouch, something went wrong. Better tell gwoo");
			}
		}

		public function closeVerifyRequest():void
		{
			close();

			var consumer:OhConsumer = new OhConsumer();
			consumer.getAuthorization(token);

			var verifyAccess:VerifyAccess = new VerifyAccess();
			verifyAccess.token = token;
			verifyAccess.data = "If you authorized Ohlair, click OK to get the access token";

			PopUpManager.addPopUp(verifyAccess, FakeApp.instance);
			PopUpManager.centerPopUp(verifyAccess);
		}

		public function closeVerifyAccess():void
		{
			var data:Object = FakeApp.instance.settings.vo;

			var consumer:OhConsumer = new OhConsumer();
			consumer.getAccessToken(onAccessToken, data, token);
		}

		private function onAccessToken(result:ResultSet):void
		{
			if (result.data)
			{
				close();
				FakeApp.instance.settings.save(result.data);
				Alert.show("Sweeeet, you should be good to go!");
			}
			else
			{
				Alert.show("Are you sure you authorized Ohlair?");
			}
		}
	}
}