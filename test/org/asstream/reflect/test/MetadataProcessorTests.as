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

package org.asstream.reflect.test
{
	import org.asstream.reflect.test.model.Class1;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.asstream.reflect.ClassMetadata;
	import org.asstream.reflect.MetadataProcessor;
	import org.asstream.reflect.PropertyMetadata;

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