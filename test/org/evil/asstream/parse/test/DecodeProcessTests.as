package org.evil.asstream.parse.test
{
	import flash.utils.Dictionary;
	
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
		
		[Test(description="Tests decoding of a top-level Array.")]
		/**
		 * Tests decoding of a top-level Array.
		 */
		public function testDecodeArray():void
		{
			var xml:XML = <Array id="1">
							<String>A</String>
							<String>B</String>
							<String>C</String>
						  </Array>;
			var array:Array = decoder.decode( xml ) as Array;
			
			Assert.assertNotNull( array );
			Assert.assertEquals( 3, array.length );
			Assert.assertEquals( "A", array[0] );
			Assert.assertEquals( "B", array[1] );
			Assert.assertEquals( "C", array[2] );
		}
		
		[Test(description="Tests decoding of a top-level Dictionary.")]
		/**
		 * Tests decoding of a top-level Dictionary.
		 */
		public function testDecodeDictionary():void
		{
			var xml:XML = <flash.utils.Dictionary id="1">
							<entry>
							  <int>
								300
							  </int>
							  <String>
								This is Sparta!
							  </String>
							</entry>
							<entry>
							  <String>
								Anchorman
							  </String>
							  <String>
								I'm Ron Burgundy?
							  </String>
							</entry>
						  </flash.utils.Dictionary>;
			
			var dict:Dictionary = decoder.decode( xml );
			
			Assert.assertNotNull( dict );
			Assert.assertNotNull( dict[300] );
			Assert.assertEquals( dict[300], "This is Sparta!" );
			Assert.assertNotNull( dict["Anchorman"] );
			Assert.assertEquals( dict["Anchorman"], "I'm Ron Burgundy?" );
		}
		
		[Test(description="Tests decoding of a nested Dictionary.")]
		public function testDecodeNestedDictionary():void
		{
			var xml:XML = <Array id="1">
							<flash.utils.Dictionary id="2">
								<entry>
								  <int>
									300
								  </int>
								  <String>
									This is Sparta!
								  </String>
								</entry>
								<entry>
								  <String>
									Anchorman
								  </String>
								  <String>
									I'm Ron Burgundy?
								  </String>
								</entry>
							</flash.utils.Dictionary>
						  </Array>;
			
			var array:Array = decoder.decode( xml );
			var dict:Dictionary = array[0];
			
			Assert.assertNotNull( dict );
			Assert.assertNotNull( dict[300] );
			Assert.assertEquals( dict[300], "This is Sparta!" );
			Assert.assertNotNull( dict["Anchorman"] );
			Assert.assertEquals( dict["Anchorman"], "I'm Ron Burgundy?" );
		}
	}
}