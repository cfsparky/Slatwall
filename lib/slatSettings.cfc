<cfcomponent output="false" name="slatSettings" hint="">

	<cfset variables.Settings = structnew() />
	<cfset variables.Settings.AllCountriesQuery = "" />

	<cffunction name="init" returntype="any" output="false" access="public">
		<cfset var rs = querynew('empty') />
		
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				SettingName as 'SettingName',
				SettingType as 'SettingType',
				SettingValue as 'SettingValue'
			FROM
				tslatsettings
		</cfquery>

		<cfif rs.recordcount>
			<cfloop query="rs">
				<cfset setSetting(rs.SettingName, rs.SettingValue) />
			</cfloop>
		</cfif>

		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSetting" returntype="any" output="false" access="public">
		<cfargument name="Setting" required="true" />
		
		<cfreturn Evaluate("variables.Settings.#arguments.Setting#") />
	</cffunction>
	
	<cffunction name="setSetting" returntype="any" output="false" access="public">
		<cfargument name="Setting" required="true" />
		<cfargument name="SettingValue" required="true" />
		
		<cfset 'variables.Settings.#arguments.Setting#' = arguments.SettingValue />
	</cffunction>
	
	<cffunction name="getAllSettingsStruct" returntype="any" output="false" access="public">
		
		<cfreturn variables.Settings />
	</cffunction>
	
	<cffunction name="updateSetting" returntype="any" output="false" access="public">
		<cfargument name="Setting" required="true" />
		<cfargument name="SettingValue" required="true" />
		
		<cfset var rs = querynew('empty') />

		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			UPDATE tslatsettings set SettingValue = '#arguments.SettingValue#' where SettingName = '#arguments.Setting#'
		</cfquery>

		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getAllCountriesQuery" access="public" output="false" returntype="Query">
		<cfif not isQuery(variables.Settings.AllCountriesQuery)>
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
			<cfset variables.Settings.AllCountriesQuery = AllContries />
		</cfif>
		
		<cfreturn variables.Settings.AllCountriesQuery />
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
		
		<cfset var StatesByCountryCode = querynew('empty') />
		
		<cfquery name="StatesByCountryCode" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				*
			FROM
				tslatstates
			WHERE
				CountryCode = '#arguments.CountryCode#'
		</cfquery>
		
		<cfreturn StatesByCountryCode />
	</cffunction>
	
	<cffunction name="getCitiesByCountryCodeQuery" access="public" output="false" returntype="Query">
		<cfargument name="CountryCode" required="true" />
		
		<cfset var CitiesByCountryCode = querynew('empty') />
		
		<cfquery name="CitiesByCountryCode" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				*
			FROM
				tslatcities
			WHERE
				CountryCode = '#arguments.CountryCode#'
		</cfquery>
		
		<cfreturn CitiesByCountryCode />
	</cffunction> 
</cfcomponent>