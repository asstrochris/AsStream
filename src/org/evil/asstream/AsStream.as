package org.evil.asstream
{
	import flash.utils.Dictionary;
	
	import org.evil.asstream.reflect.ClassMetadata;
	import org.evil.asstream.reflect.MetadataProcessor;
	
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
			return null;
		}
		
		public function toString(obj:Object):String
		{
			return null;
		}
		
		public function fromXml(xml:XML):Object
		{
			return null;
		}
		
		public function fromString(string:String):Object
		{
			return null;
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