<cfcomponent output="false" name="ProductPagingNav" hint="">

	<cffunction name="init" access="public" returntype="string" output="false">
		<cfargument name="MaxDisplayPages" default="10" />
		<cfargument name="PreviousIcon" default="<" />
		<cfargument name="NextIcon" default=">" />
		<cfargument name="SpacerIcon" default="" />
		<cfargument name="MoreIcon" default="..." />
		
		<cfset var returnHTML = "" />
		<cfset var PreviousLink = "" />
		<cfset var NextLink = "" />
		<cfset var PageListingStart = 1 />
		<cfset var PageListingEnd = 1 />
		<cfset var Link = "" />
		<cfset var I = 0 />  
		
		<cfif #Request.Slat.Pager.TotalPages# gt 1>
			<cfif Request.Slat.Pager.CurrentPage eq 1>
				<cfset PreviousLink = "" />
			<cfelse>
				<cfset PreviousLink = getProductCFKOPRLink("P","Start",request.slat.pager.startingproduct - request.Slat.Pager.ProductsPerPage) />
			</cfif>
			<cfif Request.Slat.Pager.CurrentPage eq Request.Slat.Pager.TotalPages>
				<cfset NextLink = "" />
			<cfelse>
				<cfset NextLink = getProductCFKOPRLink("P","Start",request.slat.pager.startingproduct + request.Slat.Pager.ProductsPerPage) />
			</cfif>
			<cfset PageListingStart = 1 />
			<cfset PageListingEnd = Request.Slat.Pager.TotalPages />
			<cfif PageListingEnd gt arguments.MaxDisplayPages>
				<cfset PageListingStart = (Request.Slat.Pager.CurrentPage - round(arguments.MaxDisplayPages/2))>
				
				<cfif PageListingStart lt 1>
					<cfset PageListingStart = 1 />
				</cfif>
				
				<cfset PageListingEnd = PageListingStart + (arguments.MaxDisplayPages - 1) />
				
				<cfif PageListingEnd gt Request.Slat.Pager.TotalPages>
					<cfset PageListingEnd = Request.Slat.Pager.TotalPages />
					<cfset PageListingStart = PageListingEnd - (arguments.MaxDisplayPages - 1) />
				</cfif>
			</cfif>
			<cfsavecontent variable="returnHTML">
				<cfoutput>
					<div class="sdoProductPagingNav">
						<ul class="CategoryPager">
							<li class="Previous"><a href="#PreviousLink#">#arguments.PreviousIcon#</a></li>
							<cfif PageListingStart gt 1>
								<li class="MorePrevious"><a href="#getProductCFKOPRLink('P','Start',1)#">#arguments.MoreIcon#</a></li>
							</cfif>
							<cfloop From="#PageListingStart#" To="#PageListingEnd#" Index="I">
								<cfset Link = getProductCFKOPRLink("P","Start",(I*request.Slat.Pager.ProductsPerPage)-(request.Slat.Pager.ProductsPerPage-1)) />
								<cfif I eq Request.Slat.Pager.CurrentPage>
									<li class="current">
								<cfelse>
									<li>
								</cfif>
									<a href="#Link#">#I#</a>
								</li>
							</cfloop>
							<cfif PageListingEnd lt Request.Slat.Pager.TotalPages>
								<li class="MoreNext"><a href="#getProductCFKOPRLink('P','Start',(Request.Slat.Pager.TotalPages*request.Slat.Pager.ProductsPerPage)-(request.Slat.Pager.ProductsPerPage-1))#">#arguments.MoreIcon#</a></li>
							</cfif>
							<li class="Next"><a href="#NextLink#">#arguments.NextIcon#</a></li>
						</ul>
					</div>
				</cfoutput>
			</cfsavecontent>
		</cfif>
		
		<cfreturn returnHTML /> 
	</cffunction>
	
</cfcomponent>
