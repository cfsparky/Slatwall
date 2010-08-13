<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	
	<!--- Include FW/1 configuration that is shared between then adapter and the application. --->
	<cfinclude template="fw1Config.cfm">
	
	<cffunction name="doEvent">
		<cfargument name="$">
		<cfargument name="action" type="string" required="false" default="" hint="Optional: If not passed it looks into the event for a defined action, else it uses the default"/>
		
		<cfset var result = "" />
		<cfset var savedEvent = "" />
		<cfset var savedAction = "" />
		<cfset var fw1 = createObject("component","#pluginConfig.getPackage()#.Application") />
		
		<!--- Create a Mura struct in the url scope to pass stuff to FW/1 --->
		<cfset url.Mura = StructNew() />
		<!--- Put the current path into the url struct, to be used by FW/1 --->
		<cfset url.Mura.currentPath = CGI.SCRIPT_NAME & "/" & $.event('currentFilename') & "/" />
		<!--- Put the event url struct, to be used by FW/1 --->
		<cfset url.Mura.$ = $ />
		
		<cfif not len( arguments.action )>
			<cfif len(arguments.$.event(variables.framework.action))>
				<cfset arguments.action=arguments.$.event(variables.framework.action)>
			<cfelse>
				<cfset arguments.action=variables.framework.home>
			</cfif>
		</cfif>
		
		<!--- put the action passed into the url scope, saving any pre-existing value --->
		<cfif StructKeyExists(request, variables.framework.action)>
			<cfset savedEvent = request[variables.framework.action] />
		</cfif>
		<cfif StructKeyExists(url,variables.framework.action)>
			<cfset savedAction = url[variables.framework.action] />
		</cfif>
		
		<cfset url[variables.framework.action] = arguments.action />
				
		<!--- call the frameworks onRequestStart --->
		<cfset fw1.onRequestStart(CGI.SCRIPT_NAME) />
		
		<!--- call the frameworks onRequest --->
		<!--- we save the results via cfsavecontent so we can display it in mura --->
		<cfsavecontent variable="result">
			<cfset fw1.onRequest(CGI.SCRIPT_NAME) />
		</cfsavecontent>
		
		<!--- restore the url scope --->
		<cfif structKeyExists(url,variables.framework.action)>
			<cfset structDelete(url,variables.framework.action) />
		</cfif>
		<!--- if there was a passed in action via the url then restore it --->
		<cfif Len(savedAction)>
			<cfset url[variables.framework.action] = savedAction />
		</cfif>
		<!--- if there was a passed in request event then restore it --->
		<cfif Len(savedEvent)>
			<cfset request[variables.framework.action] = savedEvent />
		</cfif>
		
		<!--- remove the content from the request scope --->
		<!--- at this point if anything needed to be stored it should have been done so by pushing stored elements into the mura event for later use --->
		<cfset structDelete( request, "context" )>
		<cfset structDelete( request, "serviceExecutionComplete" )>
		
		<!--- return the result --->
		<cfreturn result>
	</cffunction>

	<!--- this is the plugin hook in for mura --->

	<cffunction name="onSiteRequestStart">
        <cfargument name="$">
        
        <cfinvoke component="#pluginConfig.getPackage()#.Application" method="SlatGlobalRequestStart" />
        <!--- put the plugin into the event --->
        <cfset $[variables.framework.applicationKey]= this />
    </cffunction>
	
	<cffunction name="onRenderStart">
		<cfinvoke component="#pluginConfig.getPackage()#.Application" method="SlatFERenderStart" />
	</cffunction>
	
	<cffunction name="onRenderEnd">
		<cfargument name="event">
		<cfargument name="$">
		
		<cfset var toolbaradd = "" />
		
		<cfif cgi.REMOTE_ADDR eq "70.166.5.85" or cgi.REMOTE_ADDR eq "70.166.12.200" or LEFT(cgi.REMOTE_ADDR, 7) eq "192.168">
			
			
			<cfsavecontent variable="toolbaradd">
				<cfoutput>
					#doEvent($,'frontend.toolbar')#
				</cfoutput>		
			</cfsavecontent>
			
			<!--- append script to body --->
			<cfset newContent = replaceNoCase( event.getValue( "__MuraResponse__" ), "</body>", toolbaradd & "</body>" ) />
			
			<!--- reset the muraresponse with the script --->
			<cfset event.setValue( "__MuraResponse__", newContent ) />
		</cfif>
	</cffunction>

	<cffunction name="onApplicationLoad">
		<cfargument name="$">
		<cfset checkFrameworkConfig($)>
		<cfset request.pluginConfig=variables.pluginConfig>
		<!--- invoke onApplicationStart in the application.cfc so the framework can do its thing --->
		<cfinvoke component="#pluginConfig.getPackage()#.Application" method="onApplicationStart"  />
		
		<cfset var serviceFactory = "" />
		<cfset var xml = "" />
		<cfset var xmlPath = "#expandPath( '\plugins' )#/#request.pluginConfig.getDirectory()#/config/coldspring.xml" />
		<cffile action="read" file="#xmlPath#" variable="xml" />
		
		<!--- parse the xml and replace all [plugin] with the actual plugin mapping path --->
		<cfset xml = replaceNoCase( xml, "[plugin]", "plugins.#request.pluginConfig.getDirectory()#.", "ALL") />
		
		<!--- build Coldspring factory --->
		<cfset serviceFactory=createObject("component","coldspring.beans.DefaultXmlBeanFactory").init() />
		<cfset serviceFactory.loadBeansFromXmlRaw( xml ) />
		<cfset serviceFactory.setParent( $.getServiceFactory() ) />
		<cfset pluginConfig.getApplication().setValue( "serviceFactory", serviceFactory ) />
	
		<!--- Set Manager Components in Application Scope --->
		<cfset application.slatSettings = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "slatSettings" ) />
		<cfset application.Slat.ajaxManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "ajaxManager" ) />
		<cfset application.Slat.dbUpdate = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "dbUpdate" ) />
		<cfset application.Slat.cartManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "cartManager" ) />
		<cfset application.Slat.couponManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "couponManager" ) />
		<cfset application.Slat.dspManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "dspManager" ) />
		<cfset application.Slat.integrationManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "integrationManager" ) />
		<cfset application.Slat.logManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "logManager" ) />
		<cfset application.Slat.messageManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "messageManager" ) />
		<cfset application.Slat.orderManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "orderManager" ) />
		<cfset application.Slat.productManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "productManager" ) />
		<cfset application.Slat.shippingManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "shippingManager" ) />
		<cfset application.Slat.skuManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "skuManager" ) />
		<cfset application.Slat.vendorManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "vendorManager" ) />
		<cfset application.Slat.utilityManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "utilityManager" ) />
		<cfset application.Slat.userUtility = application.serviceFactory.getBean("userUtility") />
		
		<cfset application.slatSettings.setSetting('PluginPath', '/plugins/#pluginConfig.getDirectory()#') />
		<cfset application.slatSettings.setSetting('PluginID', #pluginConfig.getPluginID()#) />
		
		<cfset variables.pluginConfig.addEventHandler(this)>
	</cffunction>
	
	<cffunction name="onGlobalSessionStart">
		<cfargument name="$">

		<!--- invoke onApplicationStart in the application.cfc so the framework can do its thing --->
		<cfinvoke component="#pluginConfig.getPackage()#.Application" method="onSessionStart" />
	</cffunction>
	
	<cffunction name="checkFrameworkConfig" output="false">
	<cfargument name="$">
	<cfset var str="">
	<cfset var configPath="#expandPath('/plugins')#/#variables.pluginConfig.getDirectory()#/frameworkConfig.cfm">
	<cfset var lineBreak=chr(13) & chr(10)>
	<cfif variables.framework.applicationKey neq variables.pluginConfig.getPackage() & lineBreak>
		<cfset str='<cfset variables.framework=structNew()>' & lineBreak>
		<cfset str=str & '<cfset variables.framework.applicationKey="#variables.pluginConfig.getPackage()#">' & lineBreak>
		<cfset str=str & '<cfset variables.framework.base="/#variables.pluginConfig.getPackage()#">' & lineBreak>
		<cfset str=str & '<cfset variables.framework.usingsubsystems=false>' & lineBreak>
		<cfset str=str & '<cfset variables.framework.action="action">' & lineBreak>
		<cfset str=str & '<cfset variables.framework.home="main.default">' & lineBreak>
		<cfset $.getBean('fileWriter').writeFile(file=configPath, output=str)>
		<cfinclude template="frameworkConfig.cfm">
	</cfif>
	</cffunction>

</cfcomponent>