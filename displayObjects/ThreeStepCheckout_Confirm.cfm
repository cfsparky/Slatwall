<cfoutput>
<cfset Session.Slat.Order = Application.Slat.cartManager.convertCartToOrder(1,1,Session.Mura.RemoteID,9907,99) />

<form action="" method="post" id="OrderConfirmation">
	<div class="sdoOrderShipping">
		<h3 class="title">Shipping Details</h3>
		<div class="sdoOrderShipTo">
			<h4 class="title">Ship To</h4>
			<dl class="Name">
				<dt>Shipping Contact</dt>
				<dd>#Session.Slat.Order.ShippingAddress.FirstName# #Session.Slat.Order.ShippingAddress.LastName#</dd>
			</dl>
			<dl class="EMail">
				<dt>Email</dt>
				<dd>#Session.Slat.Order.ShippingAddress.EMail#</dd>
			</dl>
			<dl class="PhoneNumber">
				<dt>Phone Number</dt>
				<dd>#Session.Slat.Order.ShippingAddress.PhoneNumber#</dd>
			</dl>
			<cfif len(Session.Slat.Order.ShippingAddress.StreetAddress)>
				<dl class="StreetAddress">
					<dt>Street Address</dt>
					<dd>#Session.Slat.Order.ShippingAddress.StreetAddress#</dd>
				</dl>
			</cfif>
			<cfif len(Session.Slat.Order.ShippingAddress.Street2Address)>
				<dl class="Street2Address">
					<dt>Street Address 2</dt>
					<dd>#Session.Slat.Order.ShippingAddress.Street2Address#</dd>
				</dl>
			</cfif>
			<cfif len(Session.Slat.Order.ShippingAddress.Locality)>
				<dl class="Locality">
					<dt>Locality</dt>
					<dd>#Session.Slat.Order.ShippingAddress.Locality#</dd>
				</dl>
			</cfif>
			<dl class="CityStatePostal">
				<dt>City, State Postal Code</dt>
				<dd>#Session.Slat.Order.ShippingAddress.City#, #Session.Slat.Order.ShippingAddress.State# #Session.Slat.Order.ShippingAddress.PostalCode#</dd>
			</dl>
			<dl class="Country">
				<dt>Country</dt>
				<dd>#Session.Slat.Order.ShippingAddress.Country#</dd>
			</dl>
		</div>
		<div class="sdoOrderShippingMethods">
			<h4 class="title">Shipping Service</h4>
			<p>#Application.Slat.shippingManager.getFriendlyShipMethodName(Session.Slat.Order.ShippingMethod.Method)#</p>
		</div>
		<div class="sdoOrderShippingEdit">
			<a href="/index.cfm/checkout/shipping/">Edit Shipping Details</a>
		</div>
	</div>
	<div class="sdoOrderBilling">
		<h3 class="title">Billing Details</h3>
		<div class="sdoOrderBillTo">
			<h4 class="title">Bill To</h4>
			<dl class="Name">
				<dt>Billing Contact</dt>
				<dd>#Session.Slat.Order.BillingAddress.FirstName# #Session.Slat.Order.BillingAddress.LastName#</dd>
			</dl>
			<dl class="EMail">
				<dt>Email</dt>
				<dd>#Session.Slat.Order.BillingAddress.EMail#</dd>
			</dl>
			<dl class="PhoneNumber">
				<dt>Phone Number</dt>
				<dd>#Session.Slat.Order.BillingAddress.PhoneNumber#</dd>
			</dl>
			<cfif len(Session.Slat.Order.BillingAddress.StreetAddress)>
				<dl class="StreetAddress">
					<dt>Street Address</dt>
					<dd>#Session.Slat.Order.BillingAddress.StreetAddress#</dd>
				</dl>
			</cfif>
			<cfif len(Session.Slat.Order.BillingAddress.Street2Address)>
				<dl class="Street2Address">
					<dt>Street Address 2</dt>
					<dd>#Session.Slat.Order.BillingAddress.Street2Address#</dd>
				</dl>
			</cfif>
			<cfif len(Session.Slat.Order.BillingAddress.Locality)>
				<dl class="Locality">
					<dt>Locality</dt>
					<dd>#Session.Slat.Order.BillingAddress.Locality#</dd>
				</dl>
			</cfif>
			<dl class="CityStatePostal">
				<dt>City, State Postal Code</dt>
				<dd>#Session.Slat.Order.BillingAddress.City#, #Session.Slat.Order.BillingAddress.State# #Session.Slat.Order.BillingAddress.PostalCode#</dd>
			</dl>
			<dl class="Country">
				<dt>Country</dt>
				<dd>#Session.Slat.Order.BillingAddress.Country#</dd>
			</dl>
		</div>
		<div class="sdoOrderPayments">
			<h4 class="title">Payments</h4>
			<cfloop from="1" to="#arrayLen(Session.Slat.Order.PaymentMethods)#" index="ThisCartPaymentID">
				<cfset ThisPaymentMethod = session.slat.Order.PaymentMethods[ThisCartPaymentID] />
				<ul class="AppliedPayment">
					<li class="PaymentType">#ThisPaymentMethod.Type#</li>
					<li class="PaymentCardNumber"> #application.slat.utilityManager.getSecureCardNumber(ThisPaymentMethod.CardNumber)#</li>
					<li class="PaymentAmount"> #DollarFormat(ThisPaymentMethod.Amount)# </li>
				</ul>
			</cfloop>
		</div>
		<div class="sdoOrderBillingEdit">
			<a href="/index.cfm/checkout/payment/">Edit Billing Details</a>
		</div>
	</div>
	<cfif Session.Slat.Order.GuestCheckout>
		<div class="sdoOrderGuestCreateAccount">
			<div class="Benifits">
				<strong>Why Register?</strong>
				<p>By Registering with Nytro, you will be able to easily check your order status, return products quicker, gain member rewards and more.</p>
			</div>
			<div class="CreateAccountForm">
				<dl class="UserID">
					<dt>Nytro ID:</dt>
					<dd>#Session.Slat.Order.BillingAddress.Email#</dd>
				</dl>
				<dl class="Password">
					<dt><label for="GuestAccountPassword">Create Password (optional)</label></dt>
					<dd><input type="password" name="GuestAccountPassword" value="" /></dd>
				</dl>
				<dl class="EMailSignup">
					<dt><input type="checkbox" name="GuestAccountEmailSignup" checked="checked"></dt>
					<dd>Send me specials and exclusive offers via E-Mail form Nytro Mulisport.</dd>
				</dl>
			</div>
		</div>
	</cfif>
	<div class="sdoOrderItems">
		<h3 class="title">Order Items</h3>
		<cfloop array="#Session.Slat.Order.OrderItems#" Index="Item">
			<cfset Product = application.Slat.productManager.read(Item.ProductID) />
			<cfset SKU = application.Slat.skuManager.read(Item.SkuID) />
			<dl>
				<dt class="Image"><img src="/prodimages/#Product.getDefaultImageID()#-DEFAULT-s.jpg" style="width:80px;height:100px;" /></dt>
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
				#DollarFormat(Session.Slat.Order.TotalItems)#
			</dd>
		</dl>
		<dl class="Tax">
			<dt>Tax:</dt>
			<dd>
				#DollarFormat(Session.Slat.Order.TotalTax)#
			</dd>
		</dl>
		<dl class="Shipping">
			<dt>Shipping:</dt>
			<dd>
				#DollarFormat(Session.Slat.Order.TotalShipping)#
			</dd>
		</dl>
		<dl class="Discounts">
			<dt>Discounts:</dt>
			<dd>#DollarFormat(Session.Slat.Order.TotalDiscounts)#</dd>
		</dl>
		<dl class="Total">
			<dt>Total:</dt>
			<dd>#DollarFormat(Session.Slat.Order.Total)#</dd>
		</dl>
	</div>
	<input type="hidden" name="onSuccess" value="/index.cfm/order-complete/" />
	<input type="hidden" name="slatProcess" value="ProcessOrder" />
	<br class="clear" />
	<button class="slatButton btnProcessOrder" type="submit">Process Order</button>
</form>
</cfoutput>