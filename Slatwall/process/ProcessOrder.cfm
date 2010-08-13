<cfset Session.Slat.OrderConfirmation = application.slat.integrationManager.insertNewOrder(Order=Session.Slat.Order) />
<cfset application.slat.cartManager.createNewCartSession() >

<!--- SEND E-MAIL --->
<cfmail to="#Session.Slat.OrderConfirmation.BillingAddress.EMail#" bcc="greg@nytro.com" from="orders@nytro.com" subject="Nytro Order Confirmation: #Session.Slat.OrderConfirmation.OrderID#" Type="html" PORT="25" SERVER="127.0.0.1">
<html>
<body>
<strong>Nytro Multisport Order Confirmation</strong><br />
<br />
<strong>Order ID:</strong> #Session.Slat.OrderConfirmation.OrderID#<br />
<stong>Date:</strong> #Session.Slat.OrderConfirmation.OrderDateTime#<br />
<strong>Ship Via:</strong> #Application.Slat.shippingManager.getFriendlyShipMethodName(Session.Slat.OrderConfirmation.ShippingMethod.Method)#<br />
<br />
<strong>Ship To:</strong><br />
#Session.Slat.OrderConfirmation.ShippingAddress.FirstName# #Session.Slat.OrderConfirmation.ShippingAddress.LastName#<br />
#Session.Slat.OrderConfirmation.ShippingAddress.StreetAddress#<br />
#Session.Slat.OrderConfirmation.ShippingAddress.Street2Address#<br />
<cfif len(Session.Slat.OrderConfirmation.ShippingAddress.Locality)>#Session.Slat.OrderConfirmation.ShippingAddress.Locality#<br /></cfif>
#Session.Slat.OrderConfirmation.ShippingAddress.City#, #Session.Slat.OrderConfirmation.ShippingAddress.State# #Session.Slat.OrderConfirmation.ShippingAddress.PostalCode#<br />
#Session.Slat.OrderConfirmation.ShippingAddress.Country#<br />
<br />
<br />
<strong>Bill To:</strong><br />
#Session.Slat.OrderConfirmation.BillingAddress.FirstName# #Session.Slat.OrderConfirmation.BillingAddress.LastName#<br />
#Session.Slat.OrderConfirmation.BillingAddress.StreetAddress#<br />
#Session.Slat.OrderConfirmation.BillingAddress.Street2Address#<br />
<cfif len(Session.Slat.OrderConfirmation.BillingAddress.Locality)>#Session.Slat.OrderConfirmation.BillingAddress.Locality#<br /></cfif>
#Session.Slat.OrderConfirmation.BillingAddress.City#, #Session.Slat.OrderConfirmation.BillingAddress.State# #Session.Slat.OrderConfirmation.ShippingAddress.PostalCode#<br />
#Session.Slat.OrderConfirmation.BillingAddress.Country#<br />
<br />
<br />
<strong>Order Items:</strong>
<hr />
<cfloop array="#Session.Slat.OrderConfirmation.OrderItems#" Index="Item">
<cfset Product = application.Slat.productManager.read(Item.ProductID) />
<cfset SKU = application.Slat.skuManager.read(Item.SkuID) />
#Product.getBrand()# - #Product.getProductName()#<br />
#SKU.getAttributesString(NoHTML=1)#<br />
#DollarFormat(Item.Price)# | #Item.Quantity# | #DollarFormat(Item.PriceExtended)#<br />
<hr />
</cfloop>
<br />
<br />
<strong>Subtotal: </strong>#DollarFormat(Session.Slat.OrderConfirmation.TotalItems)#<br />
<strong>Tax: </strong>#DollarFormat(Session.Slat.OrderConfirmation.TotalTax)#<br />
<strong>Shipping: </strong>#DollarFormat(Session.Slat.OrderConfirmation.TotalShipping)#<br />

<strong>Total: </strong>#DollarFormat(Session.Slat.OrderConfirmation.Total)#<br />
</body>
</html>
</cfmail>
<!--- END SEND E-MAIL --->

<!--- IF GUEST PASSWORD EXISTS, CREATE ACCOUNT --->
<cfif Form.GuestAccountPassword neq "">
	<cfset ThisUser = #application.userManager.readByUsername(username='#Session.Slat.OrderConfirmation.BillingAddress.EMail#',siteid='default')# />
	<cfif ThisUser.getIsNew()>
		<cfset ThisUser.setSiteID('default') />
		<cfset ThisUser.setUsername(Session.Slat.OrderConfirmation.BillingAddress.EMail) />
		<cfset ThisUser.setPassword(Form.GuestAccountPassword) />
		<cfset ThisUser.setFname(Session.Slat.OrderConfirmation.BillingAddress.FirstName) />
		<cfset ThisUser.setLname(Session.Slat.OrderConfirmation.BillingAddress.LastName) />
		<cfset ThisUser.setEmail(Session.Slat.OrderConfirmation.BillingAddress.EMail) />
		<cfset ThisUser.setRemoteID(Session.Slat.OrderConfirmation.CustomerID) />
		<cfset ThisUser.save() />
	</cfif>
	<!---
	<cfset loginResults = application.Slat.userUtility.login(#Session.Slat.OrderConfirmation.BillingAddress.EMail#, #Form.GuestAccountPassword#, 'default') />
	
	<cfif not loginResults>
		<cfset application.slat.messageManager.addMessage(MessageCode="A02",FormName="CreateAccount",slatProcess="CreateAccount") />
	</cfif>
	--->
</cfif>
<cfset StructDelete(Session.Slat, "Order") />