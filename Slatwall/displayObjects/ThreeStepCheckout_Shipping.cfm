<cfif Form.ShippingFirstName eq "">
	<cfset Form.ShippingFirstName = Session.Slat.Cart.ShippingAddresses[1].FirstName />
</cfif>
<cfif Form.ShippingLastName eq "">
	<cfset Form.ShippingLastName = Session.Slat.Cart.ShippingAddresses[1].LastName />
</cfif>
<cfif Form.ShippingEmail eq "">
	<cfset Form.ShippingEmail = Session.Slat.Cart.ShippingAddresses[1].EMail />
</cfif>
<cfif Form.ShippingPhoneNumber eq "">
	<cfset Form.ShippingPhoneNumber = Session.Slat.Cart.ShippingAddresses[1].PhoneNumber />
</cfif>
<cfif Form.ShippingCountry eq "US">
	<cfset Form.ShippingCountry = Session.Slat.Cart.ShippingAddresses[1].Country />
</cfif>
<cfif Form.ShippingLocality eq "">
	<cfset Form.ShippingLocality = Session.Slat.Cart.ShippingAddresses[1].Locality />
</cfif>
<cfif Form.ShippingStreetAddress eq "">
	<cfset Form.ShippingStreetAddress = Session.Slat.Cart.ShippingAddresses[1].StreetAddress />
</cfif>
<cfif Form.ShippingStreet2Address eq "">
	<cfset Form.ShippingStreet2Address = Session.Slat.Cart.ShippingAddresses[1].Street2Address />
</cfif>
<cfif Form.ShippingPostalCode eq "">
	<cfset Form.ShippingPostalCode = Session.Slat.Cart.ShippingAddresses[1].PostalCode />
</cfif>
<cfif Form.ShippingCity eq "">
	<cfset Form.ShippingCity = Session.Slat.Cart.ShippingAddresses[1].City />
</cfif>
<cfif Form.ShippingState eq "">
	<cfset Form.ShippingState = Session.Slat.Cart.ShippingAddresses[1].State />
</cfif>
<cfoutput>
	<form name="ShippingDetails" action="" method="post" onsubmit="return PowerValidate(this);">
		<cfset DisplaySettings = structNew() />
		<cfset DisplaySettings.CartShippingAddressID = 1 />
		<cfset DisplaySettings.FirstName = Form.ShippingFirstName />
		<cfset DisplaySettings.LastName = Form.ShippingLastName />
		<cfset DisplaySettings.EMail = Form.ShippingEMail />
		<cfset DisplaySettings.PhoneNumber = Form.ShippingPhoneNumber />
		<cfset DisplaySettings.Country = Form.ShippingCountry />
		<cfset DisplaySettings.Locality = Form.ShippingLocality />
		<cfset DisplaySettings.State = Form.ShippingState />
		<cfset DisplaySettings.City = Form.ShippingCity />
		<cfset DisplaySettings.PostalCode = Form.ShippingPostalCode />
		<cfset DisplaySettings.StreetAddress = Form.ShippingStreetAddress />
		<cfset DisplaySettings.Street2Address = Form.ShippingStreet2Address />
		#application.slat.dspManager.get(Display="ShippingAddressForm",DisplaySettings=DisplaySettings)#
		 
		<div class="sdoShippingOptions">
			<h3></h3>
		</div>
		
		<script type="text/javascript">
			var InitialDisplaySettingsJSON = {
				"CartShippingAddressID": "1",
				"FirstName": "#Form.ShippingFirstName#",
				"LastName": "#Form.ShippingLastName#",
				"EMail": "#Form.ShippingEMail#",
				"PhoneNumber": "#Form.ShippingPhoneNumber#",
				"Country": "#Form.ShippingCountry#",
				"Locality": "#Form.ShippingLocality#",
				"State": "#Form.ShippingState#",
				"City": "#Form.ShippingCity#",
				"PostalCode": "#Form.ShippingPostalCode#",
				"StreetAddress": "#Form.ShippingStreetAddress#"
			};
			displaySlatPreloader("sdoShippingOptions", "Loading Rates", "<h3 class='title'>Shipping Methods</h3>");
			getSlatDisplay('sdoShippingOptions', 'ShippingOptions', InitialDisplaySettingsJSON);
		</script>
		 
		<input type="hidden" name="slatProcess" value="UpdateCartShipping,UpdateCartShippingMethod">
		<input type="hidden" name="OnSuccess" value="/index.cfm/checkout/payment/">
		
	</form>
</cfoutput>
