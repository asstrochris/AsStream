package org.evil.asstream.parse.test
{
	import flexunit.framework.Assert;
	
	import org.evil.asstream.AsStream;
	import org.evil.asstream.parse.DecodeProcess;

	public class DecodeProcessTests
	{
		protected var decoder:DecodeProcess;
		
		[Before]
		public function setUp():void
		{
			decoder = new DecodeProcess(new AsStream());
		}
		
		[After]
		public function tearDown():void
		{
			decoder = null;
		}		
		
		[Test]
		public function testDecodeArray():void
		{
			var xml:XML = <Array id="1"><String>A</String><String>B</String><String>C</String></Array>;
			var array:Array = decoder.decode( xml ) as Array;
			
			Assert.assertNotNull( array );
			Assert.assertEquals( "Should find three elements in array", 3, array.length );
			Assert.assertEquals( "First element is 'A'", "A", array[0] );
			Assert.assertEquals( "First element is 'B'", "B", array[1] );
			Assert.assertEquals( "First element is 'C'", "C", array[2] );
		}
	}
}