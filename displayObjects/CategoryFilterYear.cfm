<cfoutput>
	<cfset DisplaySettings = structNew() />
	<cfset DisplaySettings.FilterColumn = "ProductYear" />
	<cfset DisplaySettings.Title = "Year" />
	<cfset DisplaySettings.OrderDirection = "D" />
	<cfset DisplaySettings.OrderByCount = 0 />
	#application.slat.dspManager.get(Display="ProductFilter",DisplaySettings=DisplaySettings)#
</cfoutput>