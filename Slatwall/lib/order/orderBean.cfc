<cfcomponent output="false" name="orderBean" hint="Container Object For Core Order Information">
	
	<cfset variables.instance = structnew() />
	<cfset variables.instance.OrderNumber = 1 />
	<cfset variables.instance.TerminalID = "" />
	<cfset variables.instance.WarehouseID = "" />
	<cfset variables.instance.OrderType = "" />
	<cfset variables.instance.OrderStatus = "" />
	<cfset variables.instance.Customer = "" />					<!--- Component --->
	<cfset variables.instance.BillingAddress = "" />			<!--- Component --->
	<cfset variables.instance.ShippingAddress = "" />			<!--- Component --->
	<cfset variables.instance.ShippingMethod = "" />			<!--- Component --->
	<cfset variables.instance.OrderItems = arrayNew(1) />		<!--- Array Of Components --->
	<cfset variables.instance.PaymentMethods = arrayNew(1) />	<!--- Array Of Components --->
	
	
</cfcomponent>