<cfcomponent output="false" name="orderItemBean" hint="Container Object For Core Order Item Information">
	
	<cfset variables.instance = structnew() />
	<cfset variables.instance.ExpectedShipDate = "" />
	<cfset variables.instance.isPackage = 0 />
	<cfset variables.instance.isTaxable = 0 />
	<cfset variables.instance.Notes = "" />
	<cfset variables.instance.ParentPriceIncrease = 0 />
	<cfset variables.instance.ParentSkuID = 0 />
	<cfset variables.instance.Price = 0 />
	<cfset variables.instance.Quantity = "" />
	<cfset variables.instance.PriceExtended = 0 />
	<cfset variables.instance.PriceDetail = "" />
	<cfset variables.instance.ProductID = "" />
	<cfset variables.instance.SkuID = "" />
	<cfset variables.instance.Taxes = arrayNew() />
	<cfset variables.instance.TotalTaxes = 0 />
	<cfset variables.instance.TotalTaxRate = 0 />
	
</cfcomponent>