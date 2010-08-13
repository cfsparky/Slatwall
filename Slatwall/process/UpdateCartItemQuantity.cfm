<cfloop array="#session.Slat.cart.items#" index="I">
	<cfset newQuantity = evaluate("Form.Quantity_#I.SkuID#") />
	<cfif newQuantity lt 1>
		<cfset application.Slat.cartManager.removeCartItem(I.SKUID) />
	<cfelse>
		<cfset application.Slat.cartManager.updateCartQuantity(I.SKUID, newQuantity) />
	</cfif>
</cfloop>