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
package com.ohlair.config
{
	import com.fake.model.datasources.ConnectionManager;
	import com.fake.utils.ConfigManager;
	import com.fake.utils.FakeEvent;

	public class Environment
	{
		public function Environment()
		{
			ConfigManager.instance.app = "ohlair";
			ConfigManager.instance.environment = "release";
			loaded(null);
		}

		protected function loaded(event:FakeEvent):void
		{
			switch(ConfigManager.instance.environment)
			{
				case 'dev':
					ConnectionManager.instance.create('default',{
						endpoint: "http://www.ohloh.net/", datasource: "Http", debug: true
					});

					//the oauth setting does not have a trailing slash
					ConnectionManager.instance.create('oauth',{
						endpoint: "http://localhost:57277", datasource: "Loader", debug: true,
						dataFormat: "variables", method: "POST"
					});

					//this is a test server to term.ie but need to remember to adjust the calls
					ConnectionManager.instance.create('oauth-test',{
						endpoint: "http://localhost:57989", datasource: "Loader", debug: true,
						dataFormat: "variables", method: "POST"
					});
				break;
				case 'release':
					ConnectionManager.instance.create('default',{
						endpoint: "http://www.ohloh.net/", datasource: "Http"
					});

					//the oauth setting does not have a trailing slash
					ConnectionManager.instance.create('oauth',{
						endpoint: "http://www.ohloh.net", datasource: "Loader",
						dataFormat: "variables", method: "POST"
					});
				break;
			}

		}
	}
}