<cfif Form.BillingFirstName eq "">
	<cfif Session.Slat.Cart.BillingAddresses[1].FirstName eq "">
		<cfset Form.BillingFirstName = Session.Slat.Cart.ShippingAddresses[1].FirstName />
	<cfelse>
		<cfset Form.BillingFirstName = Session.Slat.Cart.BillingAddresses[1].FirstName />
	</cfif>
</cfif>
<cfif Form.BillingLastName eq "">
	<cfif Session.Slat.Cart.BillingAddresses[1].LastName eq "">
		<cfset Form.BillingLastName = Session.Slat.Cart.ShippingAddresses[1].LastName />
	<cfelse>
		<cfset Form.BillingLastName = Session.Slat.Cart.BillingAddresses[1].LastName />
	</cfif>
</cfif>
<cfif Form.BillingEmail eq "">
	<cfif Session.Slat.Cart.BillingAddresses[1].Email eq "">
		<cfset Form.BillingEmail = Session.Slat.Cart.ShippingAddresses[1].Email />
	<cfelse>
		<cfset Form.BillingEmail = Session.Slat.Cart.BillingAddresses[1].Email />
	</cfif>
</cfif>
<cfif Form.BillingPhoneNumber eq "">
	<cfif Session.Slat.Cart.BillingAddresses[1].PhoneNumber eq "">
		<cfset Form.BillingPhoneNumber = Session.Slat.Cart.ShippingAddresses[1].PhoneNumber />
	<cfelse>
		<cfset Form.BillingPhoneNumber = Session.Slat.Cart.BillingAddresses[1].PhoneNumber />
	</cfif>
</cfif>
<cfif Form.BillingCountry eq "">
	<cfif Session.Slat.Cart.BillingAddresses[1].Country eq "US">
		<cfset Form.BillingCountry = Session.Slat.Cart.ShippingAddresses[1].Country />
	<cfelse>
		<cfset Form.BillingCountry = Session.Slat.Cart.BillingAddresses[1].Country />
	</cfif>
</cfif>
<cfif Form.BillingStreetAddress eq "">
	<cfif Session.Slat.Cart.BillingAddresses[1].StreetAddress eq "">
		<cfset Form.BillingStreetAddress = Session.Slat.Cart.ShippingAddresses[1].StreetAddress />
	<cfelse>
		<cfset Form.BillingStreetAddress = Session.Slat.Cart.BillingAddresses[1].StreetAddress />
	</cfif>
</cfif>
<cfif Form.BillingStreet2Address eq "">
	<cfif Session.Slat.Cart.BillingAddresses[1].Street2Address eq "">
		<cfset Form.BillingStreet2Address = Session.Slat.Cart.ShippingAddresses[1].Street2Address />
	<cfelse>
		<cfset Form.BillingStreet2Address = Session.Slat.Cart.BillingAddresses[1].Street2Address />
	</cfif>
</cfif>
<cfif Form.BillingCity eq "">
	<cfif Session.Slat.Cart.BillingAddresses[1].City eq "">
		<cfset Form.BillingCity = Session.Slat.Cart.ShippingAddresses[1].City />
	<cfelse>
		<cfset Form.BillingCity = Session.Slat.Cart.BillingAddresses[1].City />
	</cfif>
</cfif>
<cfif Form.BillingState eq "">
	<cfif Session.Slat.Cart.BillingAddresses[1].State eq "">
		<cfset Form.BillingState = Session.Slat.Cart.ShippingAddresses[1].State />
	<cfelse>
		<cfset Form.BillingState = Session.Slat.Cart.BillingAddresses[1].State />
	</cfif>
</cfif>
<cfif Form.BillingPostalCode eq "">
	<cfif Session.Slat.Cart.BillingAddresses[1].PostalCode eq "">
		<cfset Form.BillingPostalCode = Session.Slat.Cart.ShippingAddresses[1].PostalCode />
	<cfelse>
		<cfset Form.BillingPostalCode = Session.Slat.Cart.BillingAddresses[1].PostalCode />
	</cfif>
</cfif>
<cfoutput>
	<form action="" method="post" onsubmit="return PowerValidate(this);" name="Payment">
		<cfset DisplaySettings = structNew() />
		<cfset DisplaySettings.CartBillingAddressID = 1 />
		<cfset DisplaySettings.FirstName = Form.BillingFirstName />
		<cfset DisplaySettings.LastName = Form.BillingLastName />
		<cfset DisplaySettings.EMail = Form.BillingEMail />
		<cfset DisplaySettings.PhoneNumber = Form.BillingPhoneNumber />
		<cfset DisplaySettings.Country = Form.BillingCountry />
		<cfset DisplaySettings.Locality = Form.BillingLocality />
		<cfset DisplaySettings.State = Form.BillingState />
		<cfset DisplaySettings.City = Form.BillingCity />
		<cfset DisplaySettings.PostalCode = Form.BillingPostalCode />
		<cfset DisplaySettings.StreetAddress = Form.BillingStreetAddress />
		<cfset DisplaySettings.Street2Address = Form.BillingStreet2Address />
		#application.slat.dspManager.get(Display="BillingAddressForm",DisplaySettings=DisplaySettings)#
		#application.slat.dspManager.get(Display="BillingPaymentForm",DisplaySettings=DisplaySettings)#
	</form>
</cfoutput>