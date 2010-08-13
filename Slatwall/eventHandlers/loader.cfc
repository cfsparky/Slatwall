<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	
	<cffunction name="onApplicationLoad" output="false" returntype="any">
		<cfargument name="event">
	
		<cfset var serviceFactory = "" />
		<cfset var xml = "" />
		<cfset var xmlPath = "#expandPath( '\plugins' )#/#pluginConfig.getDirectory()#/config/coldspring.xml" />
		<cffile action="read" file="#xmlPath#" variable="xml" />
		
		<!--- parse the xml and replace all [plugin] with the actual plugin mapping path --->
		<cfset xml = replaceNoCase( xml, "[plugin]", "plugins.#pluginConfig.getDirectory()#.", "ALL") />
		
		<!--- build Coldspring factory --->
		<cfset serviceFactory=createObject("component","coldspring.beans.DefaultXmlBeanFactory").init() />
		<cfset serviceFactory.loadBeansFromXmlRaw( xml ) />
		<cfset serviceFactory.setParent( event.getServiceFactory() ) />
		<cfset pluginConfig.getApplication().setValue( "serviceFactory", serviceFactory ) />
		
		<!--- Set Manager Components in Application Scope --->
		<cftry>
			<cfset application.Slat = structNew() />
			
			<cfset application.slatSettings = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "slatSettings" ) />
			<cfset application.Slat.ajaxManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "ajaxManager" ) />
			<cfset application.Slat.dbUpdate = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "dbUpdate" ) />
			<cfset application.Slat.cartManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "cartManager" ) />
			<cfset application.Slat.couponManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "couponManager" ) />
			<cfset application.Slat.dspManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "dspManager" ) />
			<cfset application.Slat.integrationManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "integrationManager" ) />
			<cfset application.Slat.logManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "logManager" ) />
			<cfset application.Slat.messageManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "messageManager" ) />
			<cfset application.Slat.productManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "productManager" ) />
			<cfset application.Slat.shippingManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "shippingManager" ) />
			<cfset application.Slat.skuManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "skuManager" ) />
			<cfset application.Slat.vendorManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "vendorManager" ) />
			<cfset application.Slat.utilityManager = pluginConfig.getApplication().getValue( "serviceFactory" ).getBean( "utilityManager" ) />
			<cfset application.Slat.userUtility = application.serviceFactory.getBean("userUtility") />
			
			<cfset application.slatSettings.setSetting('PluginPath', '/plugins/#pluginConfig.getDirectory()#') />
			<cfset application.slatSettings.setSetting('PluginID', #pluginConfig.getPluginID()#) />
			
			<cfcatch><cfoutput>#cfcatch.message#</cfoutput><cfabort /></cfcatch>
		</cftry>
		<cfset variables.pluginConfig.addEventHandler(this) />
	</cffunction>
	
	<cffunction name="onSlatStart" output="false" returntype="any">
		<cfargument name="event">
		<cfset var isAdminPage = 1 />
		<cfset var I = 0 />
		<cfset var ValuePair = "" />
		<cfset var FilterProperty = "" />
		<cfset var RangeProperty = "" />
		<cfset var HTMLHead = "" />
		
		<cfset request.Slat = structNew() />
		
		<cfif structKeyExists(event.getAllValues('Request'), 'contentrenderer')>
			<cfset isAdminPage = 0>
		</cfif>
		
		<cfinclude template="../DefaultParams.cfm" />
		
		<!--- REMOVE ON 8-16-2010 --->
		<cfif isdefined('url.O_LivePrice') and isdefined('url.F_OnTermSale') and isdefined('url.F_Brand')>
			<cfif url.O_LivePrice eq 'A' and url.F_OnTermSale eq '1' and url.F_Brand eq 'Fuelbelt'>
				<cflocation url="http://www.nytro.com/index.cfm/all-products/?O_LivePrice=A&F_OnTermSale=1&F_Brand=Watermans" addtoken="false" />
			</cfif>
		</cfif>
		
		<!--- Check for session messages and apply to current Request, Then Clear Session Messages --->
		<cfset request.Slat.Messages = arrayNew(1) />
		<cflock scope="session" timeout="10" type="readonly">
			<cfif structKeyExists(Session.Slat, "Messages")>
				<cfset Request.Slat.Messages = duplicate(Session.Slat.Messages) />
				<cfset Session.Slat.Messages = arrayNew(1) />
			</cfif>
		</cflock>
		
		<!--- START: ALL FRONT END FORM LOGIC --->
		<cfif form.slatProcess neq "">
			<cfloop list="#form.slatProcess#" delimiters="," index="I">
				<cfset application.Slat.logManager.addLog(LogType="Process: #I#") />
				<cfinclude template="#application.SlatSettings.getSetting('PluginPath')#/process/#I#.cfm" />
			</cfloop>
			
			<cfif Form.onSuccess neq "" and arrayLen(Request.Slat.Messages) eq 0>
				<cflocation url="#form.onSuccess#" addtoken="false" />
			<cfelseif Form.onError neq "" and arrayLen(Request.Slat.Messages) gt 0>
				<cfset Session.Slat.Messages = Request.Slat.Messages />
				<cflocation url="#Form.onError#" addtoken="false" />
			</cfif>
		</cfif>
		<!--- END: ALL FRONT END FORM LOGIC --->
		
		<!--- Set Request.Slat.Product --->
		<cfset request.Slat.Product = "">
		<cfif isDefined("url.ProductID")>
			<cfset request.Slat.Product = application.Slat.productManager.read('#url.ProductID#') />
		</cfif>
		
		<cfif not isAdminPage>
			<cfif request.contentRenderer.getTemplate() eq "defaultCategory.cfm" or request.contentRenderer.getTemplate() eq "defaultSearch.cfm">
				<cfset loadSlatProducts(UseContentFilter=1) />
			<cfelseif request.contentRenderer.getTemplate() eq "defaultSearch.cfm">
				<cfset loadSlatProducts(UseContentFilter=0) />
			</cfif>
		</cfif>
		
		<!--- Set HTML Head Elements --->
		<cfif isAdminPage>
			<cfsavecontent variable="HTMLHead">
				<cfoutput>
					<cfajaxproxy cfc="plugins.Slat_#application.SlatSettings.getSetting('PluginID')#.lib.ajax.ajaxManager" jsclassname="ajaxManager" />
					<script language="Javascript" type="text/javascript" src="/admin/js/tab-view.js"></script>
					<script language="Javascript" type="text/javascript" src="js/jquery.js"></script>
					<script language="Javascript" type="text/javascript" src="js/slatwall.js"></script>
					
					<link rel="stylesheet" type="text/css" media="screen" href="/admin/css/tab-view.css">
					<link rel="stylesheet" type="text/css" href="css/slatwall_admin.css" />
				</cfoutput>
			</cfsavecontent>
		<cfelse>
			<cfsavecontent variable="HTMLHead">
				
				<cfoutput>
					<cfajaxproxy cfc="plugins.#pluginConfig.getDirectory()#.lib.ajax.ajaxManager" jsclassname="ajaxManager" />
					<script language="Javascript" type="text/javascript" src="#application.SlatSettings.getSetting('PluginPath')#/js/slatwall.js"></script>
					<link rel="stylesheet" type="text/css" href="#application.SlatSettings.getSetting('PluginPath')#/css/slatwall_toolbar.css" />
					<link rel="stylesheet" type="text/css" href="#application.SlatSettings.getSetting('PluginPath')#/css/slatwall.css" />
				</cfoutput>
				
			</cfsavecontent>
		</cfif>
		
		<cfhtmlhead text="#HTMLHead#">
	</cffunction>
	
	<cffunction name="loadSlatProducts" output="false">
		<cfargument name="UseContentFilter" default=1 />
			
		<!--- Set Requst.Slat.Filter & Request.Slat.Range & Request.Slat.Order --->	
		<cfset request.Slat.Filter = structNew() />
		<cfset request.Slat.Range = structNew() />
		<cfset request.Slat.Order = structNew() />
		<cfset request.Slat.Order.Column = "DateFirstReceived" />
		<cfset request.Slat.Order.Direction = "D" />
		<cfloop collection="#url#" item="ValuePair">
			<cfif find("F_",ValuePair)>
				<cfset FilterProperty = Replace(ValuePair,"F_", "") />
				<cfif JavaCast("string", StructFind(url,ValuePair)) neq "">
					<cfset "request.Slat.Filter.#FilterProperty#" = JavaCast("string", StructFind(url,ValuePair)) />
				</cfif>
			</cfif>
			<cfif find("R_",ValuePair)>
				<cfset RangeProperty = Replace(ValuePair,"R_", "") />
				<cfif JavaCast("string", StructFind(url,ValuePair)) neq "">
					<cfset "request.Slat.Range.#RangeProperty#" = JavaCast("string", StructFind(url,ValuePair)) />
				</cfif>
			</cfif>
			<cfif find("O_",ValuePair)>
				<cfif ValuePair neq "O_Column" and ValuePair neq "O_Direction">
					<cfset request.Slat.Order.Column = Replace(ValuePair,"O_", "") />
					<cfset request.Slat.Order.Direction = JavaCast("string", StructFind(url,ValuePair)) />
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- Set Request.Slat.Keyword --->
		<cfset request.Slat.Keyword = "">
		<cfif isDefined("url.Keyword")>
			<cfset request.Slat.Keyword = url.Keyword />
		</cfif>
		
		<!--- Set Requst.Slat.Content --->
		<cfset request.Slat.Content = structNew() />
		<cfset request.Slat.Content.ActiveProductsOnly = 1 />
		<cfset request.Slat.Content.UseContentFilter = 1 />
		<cfset request.Slat.Content.ContentID = "" />
		<cfset request.Slat.Content.ContentPath = "" />
		
		<cfset request.Slat.Content.ContentID = request.contentBean.getContentID() />
		<cfset request.Slat.Content.ContentPath = request.contentBean.getPath() />	
		
		<cfif request.Slat.Content.ContentID eq "97A5D66F-237D-9C1A-03A8773481B6E59D">
			<cfset request.Slat.Content.UseContentFilter = 0 />
		</cfif>
		
		<cfif arguments.UseContentFilter>
			<cfset request.Slat.Content.ProductsQuery = application.Slat.productManager.getProductsInCategory(request.Slat.Content.ContentID, request.Slat.Content.ContentPath, 1, request.Slat.Order.Column, request.Slat.Order.Direction) />
		<cfelse>
			<cfset request.Slat.Content.ProductsQuery = application.slat.integrationManager.getAllProductsQuery() />
		</cfif>
		
		<cfset request.Slat.Content.ProductsByFilterQuery = application.Slat.productManager.getProductsByFilter(request.Slat.Content.ProductsQuery, request.Slat.Filter, request.Slat.Range, request.Slat.Keyword, request.Slat.Order.Column, request.Slat.Order.Direction, request.Slat.Content.ActiveProductsOnly) />
		
		<cfset request.Slat.Content.ProductsIterator = application.Slat.productManager.getProductIterator(request.Slat.Content.ProductsByFilterQuery) />
		
		<!--- Set Request.Slat.Pager --->
		<cfset request.Slat.Pager = structnew() />
		<cfset request.Slat.Pager.StartingProduct = 1 />
		<cfset request.Slat.Pager.EndingProduct = 1 />
		<cfset request.Slat.Pager.TotalProducts = 1 />
		<cfset request.Slat.Pager.ProductsPerPage = 16 />
		<cfset request.Slat.Pager.TotalPages = 1 />
		<cfif isDefined("url.P_Start")>
			<cfset request.Slat.Pager.StartingProduct = "#url.P_Start#" />
		</cfif>
		<cfif isDefined("url.P_Show")>
			<cfset request.Slat.Pager.ProductsPerPage = "#url.P_Show#" />
		</cfif>
		<cfset request.Slat.Pager.TotalProducts = request.Slat.Content.ProductsByFilterQuery.recordCount />
		<cfif request.Slat.Pager.TotalProducts gt 0>
			<cfset request.Slat.Pager.EndingProduct = request.Slat.Pager.StartingProduct + request.Slat.Pager.ProductsPerPage - 1 />
			<cfif request.Slat.Pager.EndingProduct gt request.Slat.Pager.TotalProducts>
				<cfset request.Slat.Pager.EndingProduct = request.Slat.Pager.TotalProducts />
			</cfif>
			<cfset request.Slat.Pager.TotalPages = round((request.Slat.Pager.TotalProducts/request.Slat.Pager.ProductsPerPage) + .4999) />
			
			<cfif request.Slat.Pager.TotalPages lt 1>
				<cfset request.Slat.Pager.TotalPages = 1>
			</cfif>
			<cfset request.Slat.Pager.CurrentPage = round(request.Slat.Pager.StartingProduct/request.Slat.Pager.ProductsPerPage)+1>
			<cfif request.Slat.Pager.CurrentPage lt 1>
				<cfset request.Slat.Pager.CurrentPage = 1>
			</cfif>
		</cfif>
		<cfset request.Slat.Content.ProductsIterator.setNextN(request.Slat.Pager.ProductsPerPage) />
		<cfset request.Slat.Content.ProductsIterator.setStartRow(request.Slat.Pager.StartingProduct) />
	</cffunction>
	
	<cffunction name="onRenderStart" output="false">
		<cfargument name="event">
		
		<cfset getPluginManager().announceEvent("onSlatStart", arguments.event) />
	</cffunction>


	<cffunction name="onRenderEnd" output="false" returntype="any">
		<cfargument name="event">
		
		<cfset var toolbaradd = "" />
		<cfsavecontent variable="toolbaradd">
			<cfinclude template="#application.SlatSettings.getSetting('PluginPath')#/toolbar.cfm" />		
		</cfsavecontent>
		
		<!--- append script to body --->
		<cfset newContent = replaceNoCase( event.getValue( "__MuraResponse__" ), "</body>", toolbaradd & "</body>" ) />
		
		<!--- reset the muraresponse with the script --->
		<cfset event.setValue( "__MuraResponse__", newContent ) />
	</cffunction>

</cfcomponent>

