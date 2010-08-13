<cfcomponent output="false" name="ProductSortNav" hint="">
	
	<cffunction name="init" access="public" returntype="string" output="false">
	
		<cfset var returnHTML = "" />
		<cfsavecontent variable="returnHTML">
			<cfoutput>
				<div class="sdoProductSortNav">
					<h3 class="title">Sort By</h3>
					<ul>
						<cfif request.slat.Order.Column eq "DateFirstReceived"><li class="current"><cfelse><li></cfif><a href="#getProductCFKOPRLink('O','DateFirstReceived', 'D')#">Newest Products</a></li>
						<cfif request.slat.Order.Column eq "LivePrice" and request.slat.Order.Direction eq "A"><li class="current"><cfelse><li></cfif><a href="#getProductCFKOPRLink('O','LivePrice', 'A')#">Lowest Price</a></li>
						<cfif request.slat.Order.Column eq "LivePrice" and request.slat.Order.Direction eq "D"><li class="current"><cfelse><li></cfif><a href="#getProductCFKOPRLink('O','LivePrice', 'D')#">Highest Price</a></li>
						<cfif request.slat.Order.Column eq "ProductName"><li class="current"><cfelse><li></cfif><a href="#getProductCFKOPRLink('O','ProductName', 'A')#">Sort By Product Name</a></li>
						<cfif request.slat.Order.Column eq "Brand"><li class="current"><cfelse><li></cfif><a href="#getProductCFKOPRLink('O','Brand', 'A')#">Sort By Brand Name</a></li>
					</ul>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn returnHTML /> 
	</cffunction>
</cfcomponent>
