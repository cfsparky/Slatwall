<cfcomponent output="false" name="skuGateway" hint="">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSkusByProductID" access="package" output="false" retruntype="query">
		<cfargument name="ProductID" type="string" />

		<cfset var rs = application.slat.integrationManager.getSkusByProductIDQuery(arguments.ProductID) />
		
		<cfreturn rs />
	</cffunction>

	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>