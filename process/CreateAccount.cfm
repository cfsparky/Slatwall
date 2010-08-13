<cfset ThisUser = #application.userManager.readByUsername(username='#trim(Form.NewUserEMail)#',siteid='default')# />

<cfif ThisUser.getIsNew()>
	<cfset ThisUser.setSiteID('default') />
	<cfset ThisUser.setUsername(trim(Form.NewUserEMail)) />
	<cfset ThisUser.setPassword(trim(Form.NewUserPassword)) />
	<cfset ThisUser.setFname(trim(Form.NewUserFirstName)) />
	<cfset ThisUser.setLname(trim(Form.NewUserLastName)) />
	<cfset ThisUser.setEmail(trim(Form.NewUserEMail)) />
	<cfset ThisUser.save() />
	<cfset loginResults = application.Slat.userUtility.login(#form.NewUserEMail#, #form.NewUserPassword#, 'default') />
<cfelse>
	<cfset loginResults = application.Slat.userUtility.login(#form.NewUserEMail#, #form.NewUserPassword#, 'default') />
	<cfif not loginResults>
		<cfset application.slat.messageManager.addMessage(MessageCode="A02",FormName="CreateAccount",slatProcess="CreateAccount") />
	</cfif>
</cfif>