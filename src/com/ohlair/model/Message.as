/* SVN FILE: $Id$ */
package com.ohlair.model
{
	import com.fake.model.Model;

	public dynamic class Message extends Model
	{
		public function Message()
		{

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
