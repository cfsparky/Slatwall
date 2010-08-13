<cfoutput>
<cfif arraylen(Session.Slat.Cart.Items) gt 0>
<form action="" method="Post" name="ShoppingCart">
	<input type="hidden" name="RemoveFromCartSkuId" value="" />
	<input type="hidden" name="onSuccess" value="" />
	<input type="hidden" name="slatProcess" value="" />
	<dl id="CartItems">
		<dt class="ItemsTitle">Cart Items</dt>
		<dd>
			<cfloop from="1" to="#arraylen(Session.Slat.Cart.Items)#" Index="I">
				<cfset CartItem = structCopy(Session.Slat.Cart.Items[I]) />
				<cfset Product = application.Slat.productManager.read(Session.Slat.Cart.Items[I].ProductID) />
				<cfset SKU = application.Slat.skuManager.read(Session.Slat.Cart.Items[I].SkuID) />
				<dl>
					<dt class="Image"><img src="#Sku.getSkuImage(Size='S')#" style="width:80px;height:100px;" /></dt>
					<dt class="Name">#Product.getBrand()# - #Product.getProductName()#</dt>
					<dd class="Attributes">#SKU.getAttributesString()#</dd>
					<cfif CartItem.ParentSkuID eq 0>
						<dd class="Price">#DollarFormat(application.slat.cartManager.getCartItemPrice(I))#</dd>
						<dd class="Quantity"><input type="text" name="Quantity_#CartItem.SKUID#" value="#CartItem.Quantity#" /></dd>
						<dd class="TotalPrice">#DollarFormat(application.slat.cartManager.getCartItemPriceExtended(I))#</dd>
						<dd class="UpdateQuantity"><a href="##" onClick="$('input[name=slatProcess]').val('UpdateCartItemQuantity'); $('form[name=ShoppingCart]').submit(); return false;">Update Quantity</a></dd>
						<dd class="RemoveItem"><a href="##" onClick="$('input[name=slatProcess]').val('RemoveCartItem'); $('input[name=RemoveFromCartSkuId]').val('#CartItem.SkuID#'); $('form[name=ShoppingCart]').submit(); return false;">Remove</a></dd>
					<cfelse>
						<dd class="Quantity">#CartItem.Quantity#</dd>
						<dd class="TotalPrice">Free</dd>
					</cfif>
				</dl>
			</cfloop>
		</dd>
	</dl>
</form>

<form action="" method="post" name="CouponCodes">
	<input type="hidden" name="slatProcess" value="AddCartCoupon" />
	<input type="hidden" name="RemoveCouponID" value="" />
		
	<div id="PromoCodes">
		<cfloop array="#Session.Slat.Cart.Coupons#" index="Coupons">
			<dl class="PromoCodeApplied">
				<cfset Coupon = application.slat.couponManager.read(#Coupons.CouponID#) />
				<dt class="CouponCode">#Coupon.getCouponCode()#</dt>
				<dd class="Description">#Coupon.getDescription()# <a href="##" onClick="$('input[name=slatProcess]').val('RemoveCartCoupon'); $('input[name=RemoveCouponID]').val('#Coupon.getCouponID()#'); $('form[name=CouponCodes]').submit(); return false;">Remove</a></dd>
			</dl>
		</cfloop>
		#application.slat.messageManager.dspMessage(FormName="CouponCodes")#
		<dl class="AddPromoCode">
			<dt class="PromoCodeTitel">Enter Promo Code</dt>
			<dd>
				<input type="text" name="CouponCode" />&nbsp;&nbsp;
				<button class="slatButton btnApply" type="submit">Apply</button>
			</dd>
		</dl>
	</div>
</form>
<cfelse>
	<div class="NoProduct">There are currently no Products in your Shopping Cart</div>
</cfif>

<button class="slatButton btnContinueShopping" onClick="window.location='/'">Continue Shopping</button>
<cfif arraylen(Session.Slat.Cart.Items) gt 0>
	<cfif Session.mura.IsLoggedIn>
		<button class="slatButton btnProceedToCheckout" onClick="window.location='/index.cfm/checkout/shipping/'">Proceed to Checkout</button>
	<cfelse>
		<button class="slatButton btnProceedToCheckout" onClick="$('##checkout_overlay').fadeIn('fast'); return false;">Proceed to Checkout</button>
	</cfif>
</cfif>
</cfoutput>