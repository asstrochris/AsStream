package org.evil.asstream.parse
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	
	import org.evil.asstream.IAsMappingProvider;
	import org.evil.asstream.reflect.ClassMetadata;
	import org.evil.asstream.reflect.PropertyMetadata;
	
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
		
		private function encodeObject(obj:*, elementName:String=null):String 
		{
			
			// first locate classMetadata
			var classMeta : ClassMetadata = findClassMetadataForInstance(obj);
			
			// now constuct xml block
			return contructXmlForClass(obj, classMeta, elementName);
		}
		
		private function contructXmlForClass(obj:*, classMeta:ClassMetadata, elementName:String=null):String
		{
			// if this object is already in the cache, just return a cache id
			if (referenceCache[obj] != undefined)
				return "<"+(elementName!=null ? elementName : classMeta.alias)+" reference=\""+ referenceCache[obj] + "\"/>";
			
			// increase ref index, we store it in the cache and use again in opening element
			refIndex++;
			
			// add a reference node to the cache 
			referenceCache[obj] = refIndex;
			
			// open xml element
			var xmlString : String = "<"+(elementName!=null ? elementName : classMeta.alias)+" id=\""+refIndex+"\">";;
			
			// add property nodes
			xmlString += constructXmlForProperties(obj, classMeta);
			
			// close xml
			xmlString += "</"+(elementName!=null ? elementName : classMeta.alias)+">";
			
			return xmlString;
		}
		
		private function constructXmlForProperties(obj:*, classMeta:ClassMetadata):String
		{
			var xmlString:String = "";
			var properties:Dictionary = classMeta.properties;
			
			for each(var prop : PropertyMetadata in properties) {
				
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
						xmlString += encodeObject( obj[ prop.name ], prop.alias );
					}
				}
				
			}
			return xmlString;
		}
		
		private function findClassMetadataForInstance(obj:*):ClassMetadata
		{
			var type:String = getQualifiedClassName(obj);
			return findClassMetadataByType(type);
		}
	}
}