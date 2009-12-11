package org.evil.asstream.reflect
{
	import flash.utils.getDefinitionByName;
	
	/**
	 * Handles basic class functions for creating classes and returning Class objects for types.
	 */
	public class ClassUtilities
	{
		public function ClassUtilities() { }
		
		/**
		 * Returns a new instance of a Class object
		 */
		public static function instanceForClass(clazz:Class):Object
		{
			return new clazz();
		}
		
		/**
		 * Returns a new instance from a Class type name
		 */
		public static function instanceForType(type:String):Object
		{
			var clazz : Class = classForName(type);
			return new clazz();
		}
		
		/**
		 * Returns a Class object for a type name
		 */
		public static function classForName(type:String):Class
		{
			return getDefinitionByName( type ) as Class;
		}
	}
}