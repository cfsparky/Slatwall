<cfcomponent output="false" name="addressBean" hint="Container Object For Core Address Information">
	
	<cfset variables.instance = structnew() />
	<cfset variables.instance.FirstName = "" />
	<cfset variables.instance.LastName = "" />
	<cfset variables.instance.PhoneNumber = "" />
	<cfset variables.instance.EMail = "" />
	<cfset variables.instance.StreetAddress = "" />
	<cfset variables.instance.Street2Address = "" />
	<cfset variables.instance.Locality = "" />
	<cfset variables.instance.City = "" />
	<cfset variables.instance.State = "" />
	<cfset variables.instance.PostalCode = "" />
	<cfset variables.instance.Country = "" />
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
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
	
	<cffunction name="getPhoneNumber" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.PhoneNumber />
    </cffunction>
    <cffunction name="setPhoneNumber" access="private" output="false" hint="">
    	<cfargument name="PhoneNumber" type="string" required="true" />
    	<cfset variables.instance.PhoneNumber = trim(arguments.PhoneNumber) />
    </cffunction>
    
    <cffunction name="getEMail" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.EMail />
    </cffunction>
    <cffunction name="setEMail" access="private" output="false" hint="">
    	<cfargument name="EMail" type="string" required="true" />
    	<cfset variables.instance.EMail = trim(arguments.EMail) />
    </cffunction>
	
	<cffunction name="getStreetAddress" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.StreetAddress />
    </cffunction>
    <cffunction name="setStreetAddress" access="private" output="false" hint="">
    	<cfargument name="StreetAddress" type="string" required="true" />
    	<cfset variables.instance.StreetAddress = trim(arguments.StreetAddress) />
    </cffunction>
    
    <cffunction name="getStreet2Address" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Street2Address />
    </cffunction>
    <cffunction name="setStreet2Address" access="private" output="false" hint="">
    	<cfargument name="Street2Address" type="string" required="true" />
    	<cfset variables.instance.Street2Address = trim(arguments.Street2Address) />
    </cffunction>
	
	<cffunction name="getLocality" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Locality />
    </cffunction>
    <cffunction name="setLocality" access="private" output="false" hint="">
    	<cfargument name="Locality" type="string" required="true" />
    	<cfset variables.instance.Locality = trim(arguments.Locality) />
    </cffunction>
	
	<cffunction name="getCity" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.City />
    </cffunction>
    <cffunction name="setCity" access="private" output="false" hint="">
    	<cfargument name="City" type="string" required="true" />
    	<cfset variables.instance.City = trim(arguments.City) />
    </cffunction>
	
	<cffunction name="getState" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.State />
    </cffunction>
    <cffunction name="setState" access="private" output="false" hint="">
    	<cfargument name="State" type="string" required="true" />
    	<cfset variables.instance.State = trim(arguments.State) />
    </cffunction>
	
	<cffunction name="getPostalCode" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.PostalCode />
    </cffunction>
    <cffunction name="setPostalCode" access="private" output="false" hint="">
    	<cfargument name="PostalCode" type="string" required="true" />
    	<cfset variables.instance.PostalCode = trim(arguments.PostalCode) />
    </cffunction>
	
	<cffunction name="getCountry" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Country />
    </cffunction>
    <cffunction name="setCountry" access="private" output="false" hint="">
    	<cfargument name="Country" type="string" required="true" />
    	<cfset variables.instance.Country = trim(arguments.Country) />
    </cffunction>

    
</cfcomponent>