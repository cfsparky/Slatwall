<cfcomponent output="false" name="integrationManager">

	<cffunction name="init" returntype="any" output="false" access="public">
		<cfargument name="integrationCelerant" type="any" required="yes"/>
		<cfargument name="integrationQuickbooks" type="any" required="yes"/>
		<cfargument name="integrationSlatwall" type="any" required="yes"/>
		
		<cfset variables.integration = arguments.integrationCelerant />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllProductsQuery" access="public" returntype="query" output="false">
		
		<cfreturn variables.integration.getAllProductsQuery() />
	</cffunction>
	
	<cffunction name="getProductQuery" access="public" returntype="query" output="false">
		<cfargument name="ProductID" type="String" />
		
		<cfreturn variables.integration.getProductQuery(arguments.ProductID) />
	</cffunction>
	
	<cffunction name="getSkusByProductIDQuery" access="public" returntype="query" output="false">
		<cfargument name="ProductID" type="String" />
		
		<cfreturn variables.integration.getSkusByProductIDQuery(arguments.ProductID) />
	</cffunction>
	
	<cffunction name="getSkuQuery" access="public" returntype="query" output="false">
		<cfargument name="SkuID" type="String" />
		
		<cfreturn variables.integration.getSkuQuery(arguments.SkuID) />
	</cffunction>

	<cffunction name="getGiftCardBalanceQuery" access="public" returntype="query" output="false">
		<cfargument name="GiftCardID" type="String" />
		
		<cfreturn variables.integration.getGiftCardBalanceQuery(arguments.GiftCardID) />
	</cffunction>
	
	<cffunction name="getCouponQuery" access="public" returntype="query" output="false">
		<cfargument name="CouponID" type="String" />
		
		<cfreturn variables.integration.getCouponQuery(arguments.CouponID) />
	</cffunction>
	
	<cffunction name="getAllCouponsQuery" access="public" returntype="any" output="false">
		
		<cfreturn variables.integration.getAllCouponsQuery() />
	</cffunction>
	
	<cffunction name="getAllVendorsQuery" access="public" returntype="any" output="false">
		
		<cfreturn variables.integration.getAllVendorsQuery() />
	</cffunction>
	
	<cffunction name="getVendorQuery" access="public" returntype="query" output="false">
		<cfargument name="VendorID" type="String" />
		
		<cfreturn variables.integration.getVendorQuery(arguments.VendorID) />
	</cffunction>
	
	<cffunction name="getAllBrandsQuery" access="public" returntype="any" output="false">
		
		<cfreturn variables.integration.getAllBrandsQuery() />
	</cffunction>
	
	<cffunction name="insertNewOrder" access="public" returntype="any" output="false">
		<cfargument name="Order" type="struct" required="true" />
	
		<cfreturn variables.integration.insertNewOrder(arguments.Order) />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfset var DebugStruct = structNew() />
		<cfset DebugStruct.Variables = variables />
		<cfset DebugStruct.integration = variables.integration.getDebug() />
		<cfreturn DebugStruct />
	</cffunction>
	
</cfcomponent>