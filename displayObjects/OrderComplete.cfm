<cfoutput>
	<cfif not structKeyExists(Session.Slat, "OrderConfirmation")>
		<div class="sdoOrderConfirmationExpired">
			This Page Has Expired.
		</div>
	<cfelse>
		<div class="sdoOrderConfirmation">
			<h3 class="title">Thank You For Your Order</h4>
			<div class="Details">
				<dl>
					<dt>Order Number</dt>
					<dd>#Session.Slat.OrderConfirmation.OrderID#</dd>
				</dl>
				<dl>
					<dt>Order Submitted</dt>
					<dd>#Session.Slat.OrderConfirmation.OrderDateTime#</dd>
				</dl>
				<dl>
					<dt>Order Confirmation Sent To</dt>
					<dd>#Session.Slat.OrderConfirmation.BillingAddress.EMail#</dd>
				</dl>
			</div>
			<div class="Options">
				<div class="Print"><a href="javascript:;" onClick="window.print();">Print This Page</a></div>
				<div class="Call">Call 1.800.697.8007 For Assistance</div>
			</div>
		</div>
		<div class="sdoOrderShipping">
			<h3 class="title">Shipping Details</h3>
			<div class="sdoOrderShipTo">
				<h4 class="title">Ship To</h4>
				<dl class="Name">
					<dt>Shipping Contact</dt>
					<dd>#Session.Slat.OrderConfirmation.ShippingAddress.FirstName# #Session.Slat.OrderConfirmation.ShippingAddress.LastName#</dd>
				</dl>
				<dl class="EMail">
					<dt>Email</dt>
					<dd>#Session.Slat.OrderConfirmation.ShippingAddress.EMail#</dd>
				</dl>
				<dl class="PhoneNumber">
					<dt>Phone Number</dt>
					<dd>#Session.Slat.OrderConfirmation.ShippingAddress.PhoneNumber#</dd>
				</dl>
				<dl class="StreetAddress">
					<dt>Street Address</dt>
					<dd>#Session.Slat.OrderConfirmation.ShippingAddress.StreetAddress#</dd>
				</dl>
				<dl class="Locality">
					<dt>Locality</dt>
					<dd>#Session.Slat.OrderConfirmation.ShippingAddress.Locality#</dd>
				</dl>
				<dl class="CityStatePostal">
					<dt>City, State Postal Code</dt>
					<dd>#Session.Slat.OrderConfirmation.ShippingAddress.City#, #Session.Slat.OrderConfirmation.ShippingAddress.State# #Session.Slat.OrderConfirmation.ShippingAddress.PostalCode#</dd>
				</dl>
				<dl class="Country">
					<dt>Country</dt>
					<dd>#Session.Slat.OrderConfirmation.ShippingAddress.Country#</dd>
				</dl>
			</div>
			<div class="sdoOrderShippingMethods">
				<h4 class="title">Shipping Service</h4>
				<p>#Application.Slat.shippingManager.getFriendlyShipMethodName(Session.Slat.OrderConfirmation.ShippingMethod.Method)#</p>
			</div>
		</div>
		<div class="sdoOrderBilling">
			<h3 class="title">Billing Details</h3>
			<div class="sdoOrderBillTo">
				<h4 class="title">Bill To</h4>
				<dl class="Name">
					<dt>Billing Contact</dt>
					<dd>#Session.Slat.OrderConfirmation.BillingAddress.FirstName# #Session.Slat.OrderConfirmation.BillingAddress.LastName#</dd>
				</dl>
				<dl class="EMail">
					<dt>Email</dt>
					<dd>#Session.Slat.OrderConfirmation.BillingAddress.EMail#</dd>
				</dl>
				<dl class="PhoneNumber">
					<dt>Phone Number</dt>
					<dd>#Session.Slat.OrderConfirmation.BillingAddress.PhoneNumber#</dd>
				</dl>
				<dl class="StreetAddress">
					<dt>Street Address</dt>
					<dd>#Session.Slat.OrderConfirmation.BillingAddress.StreetAddress#</dd>
				</dl>
				<dl class="Locality">
					<dt>Locality</dt>
					<dd>#Session.Slat.OrderConfirmation.BillingAddress.Locality#</dd>
				</dl>
				<dl class="CityStatePostal">
					<dt>City, State Postal Code</dt>
					<dd>#Session.Slat.OrderConfirmation.BillingAddress.City#, #Session.Slat.OrderConfirmation.BillingAddress.State# #Session.Slat.OrderConfirmation.ShippingAddress.PostalCode#</dd>
				</dl>
				<dl class="Country">
					<dt>Country</dt>
					<dd>#Session.Slat.OrderConfirmation.BillingAddress.Country#</dd>
				</dl>
			</div>
			<div class="sdoOrderPayments">
				<h4 class="title">Payments</h4>
				<cfloop from="1" to="#arrayLen(Session.Slat.OrderConfirmation.PaymentMethods)#" index="ThisCartPaymentID">
					<cfset ThisPaymentMethod = Session.Slat.OrderConfirmation.PaymentMethods[ThisCartPaymentID] />
					<ul class="AppliedPayment">
						<li class="PaymentType">#ThisPaymentMethod.Type#</li>
						<li class="PaymentCardNumber"> #application.slat.utilityManager.getSecureCardNumber(ThisPaymentMethod.CardNumber)#</li>
						<li class="PaymentAmount"> #DollarFormat(ThisPaymentMethod.Amount)# </li>
					</ul>
				</cfloop>
			</div>
		</div>
		<div class="sdoOrderItems">
			<h3 class="title">Order Items</h3>
			<cfloop array="#Session.Slat.OrderConfirmation.OrderItems#" Index="Item">
				<cfset Product = application.Slat.productManager.read(Item.ProductID) />
				<cfset SKU = application.Slat.skuManager.read(Item.SkuID) />
				<dl>
					<dt class="Image"><img src="#Sku.getSkuImage(Size='S')#" style="width:80px;height:100px;" /></dt>
					<dt class="Name">#Product.getBrand()# - #Product.getProductName()#</dt>
					<dd class="Attributes">#SKU.getAttributesString()#</dd>
					<cfif Item.ParentSkuID eq 0>
						<dd class="Price">#DollarFormat(Item.Price)#</dd>
						<dd class="Quantity">#Item.Quantity#</dd>
						<dd class="TotalPrice">#DollarFormat(Item.PriceExtended)#</dd>
					<cfelse>
						<dd class="Quantity">#Item.Quantity#</dd>
						<dd class="TotalPrice">Free</dd>
					</cfif>
				</dl>
			</cfloop>
		</div>
		<div class="sdoOrderTotals">
			<h3 class="title">Order Total</h3>
			<dl class="ItemsTotal">
				<dt>Item Total:</dt>
				<dd>
					#DollarFormat(Session.Slat.OrderConfirmation.TotalItems)#
				</dd>
			</dl>
			<dl class="Tax">
				<dt>Tax:</dt>
				<dd>
					#DollarFormat(Session.Slat.OrderConfirmation.TotalTax)#
				</dd>
			</dl>
			<dl class="Shipping">
				<dt>Shipping:</dt>
				<dd>
					#DollarFormat(Session.Slat.OrderConfirmation.TotalShipping)#
				</dd>
			</dl>
			<dl class="Discounts">
				<dt>Discounts:</dt>
				<dd>#DollarFormat(Session.Slat.OrderConfirmation.TotalDiscounts)#</dd>
			</dl>
			<dl class="Total">
				<dt>Total:</dt>
				<dd>#DollarFormat(Session.Slat.OrderConfirmation.Total)#</dd>
			</dl>
		</div>
	</cfif>
</cfoutput>