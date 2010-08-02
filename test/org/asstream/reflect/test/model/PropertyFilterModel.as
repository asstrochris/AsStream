/*
* Copyright 2010 AsStream Contributors
* 
* Licensed under the Apache License, Version 2.0 (the "License"); you may not
* use this file except in compliance with the License. You may obtain a copy of
* the License. You may obtain a copy of the License at
* 
* http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations under
* the License.
*/

package org.asstream.reflect.test.model
{
	import mx.collections.IList;

	/**
	 * Test class for 
	 */
	public class PropertyFilterModel
	{
		public var simpleVariable:String;
		
		public function get readOnlyGetter():String
		{
			return "";
		}
		
		public function set writeOnlySetter( value:String ):void
		{
			return;
		}
		
		public function get accessor():String
		{
			return "";
		}
		
		public function set accessor( value:String ):void
		{
			return;
		}
		
		[Transient]
		public var transientVariable:String;
		
		[Bindable] [Transient]
		public var bindableTransientVariable:String;
	}
}