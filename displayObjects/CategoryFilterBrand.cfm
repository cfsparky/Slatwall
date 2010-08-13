<cfoutput>
	<cfset DisplaySettings = structNew() />
	<cfset DisplaySettings.FilterColumn = "Brand" />
	<cfset DisplaySettings.Title = "Brand" />
	<cfset DisplaySettings.OrderDirection = "A" />
	<cfset DisplaySettings.OrderByCount = 0 />
	#application.slat.dspManager.get(Display="ProductFilter",DisplaySettings=DisplaySettings)#
</cfoutput>
