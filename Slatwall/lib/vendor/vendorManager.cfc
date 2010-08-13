<cfcomponent output="false" name="vendorManager" hint="">
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="vendorDAO" type="any" required="yes"/>
		<cfargument name="vendorGateway" type="any" required="yes"/>
	
		<cfset variables.DAO=arguments.vendorDAO />
		<cfset variables.Gateway=arguments.vendorGateway />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="read" access="public" returntype="any" output="false">
		<cfargument name="VendorID" type="String" />
	
		<cfreturn variables.DAO.read(arguments.VendorID) />
	</cffunction>
	
	<cffunction name="getAllVendorsQuery" access="public" returntype="query" output="false">
		<cfreturn variables.Gateway.getAllVendorsQuery() />
	</cffunction>
	<!---
	<cffunction name="getVendorsByFilter" access="public" returntype="Query" output="false">
		<cfargument name="Filter" type="struct" default="#structNew()#" />
		<cfargument name="Range" type="struct" default="#structNew()#" />
		<cfargument name="Order" type="string" default="#structNew()#" />
		<cfargument name="Keyword" type="string" default="" />
		<cfargument name="KeywordWeight" type="struct" default="#structNew()#" />
		
		<cfretun application.slat.utilityManager.queryOrganizer(Query=getAllVendorsQuery(), Filter=arguments.Filter, Range=arguments.Range, Order=arguments.Order, Keyword=arguments.Keyword, KeywordWeight=arguments.KeywordWeight) />
	</cffunction>
	--->
	<cffunction name="getVendorIterator" access="public" output="false" returntype="any">
		<cfargument name="VendorQuery" type="any" required="true">
		
		<cfset var vendorIterator=createObject("component","vendorIterator").init() />
		<cfset vendorIterator.setQuery(arguments.VendorQuery) />
		<cfreturn vendorIterator />
	</cffunction>
	
</cfcomponent>
