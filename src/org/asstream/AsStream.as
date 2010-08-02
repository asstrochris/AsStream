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
	
	import org.asstream.parse.DecodeProcess;
	import org.asstream.parse.EncodeProcess;
	import org.asstream.reflect.ClassMetadata;
	import org.asstream.reflect.MetadataProcessor;
	
	public class AsStream implements IAsStream, IAsMappingProvider
	{
		private var classMappings:Dictionary;
		
		public function AsStream()
		{
			classMappings = new Dictionary();
		}
		
		/* ************************* *
		 * IAsStream implementations *
		 * ************************* */

		public function registerClass(clazz:Class, alias:String=null):void
		{
			// create a new ClassMetadata for the class
			var classMeta : ClassMetadata = MetadataProcessor.processClass(clazz);
			// if an alias was supplied, set it on the class meta
			if (alias != null) classMeta.setAlias(alias);
			// store in the classMappings dictionary
			classMappings[ classMeta.alias ] = classMeta;
		}
		
		public function toXml(obj:Object):XML
		{
			return (new EncodeProcess(this)).encode(obj);
		}
		
		public function toString(obj:Object):String
		{
			return toXml(obj).toXMLString();
		}
		
		public function fromXml(xml:XML):Object
		{
			return (new DecodeProcess(this)).decode(xml);
		}
		
		public function fromString(string:String):Object
		{
			return fromXml(new XML(string));
		}
		
		/* ******************************** *I
		 * TestableAsStream implementations *
		 * ******************************** */
		
		/**
		 * Returns true if factory contains a class mapping
		 */
		public function containsClassMapping(alias:String):Boolean
		{
			return classMappings[alias] != null;
		}
		
		/**
		 * Returns a class mapping for a type
		 */
		public function getClassMappingByAlias(alias:String):ClassMetadata
		{
			return classMappings[alias];
		}
		
		/**
		 * Returns a class mapping for a type
		 */
		public function getClassMappingByType(type:String):ClassMetadata
		{
			for each (var classMeta : ClassMetadata in classMappings) {
				if (classMeta.type == type)
					return classMeta;
			}
			return null;
		}
		
		/**
		 * Returns classMapping dictionary
		 */
		public function getClassMappings():Dictionary
		{
			return classMappings;
		}
		
	}
}