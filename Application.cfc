<cfcomponent extends="framework">
	
<cfinclude template="../../config/applicationSettings.cfm">
<cfinclude template="../../config/mappings.cfm">
<cfinclude template="../mappings.cfm">
<cfinclude template="fw1Config.cfm">

<cffunction name="setupApplication" output="false">
	<cfif not structKeyExists(request,"pluginConfig")>
		<cfinclude template="../../config/settings.cfm">
		<cfinclude template="plugin/config.cfm" />
	</cfif>	
	<cfset setBeanFactory(request.pluginConfig.getApplication(purge=false))>
</cffunction>

<cffunction name="isAdminRequest">
	<cfreturn not structKeyExists(request,"servletEvent")>
</cffunction>

<cffunction name="secureRequest" output="false">
	<cfif isAdminRequest() and not isUserInRole('S2')>
		<cfif not structKeyExists(session,"siteID") or not application.permUtility.getModulePerm(getBeanFactory("pluginConfig").getValue('moduleID'),session.siteid)>
			<cfif cgi.REMOTE_ADDR neq "70.166.5.85" and cgi.REMOTE_ADDR neq "70.166.12.200" and LEFT(cgi.REMOTE_ADDR, 7) neq "192.168">
				<cflocation url="#application.configBean.getContext()#/admin/" addtoken="false">
			</cfif>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="setupRequest" output="false">
	
	<cfif isDefined('url.returnFormat')>
		<cfif url.returnFormat neq 'json'>
			<cfset secureRequest()>
		</cfif>
	<cfelse>
		<cfset secureRequest()>
	</cfif>
	
	<cfset SlatGlobalRequestStart() />
	<cfset variables.framework.baseURL="http://#cgi.http_host##application.slatsettings.getSetting('PluginPath')#/">
</cffunction>

<cffunction name="setupSession" output="false">
	<!--- START: SET ALL SESSION VARIABLE DEFAULTS --->
	<cfparam name="Session.LastCrumb" type="string" default="" />
	<cfparam name="Session.Slat" type="struct" default="#structNew()#" />
	<cfparam name="Session.Slat.Cart" type="struct" default="#structNew()#" />
	<cfparam name="Session.Slat.Cart.BillingAddresses" type="array" default="#arrayNew(1)#" />
	<cfparam name="Session.Slat.Cart.PaymentMethods" type="array" default="#arrayNew(1)#" />
	<cfparam name="Session.Slat.Cart.ShippingAddresses" type="array" default="#arrayNew(1)#" />
	<cfparam name="Session.Slat.Cart.ShippingMethods" type="array" default="#arrayNew(1)#" />
	<cfparam name="Session.Slat.Cart.Items" type="array" default="#arrayNew(1)#" />
	<cfparam name="Session.Slat.Cart.Coupons" type="array" default="#arrayNew(1)#" />
	<cfparam name="Session.Slat.Cart.GuestCheckout" type="numeric" default=0 />
	<cfparam name="Session.Slat.Customer.ShipToAddresses" type="array" default="#arrayNew(1)#" />
	<cfparam name="Session.Slat.Customer.BillToAddresses" type="array" default="#arrayNew(1)#" />
	<cfparam name="Session.Slat.Customer.PamentMethods" type="array" default="#arrayNew(1)#" />
	<cfparam name="Session.Slat.Messages" type="array" default="#arrayNew(1)#" />
	
	<cfif not ArrayLen(Session.Slat.Cart.BillingAddresses)>
		<cfset BillingAddress = structNew() />
		<cfset BillingAddress.FirstName = "" />
		<cfset BillingAddress.LastName = "" />
		<cfset BillingAddress.PhoneNumber = "" />
		<cfset BillingAddress.Email = "" />
		<cfset BillingAddress.Country = "US" />
		<cfset BillingAddress.StreetAddress = "" />
		<cfset BillingAddress.Street2Address = "" />
		<cfset BillingAddress.City = "" />
		<cfset BillingAddress.State = "" />
		<cfset BillingAddress.Locality = "" />
		<cfset BillingAddress.PostalCode = "" />
		<cfset Session.Slat.Cart.BillingAddresses[1] = BillingAddress />
	</cfif>
	<cfif not ArrayLen(Session.Slat.Cart.ShippingAddresses)>
		<cfset ShippingAddress = structNew() />
		<cfset ShippingAddress.FirstName = "" />
		<cfset ShippingAddress.LastName = "" />
		<cfset ShippingAddress.PhoneNumber = "" />
		<cfset ShippingAddress.Email = "" />
		<cfset ShippingAddress.Country = "US" />
		<cfset ShippingAddress.StreetAddress = "" />
		<cfset ShippingAddress.Street2Address = "" />
		<cfset ShippingAddress.City = "" />
		<cfset ShippingAddress.State = "" />
		<cfset ShippingAddress.Locality = "" />
		<cfset ShippingAddress.PostalCode = "" />
		<cfset Session.Slat.Cart.ShippingAddresses[1] = ShippingAddress />
	</cfif>
	<cfif not ArrayLen(Session.Slat.Cart.ShippingMethods)>
		<cfset CartShippingMethod = structNew() />
		<cfset CartShippingMethod.Carrier = "" />
		<cfset CartShippingMethod.Method = "" />
		<cfset CartShippingMethod.Cost = 0 />
		<cfset CartShippingMethod.DeliveryTime = "" />
		<cfset Session.Slat.Cart.ShippingMethods[1] = CartShippingMethod />
	</cfif>
	<cfdump var="#session#" />
