package org.evil.asstream.parse.test
{
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
			Assert.assertEquals( "Should find three elements in array", 3, list.length() );
			Assert.assertEquals( "First element is 'A'", "A", list[0] );
			Assert.assertEquals( "First element is 'B'", "B", list[1] );
			Assert.assertEquals( "First element is 'C'", "C", list[2] );
		}
	}
}