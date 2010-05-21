package org.evil.asstream.reflect
{
	import flash.utils.Dictionary;
	
	public class ClassMetadata
	{
		private var _alias:String;
		private var _type:String;
		
		private var _properties:Dictionary;
		private var _propertiesArray:Array;
		
		public function ClassMetadata(alias:String, type:String)
		{
			_properties = new Dictionary();
			_propertiesArray = [];
			_alias = alias;
			_type = type;
		}
		
		public function get alias():String
		{
			return _alias;
		}
		
		public function setAlias(alias:String):void
		{
			_alias = alias;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get properties():Array
		{
			return _propertiesArray;
		}
		
		public function getProperty(name:String):PropertyMetadata
		{
			if (_properties[name] != null)
				return _properties[name];
			else
				return null;
		}
		
		public function addProperty(property:PropertyMetadata):void
		{
			_properties[ property.name ] = property;
			_propertiesArray.push( property );
			_propertiesArray.sortOn( "name" );
		}
	}
}