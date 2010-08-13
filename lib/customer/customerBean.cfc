<cfcomponent output="false" name="productBean" hint="Container Object For Core Customer Information">

	<cfset variables.instance = structnew() />
	<cfset variables.instance.CustomerID="" />
	<cfset variables.instance.FirstName="" />
	<cfset variables.instance.LastName="" />
	
	<cfset variables.instance.ProductAttributes=arraynew(1) />
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getCustomerID" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.CustomerID />
    </cffunction>
    <cffunction name="setCustomerID" access="private" output="false" hint="">
    	<cfargument name="CustomerID" type="string" required="true" />
    	<cfset variables.instance.CustomerID = trim(arguments.CustomerID) />
    </cffunction>
	
	<cffunction name="getFirstName" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.FirstName />
    </cffunction>
    <cffunction name="setFirstName" access="private" output="false" hint="">
    	<cfargument name="FirstName" type="string" required="true" />
    	<cfset variables.instance.FirstName = trim(arguments.FirstName) />
    </cffunction>
	
	<cffunction name="getLastName" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.LastName />
    </cffunction>
    <cffunction name="setLastName" access="private" output="false" hint="">
    	<cfargument name="LastName" type="string" required="true" />
    	<cfset variables.instance.LastName = trim(arguments.LastName) />
    </cffunction>

</cfcomponent>