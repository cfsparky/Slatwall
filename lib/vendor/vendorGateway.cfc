<cfcomponent output="false" name="vendorGateway" hint="" extends="slat.lib.coregateway">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllVendorsQuery" access="package" output="false" retruntype="query">
		<cfreturn application.Slat.integrationManager.getAllVendorsQuery() />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>