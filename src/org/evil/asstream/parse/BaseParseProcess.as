package org.evil.asstream.parse
{
	import flash.utils.Dictionary;
	
	import org.evil.asstream.IAsMappingProvider;
	import org.evil.asstream.reflect.ClassMetadata;
	import org.evil.asstream.reflect.ClassUtilities;
	
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
		
		protected function addToCache(cacheId:String, obj:*):void
		{
			referenceCache["ref_"+cacheId] = obj;
		}
		
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