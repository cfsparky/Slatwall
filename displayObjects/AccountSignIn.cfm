<cfoutput>
	<cfset DisplaySettings = structnew() />
	<cfset DisplaySettings.onSuccess = application.settingsManager.getSite(session.siteid).getEditProfileURL() />
	<cfset DisplaySettings.onError = application.settingsManager.getSite(session.siteid).getLoginURL() />
	#application.Slat.dspManager.get(Display="AccountLoginForm",DisplaySettings=DisplaySettings)#
</cfoutput>