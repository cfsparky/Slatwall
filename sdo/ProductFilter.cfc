<cfcomponent output="false" name="ProductFilter" hint="">

	<cffunction name="init" access="public" returntype="string" output="false">
		<cfargument name="FilterColumn" type="string" required="true" />
		<cfargument name="Title" type="string" required="true" />
		<cfargument name="OrderDirection" type="string" required="true" />
		<cfargument name="OrderByCount" type="numeric" required="true" />
		
		<cfset var optionCount = 0 />
		<cfset var FilterStruct = structnew() />
		<cfset var QueryForFilter = querynew('empty') />
		<cfset var FilterOptions = querynew('empty') />
		<cfset var FilterLink = "" />
		<cfset var returnHTML = "" />
		
		<cfset FilterStruct = structCopy(request.Slat.Filter) />
		<cfset structDelete(FilterStruct, "#arguments.FilterColumn#") />
		
		<cfset QueryForFilter = application.Slat.productManager.getProductsByFilter(request.Slat.Content.ProductsQuery, FilterStruct, request.Slat.Range, request.Slat.Keyword, request.Slat.Order.Column, request.Slat.Order.Direction) />
		<cfset FilterOptions = Application.Slat.productManager.getFilterOptions(QueryForFilter,arguments.FilterColumn,arguments.OrderDirection,arguments.OrderByCount) />
		
		<cfsavecontent variable="returnHTML">
			<cfoutput>
				<div class="sdoProductFilter">
					<h3 class="title">#arguments.Title#</h3>
					<ul>
						<cfloop query="FilterOptions">
							<cfif evaluate("FilterOptions.#arguments.FilterColumn#") neq "">
								<cfset optionCount = optionCount + 1>
								
								<cfset FilterLink = getProductCFKOPRLink(CFKOPR="F", Column=arguments.FilterColumn, Value=evaluate("FilterOptions.#arguments.FilterColumn#")) />
								<cfif StructKeyExists(request.Slat.Filter,"#arguments.FilterColumn#")>
									
									<cfif Find(evaluate("FilterOptions.#arguments.FilterColumn#"), StructFind(request.Slat.Filter,#arguments.FilterColumn#))>
										<li class="current">
									<cfelse>
										<li>
									</cfif>
								<cfelse>
									<li>
								</cfif>
								<a href="#FilterLink#">#evaluate("FilterOptions.#arguments.FilterColumn#")# <span class="productcount">(#FilterOptions.COLUMN_1#)</span></a></li>
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
