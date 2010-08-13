<cfset application.Slat.cartManager.updateCartShippingMethod(
	CartShippingAddressID = Form.ShippingAddressID,
	Carrier = Form.ShippingCarrier,
	Method = Form.ShippingMethod,
	Cost = Form.ShippingCost
) />