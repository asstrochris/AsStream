package org.evil.asstream.reflect
{
	import flash.utils.describeType;
	
	/**
	 * MetadataProcessor is responsible for building ClassMetadata and PropertyMetadata objects for
	 * AS Classes. Uses describeType() and walks XML structure. Also looks for [AsStreamAlias] elements 
	 * to find custom XML Element names for classes and properties.
	 */
	public class MetadataProcessor
	{
		
		/** Key for Alias metadata element, incase I want to make this comfigurable. */
		private static var ALIAS_KEY : String = "AsStreamAlias";
		
		/** Key for Alias metadata element, incase I want to make this comfigurable. */
		private static var IMPLICIT_KEY : String = "AsStreamImplicit";
	
		public function MetadataProcessor() { }
		
		/**
		 * Builds a ClassMetadata object for a Class. Calls describeType() and looks for 
		 * metadata class aliases. Walks the variables and accessors to build a PropertyMetadata 
		 * Dictionary for each, by property name/
		 */
		public static function processClass(clazz:Class):ClassMetadata 
		{	
			// retrieve class metadata xml
			var classXml : XML = getClassMetadata(clazz);
			
			// construct ClassMetadata
			var classMetadata : ClassMetadata = createClassMetadata(classXml);
			
			// build property map, to come...
			var prop : PropertyMetadata;
			
			// build propeties from all the variables and accessors
			createPropertiesFromList(classMetadata, classXml.variable);
			createPropertiesFromList(classMetadata, classXml.accessor);
			
			// return
			return classMetadata;
		}
		
		/**
		 * Creates ClassMetadata object from a class' XML description. Retrieves the type and alias
		 * from metadata, if available.
		 */
		private static function createClassMetadata( metaXml : XML ):ClassMetadata 
		{	
			// retrieve class type and alias
			var classType : String = metaXml.@type;
			var classAlias : String = getAliasFromMetadata(metaXml, classType);
			
			// construct ClassMetadata and return
			return new ClassMetadata(classAlias, classType);
		}
		
		/**
		 * Creates PropertyMetadata object from a variable or accessor's XML description. 
		 * Retrieves the type name, and alias from metadata, if available.
		 */
		private static function createPropertyMetadata( metaXml : XML ):PropertyMetadata
		{
			// retrieve prop type, name and alias
			var propName : String = metaXml.@name;
			var propType : String = metaXml.@type;
			var propAlias : String = getAliasFromMetadata(metaXml, propName);
			var implicitCollection : Boolean = hasImplicitMetadata(metaXml);
			
			// construct PropertyMetadata and return
			return new PropertyMetadata(propName, propType, propAlias, implicitCollection);
		}
		
		/**
		 * Creates and adds a PropertyMetadata object for each item in the property xml list.
		 * These will be the variable items or accessor items.
		 */
		private static function createPropertiesFromList( classMetadata : ClassMetadata, propertyList : XMLList ):void {
			// build propeties from each XML item in the propertyList the accessors
			var prop : PropertyMetadata;
			for each( var propertyXml : XML in propertyList) {
				prop = createPropertyMetadata(propertyXml);
				classMetadata.addProperty(prop);
			}
		}
		
		/**
		 * Calls describeType() to retrieve class metadata from the <factory> element.
		 */
		private static function getClassMetadata( clazz : Class ):XML
		{
			// call describetype for xml
			var meta : XML = describeType(clazz);
			
			// we really want the factory element, if not, we got an instance, bad?
			if (meta.factory == undefined) throw new Error("AsStream InitializationError: AsStream must be initialized with AS Classes to create mappings!");
			
			return meta.factory[0];
		}
		
		/**
		 * Looks for the [AsStreamAlias] metadata to retrieve the Alias name. Returns a normal
		 * fully qualified path representation of the defaultName if supplied. 
		 */
		private static function getAliasFromMetadata( metaXml : XML, defaultName : String ) : String
		{
			// try to retrieve alias from metadata
			if (metaXml.metadata != undefined && metaXml.metadata.( @name== ALIAS_KEY ).length() > 0) {
				// grab metadata xml	
				var aliasXml : XML = metaXml.metadata.( @name == ALIAS_KEY )[ 0 ];
				
				// grab the arg value, look under 'name' or ''
				var alias : String =alias = getMetadataArgValue(aliasXml, "name");
				if (alias == "") alias = getMetadataArgValue(aliasXml, "");
				
				// return alias
				return alias;
			} else {
				// or return type as normal fully qualified name
				return defaultName.replace("::",".");
			}
			
			return alias;
		}
		
		/**
		 * Looks for the [AsStreamImplicit] metadata to see if a collection is marked as implicit,
		 * meaning there will be no wrapping element. 
		 */
		private static function hasImplicitMetadata( metaXml : XML ) : Boolean
		{
			// try to retrieve implicit from metadata
			if (metaXml.metadata != undefined && metaXml.metadata.( @name== IMPLICIT_KEY ).length() > 0) {
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * Retrieves a value from a metadata XML element. 
		 */
		private static function getMetadataArgValue( metadata : XML, argName : String ):String
		{
			return metadata.arg.( @key == argName ).@value;
		}

	}
}