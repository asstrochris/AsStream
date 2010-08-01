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

package org.asstream
{
	import flash.utils.Dictionary;
	
	import org.asstream.reflect.ClassMetadata;
	
	public interface IAsMappingProvider
	{
		/**
		 * Registers a class to an xml alias
		 */
		function registerClass(clazz:Class, alias:String=null):void;
		
		/**
		 * Registers a type to an xml alias
		 *
		function registerTypeAlias(alias:String, type:*):void; */
		
		/**
		 * Registers a class by processing medata for both class and property 
		 * aliases
		 *
		function processClassMetadata(clazz:Class):void; */
		
		/**
		 * Returns true if factory contains a class mapping
		 */
		function containsClassMapping(alias:String):Boolean;
		
		/**
		 * Returns a class mapping for a type
		 */
		function getClassMappingByAlias(alias:String):ClassMetadata;
		
		/**
		 * Returns a class mapping for a type
		 */
		function getClassMappingByType(type:String):ClassMetadata;
		
		/**
		 * Returns classMapping dictionary
		 */
		function getClassMappings():Dictionary;
	}
}