package org.evil.asstream
{
	import flash.utils.Dictionary;
	
	import org.evil.asstream.reflect.ClassMetadata;
	
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