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
			ConfigManager.instance.environment = "local";
			loaded(null);
		}

		protected function loaded(event:FakeEvent):void
		{
			switch(ConfigManager.instance.environment)
			{
				case 'local':
					ConnectionManager.instance.create('default',
						{endpoint: "http://www.ohloh.net/", datasource: "Http"}
					);
				break;
			}

		}
	}
}