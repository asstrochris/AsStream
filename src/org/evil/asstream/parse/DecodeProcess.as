package org.evil.asstream.parse
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	import org.evil.asstream.IAsMappingProvider;
	import org.evil.asstream.reflect.ClassMetadata;
	import org.evil.asstream.reflect.ClassUtilities;
	import org.evil.asstream.reflect.MetadataProcessor;
	import org.evil.asstream.reflect.PropertyMetadata;
	
	public class DecodeProcess extends BaseParseProcess
	{
		
		public function DecodeProcess(asStream : IAsMappingProvider)
		{
			super(asStream);
		}
		
		public function decode(xml:XML):* 
		{
			return decodeObject(xml);
		}
		
		private function decodeList(xmlList:XMLList):ArrayCollection
		{
			// TODO: when to implement decodeList?
			return null;
		}
		
		private function decodeObject(xml:XML):*
		{
			// we need an xml.@id value, or we have an issue...
			// if (xml.@id == undefined)
				// throw new Error("AsStream.CacheIdError: XML object does not contain an xml.@id, cannot use reference cache!");
			var elementName : String = xml.localName();
			
			if ( typeConverter.isSimpleElement( elementName ) )
			{
				return typeConverter.convertType(xml.toString(), elementName);
			}
			else if ( typeConverter.isCollectionElement( elementName ) )
			{
				return constructCollection(xml, elementName);
			}
			else
			{
				// try to find the ClassMetadata for the elementName, will create metadata if it doesn't exist
				var classMeta : ClassMetadata = findClassMetadataByAlias(elementName);
			
				// construct an instance of the type we found
				if (classMeta == null)
					throw new Error("AsStream.ClassMappingError: Element <"+elementName+"> is not mapped to a class!");
				
				return constructObject(xml, classMeta);
			}
		}
		
		private function constructObject(xml:XML, classMeta:ClassMetadata):* {
			// first check to see if we have a cached class reference
			// todo: somehow we are returning wrong instances!
			var obj:* = findInCache(xml);
			
			// return if we found it
			if (obj != null) return obj;
			
			// by default, use the ClassMetadata that was passed in for recursion
			var actualClassMeta:ClassMetadata = classMeta;
			
			// construct an instance of the type we found, or use value from "class" attribute if specified
			if ( xml.attribute("class") == undefined )
			{
				obj = ClassUtilities.instanceForType( classMeta.type );
			}
			else
			{
				// if a different class was specified in the XML, create an instance of that class and resolve its metadata
				var actualTypeName:String =  xml.attribute("class");
				obj = ClassUtilities.instanceForType( actualTypeName );
				var actualClazz:Class = ClassUtilities.classForName( actualTypeName );
				actualClassMeta = MetadataProcessor.processClass( actualClazz );
			}
			
			// add to cache
			var elementId : String = xml.@id;
			if (elementId != null && elementId != "") addToCache(elementId, obj);
			
			// process properties
			contructProperties(xml, obj, actualClassMeta);			
			
			// return object
			return obj;
		}
		
		private function contructProperties(xml:XML, obj:*, classMeta:ClassMetadata):void
		{
			var properties:Array = classMeta.properties;
			var value : *;
			for each(var prop : PropertyMetadata in properties) {
				
				try {
					
					if (xml.child(prop.alias) != undefined) {
						// simple types can be sent right through the type converter
						if (prop.isSimpleType()) {
							value = xml.child(prop.alias)[0].toString();
							obj[ prop.name ] = typeConverter.convertType(value, prop.type);
						} else if (prop.type == "Array") {
							var arr : Array = new Array();
							// process XMLList (we will require a setting if this array is nested)
							value = xml.child(prop.alias);
							if (!prop.implicit)
								value = value.children();
							for each (var arrItemXml:XML in value)
								arr.push(decodeObject(arrItemXml));
							obj[ prop.name ] = arr;
						} else if (prop.type == "flash.utils::Dictionary") {
							var dict:Dictionary = new Dictionary();
							value = xml.child(prop.alias)[0];
							value = value.children();
							for each ( var entry:XML in value )
							{
								var key:* = decodeObject(entry.elements()[0]);
								var dictValue:* = decodeObject(entry.elements()[1]);
								dict[ key ] = dictValue;
							}
							obj[ prop.name ] = dict;
						} else if (prop.type == "mx.collections::ArrayCollection") {
							var arrCol : ArrayCollection = new ArrayCollection();
							// process XMLList (we will require a setting if this array is nested)
							value = xml.child(prop.alias);
							if (!prop.implicit)
								value = value.children();
							for each (var colItemXml:XML in value)
								arrCol.addItem(decodeObject(colItemXml));
							obj[ prop.name ] = arrCol;
						} else {
							//should be complex object?
							var propertyClassMeta:ClassMetadata = findClassMetadataByType(prop.type);
							obj[ prop.name ] = constructObject(xml.child(prop.alias)[0], propertyClassMeta);
						}
					}
					
				} catch ( error:Error ) {
					trace( StringUtil.substitute( "error occurred while writing to property '{0}' on class '{1}', skipping. error was:\n{2} ", prop.name, classMeta.type, error.message ) );
				}
				
			}
		}
		
		/**
		 * Builds an Array or Dictionary based off related XML
		 */
		protected function constructCollection(xml:XML, elementName:String):*
		{
			if ( elementName == "Array" )
			{
				var array:Array = [];
				for each ( var child:XML in xml.children() )
					array.push(decodeObject(child));
				return array;
			}
			else if ( elementName == "flash.utils.Dictionary" )
			{
				var dict:Dictionary = new Dictionary();
				for each ( var element:XML in xml.elements() )
				{
					var key:* = decodeObject(element.elements()[0])
					var value:* = decodeObject(element.elements()[1])
					dict[ key ] = value;
				}
				return dict;
			}
		}
	}
}