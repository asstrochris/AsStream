package org.evil.asstream
{
	public interface IAsStream
	{
		
		/**
		 * Converts an object to an xml object
		 */
		function toXml(obj:Object):XML;
		
		/**
		 * Converts an object to an string
		 */
		function toString(obj:Object):String;
		
		/**
		 * Converts an XML object to a typed AS object
		 */
		function fromXml(xml:XML):Object;
		
		/**
		 * Converts an String to a typed AS object
		 */
		function fromString(string:String):Object;
	}
}