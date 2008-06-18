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

	public dynamic class Tool extends Model
	{
		public var services:Array = [
			{label: 'Account', data: '/accounts/{account_id}.xml'},
			{label: 'AccountByHash', data: '/accounts/{email_md5_hash}.xml'},
			{label: 'Accounts', data: '/accounts.xml'},
			{label: 'ActivityFacts', data: '/projects/{project_id}/analyses/{analysis_id}/activity_facts.xml'},
			{label: 'ActivityLatest', data: '/projects/{project_id}/analyses/latest/activity_facts.xml'},
			{label: 'ContributorFact', data: '/projects/{project_id}/contributors/{contributor_id}.xml'},
			{label: 'ContributorFacts', data: '/projects/{project_id}/contributors.xml'},
			{label: 'ContributorLanguageFacts', data: '/projects/{project_id}/contributors/{contributor_id}.xml'},
			{label: 'Enlistment', data: '/projects/{project_id}/enlistment/{enlistment_id}.xml'},
			{label: 'Enlistments', data: '/projects/{project_id}/enlistment/{enlistment_id}.xml'},
			{label: 'Factoid', data: '/projects/{project_id}/factoids/{factoid_id}.xml'},
			{label: 'Factoids', data: '/projects/{project_id}/factoids.xml'},
			{label: 'KudosReceived', data: '/accounts/{account_id}/kudos.xml'},
			{label: 'KudosSent', data: '/accounts/{account_id}/kudos/sent.xml'},
			{label: 'Language', data: '/languages/{language_id}.xml'},
			{label: 'Languages', data: '/languages.xml'},
			{label: 'Project', data: '/projects/{project_id}.xml'},
			{label: 'Projects', data: '/projects.xml'},
			{label: 'SizeFacts', data: '/projects/{project_id}/analyses/{analysis_id}/size_facts.xml'},
			{label: 'SizeFactsLatest', data: '/projects/{project_id}/analyses/latest/size_facts.xml'},
			{label: 'StackByAccount', data: '/accounts/{account_id}/stacks/{stack_id}.xml'},
			{label: 'StackByAccountDefault', data: '/accounts/{account_id}/stacks/default.xml'},
			{label: 'Stacks', data: '/projects/{project_id}/stacks.xml'},
		];

		public function Tool()
		{

		}

		public function options(method:String):Array
		{
			var options:Array = [];

			var pattern:RegExp = new RegExp("(\{)(.*?)(\})", "g");
			var result:Object = pattern.exec(method);

            while (result != null) {
             	options.push(result[2]);
            	result = pattern.exec(method);
         	}
			return options;
		}

		override public function call(method:String, listener:Function = null, args:Object = null):void
		{
			var options:Array = this.options(method);
			var service:String = "";

			if (args.params.length == options.length)
			{

				for (var key:String in options)
				{
					var str:String = "\{" + options[key] + "\}";
					service += method.replace(new RegExp(str, "g"), args.params[key]);
				}
			}

			super.call(service.substring(1), listener, args);
		}
	}
}
