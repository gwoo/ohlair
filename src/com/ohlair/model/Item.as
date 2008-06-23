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
	public dynamic class Item extends Model
	{
		public var title:String;
		public var description:String;
		public var author:String;
		public var url:String;
		public var pubDate:String;
		public var tags:String;

		public function Item(data:Object = null)
		{
			super();

			if (data)
			{
				title = data.title;
				pubDate = String(data.pubDate).split("+").shift();
				author = data.source.value;
				url = data.source.url;

				var someTags:Array = String(data.description).split("tags:");
				if (someTags.length > 1) {
					tags = someTags.pop();
				}
			}
		}

	}
}