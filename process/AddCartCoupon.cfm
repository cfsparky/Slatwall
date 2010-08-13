<!--- Check If Coupon Has Been Applied --->
<cfset ActiveCouponID = 0>

<cfset AlreadyAddedCount = 0>
<cfset ExpiredCount = 0>
<cfset NotActiveYetCount = 0>
<cfset WrongDayCount = 0>

<cfloop from="1" to="#arrayLen(session.slat.cart.coupons)#" index="I">
	<cfif session.slat.cart.coupons[I].CouponCode eq Form.CouponCode>
		<cfset AlreadyAddedCount = AlreadyAddedCount+1 />
	</cfif>
</cfloop>


<cfif AlreadyAddedCount eq 0>
	<cfset CouponsWithCode = application.slat.couponManager.getCouponsByCode(CouponCode = Form.CouponCode) />
	
	<cfif CouponsWithCode.recordcount gt 0>
		<cfloop query="CouponsWithCode">
			<cfif CouponsWithCode.EndDate lt DateFormat(now()+1)>
				<cfset ExpiredCount = ExpiredCount+1>
			<cfelseif CouponsWithCode.StartDate gt DateFormat(now())>
				<cfset NotActiveYetCount = NotActiveYetCount+1>
			<cfelseif find(dayOfWeek(now()), CouponsWithCode.ValidDays) eq 0>
				<cfset WrongDayCount = WrongDayCount+1>
			<cfelse>
				<cfset ActiveCouponID = CouponsWithCode.CouponID />
			</cfif>
		</cfloop>
		
		<cfif ActiveCouponID neq 0>
			
			<cfset application.slat.cartManager.addCartCoupon(CouponID=ActiveCouponID,CouponCode=Form.CouponCode) />
		<cfelseif WrongDayCount gt 0>
			<cfset application.slat.messageManager.addMessage(MessageCode="C04",FormName="CouponCodes",slatProcess="AddCouponCode") />
		<cfelseif NotActiveYetCount gt 0>
			<cfset application.slat.messageManager.addMessage(MessageCode="C03",FormName="CouponCodes",slatProcess="AddCouponCode") />
		<cfelse>
			<cfset application.slat.messageManager.addMessage(MessageCode="C02",FormName="CouponCodes",slatProcess="AddCouponCode") />
		</cfif>
	<cfelse>
		<cfset application.slat.messageManager.addMessage(MessageCode="C01",FormName="CouponCodes",slatProcess="AddCouponCode") />
	</cfif>
<cfelse>
	<cfset application.slat.messageManager.addMessage(MessageCode="C05",FormName="CouponCodes",slatProcess="AddCouponCode") />
</cfif>