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
	import flash.utils.Dictionary;
	
	public class ClassMetadata
	{
		private var _alias:String;
		private var _type:String;
		
		private var _properties:Dictionary;
		private var _propertiesArray:Array;
		
		public function ClassMetadata(alias:String, type:String)
		{
			_properties = new Dictionary();
			_propertiesArray = [];
			_alias = alias;
			_type = type;
		}
		
		public function get alias():String
		{
			return _alias;
		}
		
		public function setAlias(alias:String):void
		{
			_alias = alias;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get properties():Array
		{
			return _propertiesArray;
		}
		
		public function getProperty(name:String):PropertyMetadata
		{
			if (_properties[name] != null)
				return _properties[name];
			else
				return null;
		}
		
		public function addProperty(property:PropertyMetadata):void
		{
			_properties[ property.name ] = property;
			_propertiesArray.push( property );
			_propertiesArray.sortOn( "name" );
		}
	}
}