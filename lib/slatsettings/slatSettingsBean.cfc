<cfcomponent output="false" name="slatSettingsBean" hint="">
	
	<!--- Set From Other Mura Settings --->
	<cfset variables.instance.PluginPath=""/>
	<cfset variables.instance.PluginId=0 />
	
	<!--- Set From Settings DB Table --->
	<cfset variables.instance.IntegrationType=""/>
	<cfset variables.instance.IntegrationDSN=""/>
	<cfset variables.instance.IntegrationDBUsername=""/>
	<cfset variables.instance.IntegrationDBPassword=""/>
	
	<!--- Set From Other DB Tabels --->
	<cfset variables.instance.AllCountriesQuery = "" />
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getPluginPath" returntype="string" access="public" output="false" hint="">
		<cfreturn variables.instance.PluginPath />
	</cffunction>	
	<cffunction name="setPluginPath" access="public" output="false">
		<cfargument name="PluginPath" type="string" required="true" />
		<cfset variables.instance.PluginPath = trim(arguments.PluginPath) />
	</cffunction>
	
	<cffunction name="getPluginID" returntype="numeric" access="public" output="false" hint="">
		<cfreturn variables.instance.PluginID />
	</cffunction>	
	<cffunction name="setPluginID" access="public" output="false">
		<cfargument name="PluginID" type="numeric" required="true" />
		<cfset variables.instance.PluginID = trim(arguments.PluginID) />
	</cffunction>
	
	<cffunction name="getIntegrationType" returntype="string" access="public" output="false" hint="">
		<cfreturn variables.instance.IntegrationType />
	</cffunction>
	<cffunction name="setIntegrationType" access="private" output="false">
		<cfargument name="IntegrationType" type="string" required="true" />
		<cfset variables.instance.IntegrationType = trim(arguments.IntegrationType) />
	</cffunction>
	
	<cffunction name="getIntegrationDSN" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.IntegrationDSN />
    </cffunction>
    <cffunction name="setIntegrationDSN" access="private" output="false">
    	<cfargument name="IntegrationDSN" type="string" required="true" />
    	<cfset variables.instance.IntegrationDSN = trim(arguments.IntegrationDSN) />
    </cffunction>
    
	<cffunction name="getIntegrationDBUsername" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.IntegrationDBUsername />
    </cffunction>
    <cffunction name="setIntegrationDBUsername" access="private" output="false">
    	<cfargument name="IntegrationDBUsername" type="string" required="true" />
    	<cfset variables.instance.IntegrationDBUsername = trim(arguments.IntegrationDBUsername) />
    </cffunction>
    
	<cffunction name="getIntegrationDBPassword" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.IntegrationDBPassword />
    </cffunction>
    <cffunction name="setIntegrationDBPassword" access="private" output="false">
    	<cfargument name="IntegrationDBPassword" type="string" required="true" />
    	<cfset variables.instance.IntegrationDBPassword = trim(arguments.IntegrationDBPassword) />
    </cffunction>
	
	<cffunction name="set" access="package" output="false">
		<cfargument name="record" type="any" required="true">
		
		<cfloop query="record">
			<cfset evaluate("set#record.SettingName#('#record.SettingValue#')") />
		</cfloop>
	</cffunction>
	
	<cffunction name="getAllCountriesQuery" access="public" output="false" returntype="Query">
		<cfif not isQuery(variables.instance.AllCountriesQuery)>
			<cfquery name="AllContries" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
				SELECT
					*
				FROM
					tslatcountries
				WHERE
					active = 1
				ORDER BY
					CountryDisplayName asc
			</cfquery>
			<cfset variables.instance.AllCountriesQuery = AllContries />
		</cfif>
		
		<cfreturn variables.instance.AllCountriesQuery />
	</cffunction> 
	
	<cffunction name="getCountryQuery" access="public" output="false" returntype="Query">
		<cfargument name="CountryCode" required="true" />
		
		<cfquery name="Country" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				*
			FROM
				tslatcountries
			WHERE
				CountryCode = '#arguments.CountryCode#'
		</cfquery>
	
		<cfreturn Country />
	</cffunction> 
	
	<cffunction name="getStatesByCountryCodeQuery" access="public" output="false" returntype="Query">
		<cfargument name="CountryCode" required="true" />
		
		<cfquery name="StatesByCountryCode" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				*
			FROM
				tslatstates
			WHERE
				CountryCode = '#arguments.CountryCode#'
		</cfquery>
		
		<cfreturn StatesByCountryID />
	</cffunction> 
</cfcomponent>
