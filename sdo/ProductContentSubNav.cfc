<cfcomponent output="false" name="ProductContentSubNav" hint="">

	<cffunction name="init" access="public" returntype="string" output="false">
		<cfargument name="ContentID" type="string" default="00000000000000000000000000000000001" />
		<cfargument name="Title" type="string" defualt="Homepage" />
		
		<cfset var optionCount = 0 />
		<cfset var FilterOptions = querynew('empty') />
		<cfset var FilterLink = "" />
		<cfset var returnHTML = "" />
		
		<cfset FilterOptions = application.Slat.productManager.getSubContentFilterOptions(arguments.ContentID) />
		
		<cfsavecontent variable="returnHTML">
			<cfoutput>
				<div class="sdoProductContentSubNav">
					<h3 class="title">#arguments.Title#</h3>
					<ul>
						<cfloop query="FilterOptions">
							<cfif FilterOptions.ProductCount gt 1>
								<cfset optionCount = optionCount + 1>
								
								<cfset FilterLink = getProductCFKOPRLink(CFKOPR="C", Value=FilterOptions.FileName) />
								
								<li><a href="#FilterLink#">#FilterOptions.MenuTitle# <span class="productcount">(#FilterOptions.ProductCount#)</span></a></li>
							</cfif>
						</cfloop>
					</ul>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfif optionCount lt 2>
			<cfset returnHTML = "" />
		</cfif>
		
		<cfreturn returnHTML />
	</cffunction>
	
</cfcomponent>
