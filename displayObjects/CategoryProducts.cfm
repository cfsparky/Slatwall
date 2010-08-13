<cfoutput>
	<cfloop query="request.Slat.CategoryProductsQuery">
		<cfset Product = application.Slat.productmanager.read(request.Slat.CategoryProductsQuery.ProductID) />
	
		<div class="Image">#Product.getDefaultImageID()#</div>
		<div class="Brand">#Product.getBrand()#</div>
		<div class="ProductName">#Product.getProductName()#</div>
	
	</cfloop>
</cfoutput>