package org.evil.asstream.reflect
{
	public class PropertyMetadata
	{
		private var _name:String;
		private var _type:String;
		private var _alias:String;
		private var _implicit:Boolean;
		
		public function PropertyMetadata(name:String, type:String, alias:String, implicit:Boolean)
		{
			_name = name;
			_type = type;
			_alias = alias;
			_implicit = implicit;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get alias():String
		{
			return _alias;
		}
		
		public function get implicit():Boolean
		{
			return _implicit;
		}
		
		public function isSimpleType():Boolean
		{
			return type == "uint" || type == "int" || type == "String" ||  
				   type == "Number" || type == "Boolean"|| type == "Date";
		}
	}
}