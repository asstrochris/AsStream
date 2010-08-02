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
	import flash.utils.getDefinitionByName;
	
	/**
	 * Handles basic class functions for creating classes and returning Class objects for types.
	 */
	public class ClassUtilities
	{
		public function ClassUtilities() { }
		
		/**
		 * Returns a new instance of a Class object
		 */
		public static function instanceForClass(clazz:Class):Object
		{
			return new clazz();
		}
		
		/**
		 * Returns a new instance from a Class type name
		 */
		public static function instanceForType(type:String):Object
		{
			var clazz : Class = classForName(type);
			return new clazz();
		}
		
		/**
		 * Returns a Class object for a type name
		 */
		public static function classForName(type:String):Class
		{
			return getDefinitionByName( type ) as Class;
		}
	}
}