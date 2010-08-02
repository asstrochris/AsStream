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
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	import org.asstream.IAsMappingProvider;
	import org.asstream.reflect.ClassMetadata;
	import org.asstream.reflect.PropertyMetadata;
	
	public class EncodeProcess extends BaseParseProcess
	{
		private var refIndex:int;
		
		public function EncodeProcess(asStream : IAsMappingProvider)
		{
			super(asStream);
		}
		
		public function encode(obj:*):XML 
		{
			return XML(encodeObject(obj));
		}
		
		private function encodeObject(obj:*, elementName:String=null, className:String=null):String 
		{
			// first locate classMetadata
			var classMeta : ClassMetadata = findClassMetadataForInstance(obj);
			
			// now constuct xml block
			if ( !typeConverter.isSimpleType( obj ) )
				return contructXmlForClass(obj, classMeta, elementName, className);
			else
				return typeConverter.toXml( obj, classMeta.type, classMeta.type );
		}
		
		private function contructXmlForClass(obj:*, classMeta:ClassMetadata, elementName:String=null, className:String=null):String
		{
			// if this object is already in the cache, just return a cache id
			if (referenceCache[obj] != undefined)
				return "<"+(elementName!=null ? elementName : classMeta.alias)+" reference=\""+ referenceCache[obj] + "\"/>";
			
			// increase ref index, we store it in the cache and use again in opening element
			refIndex++;
			
			// add a reference node to the cache 
			referenceCache[obj] = refIndex;
			
			// create "class" attribute if className was passed in
			var classNameString:String = className != null ? " class=\"" + className + "\" " : "";
				
			// open xml element
			var xmlString : String = "<"+(elementName!=null ? elementName : classMeta.alias)+" id=\""+refIndex+"\""+classNameString+">";;
			
			// add property nodes or children nodes
			if ( !typeConverter.isCollection(obj) )
				xmlString += constructXmlForProperties(obj, classMeta);
			else
				xmlString += constructXmlForChildren(obj);			
			
			// close xml
			xmlString += "</"+(elementName!=null ? elementName : classMeta.alias)+">";
			
			return xmlString;
		}
		
		private function constructXmlForProperties(obj:*, classMeta:ClassMetadata):String
		{
			var xmlString:String = "";
			var properties:Array = classMeta.properties;
			
			for each(var prop : PropertyMetadata in properties) {
				
				try {
					// simple types can be sent right through the type converter
					if (obj[ prop.name ] != null) {
						if (prop.isSimpleType()) {
							xmlString += typeConverter.toXml( obj[ prop.name ], prop.type, prop.alias );
						} else if (prop.type == "Array") {
							var arr:Array = obj[ prop.name ];
							if (arr.length > 0) {
								// if we are not processing an implicit collection, add wrapping element
								if (!prop.implicit)
									xmlString += "<"+prop.alias+" id=\""+(++refIndex)+"\">";
								// now parse each item
								for(var i:int=0; i<arr.length; i++)
									xmlString += encodeObject( arr[i] );
								// and add closing element
								if (!prop.implicit)
									xmlString += "</"+prop.alias+">";
							}
						} else if (prop.type == "flash.utils::Dictionary") {
							var dict:Dictionary = obj[ prop.name ];
							xmlString += "<"+prop.alias+" id=\""+(++refIndex)+"\">";
							for each ( var key:* in getLexicalKeys(dict) )
								xmlString += "<entry>" + encodeObject( key ) + encodeObject( dict[key] ) + "</entry>";
							xmlString += "</"+prop.alias+">";
							// todo...
						} else if (prop.type == "mx.collections::ArrayCollection") {
							var arrCol:ArrayCollection = obj[ prop.name ];
							if (arrCol.length > 0) {
								// if we are not processing an implicit collection, add wrapping element
								if (!prop.implicit)
									xmlString += "<"+prop.alias+" id=\""+(++refIndex)+"\">";
								// now parse each item
								for each(var item : * in arrCol)
									xmlString += encodeObject( item );
								// and add closing element
								if (!prop.implicit)
									xmlString += "</"+prop.alias+">";
							}
						} else {
							var className:String = getQualifiedClassName( obj[ prop.name ] );
							var xmlClassName:String = className == prop.type ? null : className;
							xmlString += encodeObject( obj[ prop.name ], prop.alias, xmlClassName );
						}
					}
				} catch ( error:Error ) {
					trace( StringUtil.substitute( "error occurred while writing to property '{0}' on class '{1}', skipping. error was:\n{2} ", prop.name, classMeta.type, error.message ) );
				}
				
			}
			return xmlString;
		}
		
		/**
		 * Creates XML for the child objects of an Array or Dictionary
		 */
		protected function constructXmlForChildren(obj:*):String
		{
			var xmlString:String = "";
			if ( obj is Array )
			{
				for each ( var child:* in obj )
					xmlString += encodeObject( child );
			}
			else if ( obj is Dictionary )
			{
				for each ( var key:* in getLexicalKeys(obj) )
					xmlString += "<entry>" + encodeObject( key ) + encodeObject( obj[key] ) + "</entry>";
			}
			return xmlString;
		}
		
		/**
		 * Returns the keys of a dictionary sorted lexically. Useful for ensuring consitent order of iteration.
		 */
		protected function getLexicalKeys( dict:Dictionary ):Array {
			var keys:Array = [];
			for ( var key:* in dict )
				keys.push( key );
			keys.sort();
			return keys;
		} 
		
		private function findClassMetadataForInstance(obj:*):ClassMetadata
		{
			var type:String = getQualifiedClassName(obj);
			return findClassMetadataByType(type);
		}
	}
}