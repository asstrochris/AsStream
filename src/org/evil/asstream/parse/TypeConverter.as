package org.evil.asstream.parse
{
	import mx.formatters.DateFormatter;
	
	public class TypeConverter
	{
		private var dateFormatter : DateFormatter;
		
		public function TypeConverter()
		{
		}
		
		public function convertType( value : *, type : String ) : * {
			
			switch ( type ) {
				
				case "uint" : 
					return uint( value );
				case "int" : 
					return int( value );
				case "String" : 
					return value as String;
				case "Number" : 
					return Number( value );
				case "Boolean" : 
					return value is Boolean ? value : convertBoolean( value as String );
				case "Date" : 
					return parseDate( value );
					
			}
			
			return null;
		}
		
		public function toXml( value : *, type : String, elementName:String ) : String {
			
			switch ( type ) {
				
				case "uint" : 
				case "int" : 
				case "String" : 
				case "Number" : 
					return "<"+elementName+">"+value.toString()+"</"+elementName+">";
				case "Boolean" : 
					return "<"+elementName+">"+(value ? "true" : "false")+"</"+elementName+">";
				case "Date" : 
					return "<"+elementName+">"+formatDate(value)+"</"+elementName+">";
					
			}
			
			return "<"+elementName+"/>";
		} 
		
		/**
		 * Parses a date using the configured format pattern.
		 */
		private function parseDate( value : String ) : Date {
			return new Date( Date.parse( value ) );
		}
		
		/**
		 * Parses a date using the configured format pattern.
		 */
		private function formatDate( date : Date ) : String {
			//return dateFormatter.format(date);
			return date.toUTCString();
		}
		
		/**
		 * Converts a String to a Boolean value.
		 */
		private function convertBoolean ( val : String ) : Boolean {
			var str : String = val.toLowerCase();
			if ( str == "true" || str == "1" || str == "yes"  )	{
				return true;
			} else {
				return false;
			}
		}

	}
}