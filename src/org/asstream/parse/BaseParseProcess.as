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

package org.asstream.parse
{
	import flash.utils.Dictionary;
	
	import org.asstream.IAsMappingProvider;
	import org.asstream.reflect.ClassMetadata;
	import org.asstream.reflect.ClassUtilities;
	
	/**
	 * Base class for an encoding/decoding context.
	 * Implements reference cache add/remove and class metadata lookup.
	 */
	public class BaseParseProcess
	{
		protected var asStream : IAsMappingProvider;
		protected var referenceCache : Dictionary;
		protected var typeConverter : TypeConverter;
		
		public function BaseParseProcess(asStream : IAsMappingProvider)
		{
			this.asStream = asStream;
			this.referenceCache = new Dictionary();
			this.typeConverter = new TypeConverter();
		}
		
		/**
		 * Looks up the object corresponding to the XML element based on its "reference" or "id" attribute
		 */
		protected function findInCache(xml:XML):*
		{
			// first check to see if we are looking at a reference
			if (xml.@reference != undefined) {
				if (referenceCache["ref_"+xml.@reference] == null)
					throw new Error("AsStream.CacheError: No object exists in the reference cache for the xml.@reference!");
				else
					return referenceCache["ref_"+xml.@reference];
			} else if (xml.@id != undefined && referenceCache["ref_"+xml.@id] != null) {
				return referenceCache["ref_"+xml.@id];
			} else {
				return null;
			}
		}
		
		/**
		 * Adds an object to the cache using the supplied id
		 */
		protected function addToCache(cacheId:String, obj:*):void
		{
			referenceCache["ref_"+cacheId] = obj;
		}
		
		/**
		 * Looks up class metadata for the fully-qualified type name
		 */
		protected function findClassMetadataByType(type:String):ClassMetadata {
			var classMeta:ClassMetadata = asStream.getClassMappingByType(type);
			if (classMeta == null) {
				var typeClass : Class = ClassUtilities.classForName(type);
				if (typeClass != null) {
					asStream.registerClass(typeClass);
					classMeta = asStream.getClassMappingByType(type);
				}
			}
			return classMeta;
		}
		
		/**
		 * Looks up class metadata for the previously-mapped alias name
		 */
		protected function findClassMetadataByAlias(alias:String):ClassMetadata {
			var classMeta:ClassMetadata = asStream.getClassMappingByAlias(alias);
			// if we didn't find a class alias, we may have an unaliased element that is not yet registered.
			// we can try to load the class by converting the fully qualified path to an AS path
			if (classMeta == null) {
				var typeSeparatorIx : int = alias.lastIndexOf(".");
				if (typeSeparatorIx > -1)  {
					var asType : String = alias.substr(0, typeSeparatorIx)+"::"+alias.substr(typeSeparatorIx+1,alias.length);
					var typeClass : Class = ClassUtilities.classForName(asType);
					if (typeClass != null) {
						asStream.registerClass(typeClass);
						classMeta = asStream.getClassMappingByType(asType);
					}
				}
			}
			return classMeta;
		}

	}
}