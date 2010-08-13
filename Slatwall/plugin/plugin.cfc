<cfcomponent output="false" extends="mura.plugin.plugincfc">
	<cffunction name="install" returntype="void" access="public" output="false">
		<cfset application.appInitialized = false>
		<cfinvoke component="dbUpdate" method="update">
			<cfinvokeargument name="ConfigDirectory" value="#expandPath( '\plugins' )#/Slat_#pluginConfig.getPluginID()#/config" />
			<cfinvokeargument name="RemoveTables" value="0" >
		</cfinvoke>
	</cffunction>
	
	<cffunction name="update" returntype="void" access="public" output="false">
		<cfset application.appInitialized = false>
		<cfinvoke component="dbUpdate" method="update">
			<cfinvokeargument name="ConfigDirectory" value="#expandPath( '\plugins' )#/Slat_#pluginConfig.getPluginID()#/config" />
			<cfinvokeargument name="RemoveTables" value="0" >
		</cfinvoke>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfset application.appInitialized = false>
		<cfinvoke component="dbUpdate" method="update">
			<cfinvokeargument name="ConfigDirectory" value="#expandPath( '\plugins' )#/Slat_#pluginConfig.getPluginID()#/config" />
			<cfinvokeargument name="RemoveTables" value=1 >
		</cfinvoke>
	</cffunction>
</cfcomponent>