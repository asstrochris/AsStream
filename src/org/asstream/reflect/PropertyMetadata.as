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

package org.asstream.reflect
{
	public class PropertyMetadata
	{
		private var _name:String;
		private var _type:String;
		private var _alias:String;
		private var _implicit:Boolean;
		
		public function PropertyMetadata(name:String, type:String, alias:String, implicit:Boolean)
		{
			_name = name;
			_type = type;
			_alias = alias;
			_implicit = implicit;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get alias():String
		{
			return _alias;
		}
		
		public function get implicit():Boolean
		{
			return _implicit;
		}
		
		public function isSimpleType():Boolean
		{
			return type == "uint" || type == "int" || type == "String" ||  
				   type == "Number" || type == "Boolean"|| type == "Date";
		}
	}
}