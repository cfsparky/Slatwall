<cfcomponent extends="mura.iterator.queryIterator" output="false">
	
	<cffunction name="packageRecord" access="public" output="false" returntype="any">
		<cfset var sku=createObject("component","skuBean").init() />
		<cfset sku.set(queryRowToStruct(variables.records,currentIndex()))>
		
		<cfreturn sku>
	</cffunction>

</cfcomponent>