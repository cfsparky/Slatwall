<cfcomponent output="false" name="vendorBean" hint="">

	<cfset variables.instance = structnew() />
	<cfset variables.instance.VendorID = "" />
	<cfset variables.instance.VendorName = "" />
	<cfset variables.instance.AccountNumber = "" />
	<cfset variables.instance.VendorWebsite = "" />
	<cfset variables.instance.PrimaryPhone = "" />

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getVendorID" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.VendorID />
    </cffunction>
    <cffunction name="setVendorID" access="private" output="false" hint="">
    	<cfargument name="VendorID" type="string" required="true" />
    	<cfset variables.instance.VendorID = trim(arguments.VendorID) />
    </cffunction>
    
	<cffunction name="getVendorName" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.VendorName />
    </cffunction>
    <cffunction name="setVendorName" access="private" output="false" hint="">
    	<cfargument name="VendorName" type="string" required="true" />
    	<cfset variables.instance.VendorName = trim(arguments.VendorName) />
    </cffunction>
	
	<cffunction name="getAccountNumber" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.AccountNumber />
    </cffunction>
    <cffunction name="setAccountNumber" access="private" output="false" hint="">
    	<cfargument name="AccountNumber" type="string" required="true" />
    	<cfset variables.instance.AccountNumber = trim(arguments.AccountNumber) />
    </cffunction>
    
	
	<cffunction name="getVendorWebsite" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.VendorWebsite />
    </cffunction>
    <cffunction name="setVendorWebsite" access="private" output="false" hint="">
    	<cfargument name="VendorWebsite" type="string" required="true" />
    	<cfset variables.instance.VendorWebsite = trim(arguments.VendorWebsite) />
    </cffunction>
	
	<cffunction name="getPrimaryPhone" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.PrimaryPhone />
    </cffunction>
    <cffunction name="setPrimaryPhone" access="private" output="false" hint="">
    	<cfargument name="PrimaryPhone" type="string" required="true" />
    	<cfset variables.instance.PrimaryPhone = trim(arguments.PrimaryPhone) />
    </cffunction>
    
    
	
	<cffunction name="set" returnType="void" output="false" access="package">
		<cfargument name="record" type="any" required="true">

		<cfif isquery(arguments.record)>
			<cfset setVendorID(arguments.record.VendorID) />
			<cfset setVendorName(arguments.record.VendorName) />
		<cfelseif isStruct(arguments.record)>
			<cfloop collection="#arguments.record#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.record[prop])") />
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
</cfcomponent>
