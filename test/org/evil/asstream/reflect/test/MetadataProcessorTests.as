package org.evil.asstream.reflect.test
{
	import org.evil.asstream.reflect.test.model.Class1;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.evil.asstream.reflect.ClassMetadata;
	import org.evil.asstream.reflect.MetadataProcessor;
	import org.evil.asstream.reflect.PropertyMetadata;

	public class MetadataProcessorTests
	{
		protected var classMeta:ClassMetadata;
		
		[Before]
		public function setUp():void
		{
			classMeta = MetadataProcessor.processClass( Class1 );
		}
		
		[After]
		public function tearDown():void
		{
			classMeta = null;
		}
		
		[Test]
		/**
		 * Tests that properties are appropriately filtered
		 */
		public function testPropertyFiltering():void
		{
			var simpleVariable:PropertyMetadata = classMeta.getProperty( "simpleVariable" );
			assertNotNull( "'simpleVariable' should be stored as property", simpleVariable );
			
			var readOnlyGetter:PropertyMetadata = classMeta.getProperty( "readOnlyGetter" );
			assertNull( "'readOnlyGetter' should not be stored as property", readOnlyGetter );
			
			var writeOnlySetter:PropertyMetadata = classMeta.getProperty( "writeOnlySetter" );
			assertNull( "'writeOnlySetter' should not be stored as property", writeOnlySetter );
						
			var accessor:PropertyMetadata = classMeta.getProperty( "accessor" );
			assertNotNull( "'accessor' should be stored as property", accessor );
			
			var transientVariable:PropertyMetadata = classMeta.getProperty( "transientVariable" );
			assertNull( "'transientVariable' should not be stored as property", transientVariable );
			
			var bindableTransientVariable:PropertyMetadata = classMeta.getProperty( "bindableTransientVariable" );
			assertNull( "'bindableTransientVariable' should not be stored as property", bindableTransientVariable );
		}
	}
}