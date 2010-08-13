<cfoutput>
	<cfset DisplaySettings = structNew() />
	<cfset DisplaySettings.FilterColumn = "Gender" />
	<cfset DisplaySettings.Title = "Gender" />
	<cfset DisplaySettings.OrderDirection = "A" />
	<cfset DisplaySettings.OrderByCount = 0 />
	#application.slat.dspManager.get(Display="ProductFilter",DisplaySettings=DisplaySettings)#
</cfoutput>