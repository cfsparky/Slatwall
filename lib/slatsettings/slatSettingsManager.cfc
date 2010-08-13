<cfcomponent output="false" name="slatSettingsManager" hint="">
	
	<cffunction name="init" returntype="any" output="false" access="public">
		<cfargument name="slatSettingsDAO" type="any" required="yes"/>
		
		<cfset variables.DAO=arguments.slatSettingsDAO />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="read" access="public" returntype="any" output="false">
		<cfargument name="siteid" type="String" />		
		
		<cfreturn variables.DAO.read(arguments.siteid) />
	</cffunction>
	
</cfcomponent>