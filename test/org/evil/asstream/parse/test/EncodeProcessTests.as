package org.evil.asstream.parse.test
{
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	
	import mx.collections.ArrayCollection;
	
	import org.evil.asstream.AsStream;
	import org.evil.asstream.parse.EncodeProcess;

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