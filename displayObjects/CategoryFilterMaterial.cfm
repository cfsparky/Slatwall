<cfoutput>
	<cfset DisplaySettings = structNew() />
	<cfset DisplaySettings.FilterColumn = "Material" />
	<cfset DisplaySettings.Title = "Material" />
	<cfset DisplaySettings.OrderDirection = "A" />
	<cfset DisplaySettings.OrderByCount = 0 />
	#application.slat.dspManager.get(Display="ProductFilter",DisplaySettings=DisplaySettings)#
</cfoutput>
<!---

<cfparam name="url.f_Material" default="" />
<cfset optionCountMaterial = 0>

<cfif url.f_Material eq "">
	<cfset FilterOptions = Application.Slat.productManager.getFilterOptions(request.Slat.CategoryProductsByFilterQuery,"Material","D",1) />
<cfelse>
	<cfset FilterOptions = Application.Slat.productManager.getFilterOptions(request.Slat.CategoryProductsQuery,"Material","D",1) />
</cfif>


<cfsavecontent variable="MaterialFilterOutput">
	<h3>Material</h3>
	<ul class="navSecondary">
		<cfloop query="FilterOptions" endrow="10">
			<cfif FilterOptions.Material neq "">
				<cfset optionCountMaterial = optionCountMaterial + 1>
				<cfset FilterLink = application.Slat.productManager.getFilterLink("Material", #FilterOptions.Material#) />
				
				<cfoutput>
					<cfif url.f_Brand eq #FilterOptions.Material#>
						<li class="current">
					<cfelse>
						<li>
					</cfif>
					<a href="#FilterLink#">#FilterOptions.Material# <span class="productcount">(#FilterOptions.COLUMN_1#)</span></a></li>
				</cfoutput>
			</cfif>
		</cfloop>
		<cfif FilterOptions.recordCount gt 10>
			<li>&nbsp;</li>
			<li class="fullList">
				<a href="">View All Brands</a></li>
			</li>
		</cfif>
	</ul>
</cfsavecontent>

<cfif optionCountMaterial gt 1>
	<cfoutput>#MaterialFilterOutput#</cfoutput>
</cfif>
--->