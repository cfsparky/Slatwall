<!--- Check To See If Payment Method Is Applied --->
<cfif Form.PaymentAmount eq "" or Form.PaymentAmount lt .01>
	<cfset application.slat.messageManager.addMessage(MessageCode="P01",FormName="AddPaymentMethod",slatProcess="AddCartPaymentMethod") />
<cfelseif Form.PaymentAmount gt application.slat.cartManager.getCartAmountDueTotal()>
	<cfset application.Slat.logManager.addLog(LogType="Over Paid") />
<cfelse>
	<cfset application.Slat.cartManager.addCartPaymentMethod(
		Amount = Form.PaymentAmount,
		CardHolderName = Form.PaymentCardHolderName,
		CardNumber = Form.PaymentCardNumber,
		SecurityCode = Form.PaymentSecurityCode,
		ExpirationMonth = Form.PaymentExpirationMonth,
		ExpirationYear = Form.PaymentExpirationYear,
		Type = Form.PaymentType
	) />
</cfif>