/*
* Copyright 2010 AsStream Contributors
* 
* Licensed under the Apache License, Version 2.0 (the "License"); you may not
* use this file except in compliance with the License. You may obtain a copy of
* the License. You may obtain a copy of the License at
* 
* http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations under
* the License.
*/

package org.asstream.parse
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	
	public class TypeConverter
	{
		public function isSimpleType( obj:* ):Boolean {
			return obj is String || obj is Number || obj is Boolean || obj is Date || obj is int || obj is uint;
		}
		
		public function isSimpleElement( elementName:String ):Boolean {
			return elementName == "String" || elementName == "Number" || elementName == "Boolean" || elementName == "Date" || elementName == "int" || elementName == "uint";
		}
		
		// TODO: support ArrayCollection or Vector ?
		public function isCollection( obj:* ):Boolean {
			return obj is Array || obj is Dictionary;
		}
		
		// TODO: support ArrayCollection or Vector ?
		public function isCollectionElement( elementName:String ):Boolean {
			return elementName == "Array" || elementName == "flash.utils.Dictionary";
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