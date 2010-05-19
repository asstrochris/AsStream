package org.evil.asstream.test
{
	import mx.collections.IList;

	/**
	 * Test class for 
	 */
	public class Class1
	{
		public var simpleVariable:String;
		
		public function get readOnlyGetter():String
		{
			return "";
		}
		
		public function set writeOnlySetter( value:String ):void
		{
			return;
		}
		
		public function get accessor():String
		{
			return "";
		}
		
		public function set accessor( value:String ):void
		{
			return;
		}
		
		[Transient]
		public var transientVariable:String;
		
		[Bindable] [Transient]
		public var bindableTransientVariable:String;
	}
}