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

package org.asstream.parse.test
{
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	
	import mx.collections.ArrayCollection;
	
	import org.asstream.AsStream;
	import org.asstream.parse.EncodeProcess;

	public class EncodeProcessTests
	{
		protected var encoder:EncodeProcess;
				
		[Before]
		public function setUp():void
		{
			encoder = new EncodeProcess(new AsStream());
		}
		
		[After]
		public function tearDown():void
		{
			encoder = null;
		}		
		
		[Test]
		public function testEncodeArray():void
		{
			var xml:XML = encoder.encode( ["A","B","C"] );
			var list:XMLList = xml.String;
			Assert.assertEquals( 3, list.length() );
			Assert.assertEquals( "A", list[0] );
			Assert.assertEquals( "B", list[1] );
			Assert.assertEquals( "C", list[2] );
		}
		
		[Test]
		public function testEncodeDictionary():void
		{
			var dict:Dictionary = new Dictionary();
			dict[ 300 ] = "This is Sparta!";
			dict[ "Anchorman" ] = "I'm Ron Burgundy?";
			
			var xml:XML = encoder.encode( dict );
			Assert.assertNotNull( xml );
			Assert.assertEquals(xml.name(), "flash.utils.Dictionary" );
			var list:XMLList = xml.children();
			Assert.assertEquals( 2, list.length() );
			var element1:XML = list[0];
			Assert.assertEquals( "<int>300</int>", element1.elements()[0].toXMLString() );
			Assert.assertEquals( "<String>This is Sparta!</String>", element1.elements()[1].toXMLString() );
			var element2:XML = list[1];
			Assert.assertEquals( "<String>Anchorman</String>", element2.elements()[0].toXMLString() );
			Assert.assertEquals( "<String>I'm Ron Burgundy?</String>", element2.elements()[1].toXMLString() );
		}
	}
}