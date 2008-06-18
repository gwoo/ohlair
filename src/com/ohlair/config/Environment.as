/* SVN FILE: $Id:$*/
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
					ConnectionManager.instance.create('google',
						{endpoint: "http://www.google.com/group/", datasource: "Http"}
					);
				break;

				case 'dev':
					ConnectionManager.instance.create('default',
						{endpoint: "http://localhost", datasource: "Amf"}
					);
				break;

				case 'beta':
					ConnectionManager.instance.create('default',
						{endpoint: "http://localhost", datasource: "Amf"}
					);
				break;

				case 'www':
					ConnectionManager.instance.create('default',
						{endpoint: "http://localhost", datasource: "Amf"}
					);
				break;
			}

		}
	}
}