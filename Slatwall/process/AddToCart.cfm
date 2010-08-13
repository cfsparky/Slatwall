<cfif Form.AddToCartSkuId neq "">
	<cfset ThisSku = application.slat.skuManager.read(SkuID=Form.AddToCartSkuId) />
	<cfif Form.AddToCartProductId eq "">
		<cfset Form.AddToCartProductId = ThisSku.getProductID() />
	</cfif>
	<!---
	<cfif ThisSku.getLivePrice() gt 2000>
		<cfset application.Slat.cartManager.addCartItem(
			SkuID=form.AddToCartSkuId,
			ProductID=form.AddToCartProductId,
			Quantity=form.AddToCartQuantity,
			BillingID=Form.AddToCartBillingID,
			ShippingID=Form.AddToCartShippingID,
			ParentID=Form.AddToCartParentID,
			IsKit=0,
			IsPackage=1,
			ExpectedShipDate=Form.AddToCartExpectedShipDate,
			Notes=Form.AddToCartNotes,
			isTaxable=Form.AddToCartIsTaxable
		) />
		<cfset application.Slat.cartManager.addCartItem(
			SkuID="1404",
			ProductID="270",
			Quantity=1,
			BillingID=Form.AddToCartBillingID,
			ShippingID=Form.AddToCartShippingID,
			ParentID=form.AddToCartSkuId,
			IsKit=0,
			IsPackage=0,
			ExpectedShipDate=Form.AddToCartExpectedShipDate,
			Notes=Form.AddToCartNotes,
			isTaxable=Form.AddToCartIsTaxable
		) />
	<cfelse>
		This is where regular
	</cfif>
	--->
		<cfset application.Slat.cartManager.addCartItem(
			SkuID=form.AddToCartSkuId,
			ProductID=form.AddToCartProductId,
			Quantity=form.AddToCartQuantity,
			BillingID=Form.AddToCartBillingID,
			ShippingID=Form.AddToCartShippingID,
			ParentID=Form.AddToCartParentID,
			IsKit=Form.AddToCartIsKit,
			IsPackage=Form.AddToCartIsPackage,
			ExpectedShipDate=Form.AddToCartExpectedShipDate,
			Notes=Form.AddToCartNotes,
			isTaxable=Form.AddToCartIsTaxable
		) />
	
<cfelse>
	
</cfif>