</cffunction>

<!---
<cffunction name="SlatApplicationStart" output="false">
	<cfargument name="$">
		
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
</cffunction>
--->

<cffunction name="SlatGlobalRequestStart" output="false">
	<cfif not isDefined('Session.Slat')>
		<cfset setupSession() />
	</cfif>
	
	<cfset request.Slat = structNew() />
	<cfset request.Slat.queryOrganizer = application.slat.utilityManager.getQueryOrganizerFromCollection(Collection=url) />
	
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
</cffunction>

<cffunction name="SlatFERenderStart" output="false" returntype="any">
	<cfset var I = 0 />
	<cfset var ValuePair = "" />
	<cfset var FilterProperty = "" />
	<cfset var RangeProperty = "" />
	<cfset var HTMLHead = "" />
	
	<cfparam name="form.slatProcess" default="" />
	<cfparam name="form.Process" default="" />							<!--- Depreciated --->
	<cfparam name="form.onSuccess" default="" />
	<cfparam name="form.onError" default="" />
	
	<cfparam name="form.AddToCartSkuID" default="" />
	<cfparam name="form.AddToCartQuantity" default="" />
	<cfparam name="form.AddToCartProductID" default="" />
	<cfparam name="form.RemoveFromCartSkuID" default="" />
	
	<cfparam name="form.LoginUsername" default="" />
	<cfparam name="form.LoginPassword" default="" />
	
	<cfparam name="form.GuestEmail" default="" />
	
	<cfparam name="form.ShippingAddressID" default="1" />
	<cfparam name="form.ShippingFirstName" default="" />
	<cfparam name="form.ShippingLastName" default="" />
	<cfparam name="form.ShippingEmail" default="" />
	<cfparam name="form.ShippingPhoneNumber" default="" />
	<cfparam name="form.ShippingCountry" default="US" />
	<cfparam name="form.ShippingStreetAddress" default="" />
	<cfparam name="form.ShippingStreet2Address" default="" />
	<cfparam name="form.ShippingCity" default="" />
	<cfparam name="form.ShippingState" default="" />
	<cfparam name="form.ShippingLocality" default="" />
	<cfparam name="form.ShippingPostalCode" default="" />
	<cfparam name="form.ShippingCarrier" default="" />
	<cfparam name="form.ShippingMethod" default="" />
	
	<cfparam name="form.BillingAddressID" default="1" />
	<cfparam name="form.BillingFirstName" default="" />
	<cfparam name="form.BillingLastName" default="" />
	<cfparam name="form.BillingEmail" default="" />
	<cfparam name="form.BillingPhoneNumber" default="" />
	<cfparam name="form.BillingCountry" default="" />
	<cfparam name="form.BillingStreetAddress" default="" />
	<cfparam name="form.BillingStreet2Address" default="" />
	<cfparam name="form.BillingCity" default="" />
	<cfparam name="form.BillingState" default="" />
	<cfparam name="form.BillingLocality" default="" />
	<cfparam name="form.BillingPostalCode" default="" />
	
	<cfparam name="form.PaymentAmount" default="" />
	<cfparam name="form.PaymentCardHolderName" default="" />
	<cfparam name="form.PaymentCardNumber" default="" />
	<cfparam name="form.PaymentExpirationMonth" default="" />
	<cfparam name="form.PaymentExpirationYear" default="" />
	<cfparam name="form.PaymentType" default="" />
	<cfparam name="form.PaymentSecurityCode" default="" />
	
	<cfparam name="form.AddToCartSkuId" default="" />
	<cfparam name="form.AddToCartProductId" default="" />
	<cfparam name="form.AddToCartQuantity" default=1 />
	<cfparam name="form.AddToCartBillingID" default=1 />
	<cfparam name="form.AddToCartShippingID" default=1 />
	<cfparam name="form.AddToCartParentID" default=0 />
	<cfparam name="form.AddToCartIsKit" default=0 />
	<cfparam name="form.AddToCartIsPackage" default=0 />
	<cfparam name="form.AddToCartExpectedShipDate" default="" />
	<cfparam name="form.AddToCartNotes" default="" />
	<cfparam name="form.AddToCartIsTaxable" default=1 />
	
	<cfparam name="form.NewUserFirstName" default="" />
	<cfparam name="form.NewUserLastName" default="" />
	<cfparam name="form.NewUserEMail" default=1 />
	<cfparam name="form.NewUserPassword" default=1 />
	
	<cfparam name="form.GuestAccountPassword" default="" />
	
	<cfparam name="form.CommentID" default="" />
	<cfparam name="form.ContentID" default="" />
	<cfparam name="form.Review" default="" />
	<cfparam name="form.Name" default="" />
	<cfparam name="form.UserID" default="" />
	
	<cfif isAdminRequest()>
		<cfset secureRequest()>
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
	<cfif isDefined('form.slatProcess')>
		<cfif form.slatProcess neq ''>
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
	</cfif>
	<!--- END: ALL FRONT END FORM LOGIC --->
	
	<!--- Set Request.Slat.Product --->
	<cfset request.Slat.Product = "">
	<cfif isDefined('url.ProductID')>
		<cfset request.Slat.Product = application.Slat.productManager.read('#url.ProductID#') />
	</cfif>
	
	<cfif not isAdminRequest()>
		<cfif request.contentRenderer.getTemplate() eq "defaultCategory.cfm">
			<cfset loadSlatProducts(UseContentFilter=1) />
		<cfelseif request.contentRenderer.getTemplate() eq "defaultSearch.cfm">
			<cfset loadSlatProducts(UseContentFilter=0) />
		</cfif>

		<!--- Set HTML Head Elements --->
		<cfsavecontent variable="HTMLHead">
			<cfoutput>
				<cfajaxproxy cfc="Slat.lib.ajax.ajaxManager" jsclassname="ajaxManager" />
				<script language="Javascript" type="text/javascript" src="#application.SlatSettings.getSetting('PluginPath')#/js/slatwall.js"></script>
				<link rel="stylesheet" type="text/css" href="#application.SlatSettings.getSetting('PluginPath')#/css/slatwall_toolbar.css" />
				<link rel="stylesheet" type="text/css" href="#application.SlatSettings.getSetting('PluginPath')#/css/slatwall.css" />
			</cfoutput>
		</cfsavecontent>
	</cfif>
	
	<cfhtmlhead text="#HTMLHead#">
</cffunction>

<!---
<cffunction name="SlatFERenderEnd" output="false">
	<cfargument name="$">
	
	<cfdump var="#application#" />
	<cfabort />
		
	<cfset var toolbaradd = "" />
	<cfsavecontent variable="toolbaradd">
		<cfoutput>
		#renderView(arguments.$,'toolbar')#
		</cfoutput>		
	</cfsavecontent>
	
	
	<!--- append script to body --->
	<cfset newContent = replaceNoCase( $.getValue( "__MuraResponse__" ), "</body>", toolbaradd & "</body>" ) />
	
	<!--- reset the muraresponse with the script --->
	<cfset $.setValue( "__MuraResponse__", newContent ) />
</cffunction>
--->


<cffunction name="loadSlatProducts" output="false">
	<cfargument name="UseContentFilter" default=1 />
		
	
	
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

<cffunction name="getExternalSiteLink" output="false" returntype="String">
	<cfargument name="Address" />
	<cfreturn #buildURL(action='external.site', queryString='es=#arguments.Address#')# />
</cffunction>


</cfcomponent>