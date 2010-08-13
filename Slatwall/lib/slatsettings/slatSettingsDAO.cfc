<cfcomponent output="false" name="slatSettingsDAO" hint="">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getBean" access="public" returntype="Any">
		<cfreturn createObject("component","slatSettingsBean").init()>
	</cffunction>
	
	<cffunction name="read" access="package" output="false" retruntype="Any">
		<cfargument name="siteid" default="default" />
		<cfset var settingsBean=getBean() />
		
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				SettingName as 'SettingName',
				SettingType as 'SettingType',
				SettingValue as 'SettingValue'
			FROM
				tslatsettings
			WHERE
				siteid = '#arguments.siteid#'
		</cfquery>

		<cfif rs.recordcount>
			<cfset settingsBean.set(rs) />
		</cfif>

		<cfreturn settingsBean />
	</cffunction>

</cfcomponent>