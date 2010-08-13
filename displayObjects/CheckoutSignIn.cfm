<cfoutput>
	<cfset DisplaySettings = structnew() />
	<cfset DisplaySettings.CustomClass='Checkout_Signin' />
	<cfset DisplaySettings.onSuccess='/index.cfm/checkout/shipping/' />
	<cfset DisplaySettings.GuestCheckoutOn=1 />
	#application.Slat.dspManager.get(Display="AccountLoginForm",DisplaySettings=DisplaySettings)#
</cfoutput>