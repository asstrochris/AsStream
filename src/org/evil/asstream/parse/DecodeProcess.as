package org.evil.asstream.parse
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.evil.asstream.IAsMappingProvider;
	import org.evil.asstream.reflect.ClassMetadata;
	import org.evil.asstream.reflect.ClassUtilities;
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
			return null;
		}
		
		private function decodeObject(xml:XML):*
		{
			// we need an xml.@id value, or we have an issue...
			// if (xml.@id == undefined)
				// throw new Error("AsStream.CacheIdError: XML object does not contain an xml.@id, cannot use reference cache!");
			var elementName : String = xml.localName();
			
			// try to find the ClassMetadata for the elementName, will create metadata if it doesn't exist
			var classMeta : ClassMetadata = findClassMetadataByAlias(elementName);
			
			if (classMeta == null)
				throw new Error("AsStream.ClassMappingError: Element <"+elementName+"> is not mapped to a class!");
				
			// construct an instance of the type we found
			return constructObject(xml, classMeta);	
		}
		
		private function constructObject(xml:XML, classMeta:ClassMetadata):* {
			// first check to see if we have a cached class reference
			// todo: somehow we are returning wrong instances!
			var obj:* = findInCache(xml);
			
			// return if we found it
			if (obj != null) return obj;
			
			// construct an instance of the type we found
			obj = ClassUtilities.instanceForType(classMeta.type);
			
			// add to cache
			var elementId : String = xml.@id;
			if (elementId != null && elementId != "") addToCache(elementId, obj);
			
			// process properties
			contructProperties(xml, obj, classMeta);				
			
			// return object
			return obj;
		}
		
		private function contructProperties(xml:XML, obj:*, classMeta:ClassMetadata):void
		{
			var properties:Dictionary = classMeta.properties;
			var value : *;
			for each(var prop : PropertyMetadata in properties) {
				
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
				
			}
		}
	}
}