<cfset TempSession = Session.Slat.Cart.Items /> 
<cfset results = application.loginManager.logout() />
<cfset Session.Slat.Cart.Items = TempSession />