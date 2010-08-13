<!--- Check for Upper Case Password --->
<cfset loginResultsUpperCase = application.Slat.userUtility.login(#form.LoginUsername#, #UCASE(form.LoginPassword)#, #session.siteid#) />
<cfif loginResultsUpperCase>
	<cfset TempUser = application.userManager.readByUsername(#form.LoginUsername#, #session.siteid#) />
	<cfset TempUser.setPassword(password='#form.LoginPassword#') />
	<cfset TempUser.save() />
	<cfset TempSession = Session.Slat.Cart.Items /> 
	<cfset results = application.loginManager.logout() />
	<cfset Session.Slat.Cart.Items = TempSession />
</cfif>

<!--- Re-Login User with Case Sensitive --->
<cfset loginResults = application.Slat.userUtility.login(#form.LoginUsername#, #form.LoginPassword#, 'default') />
<cfif not LoginResults>
	<cfset application.slat.messageManager.addMessage(MessageCode="A01",FormName="LoginUser",slatProcess="LoginUser") />
</cfif>

<cfif LoginResults gt 1 or loginResultsUpperCase gt 1>
	<cfset Session.Slat.Cart.GuestCheckout = 0 />
</cfif> 