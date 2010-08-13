<cfset AllProductsQuery = application.Slat.ProductManager.getAllProductsQuery() />
<cfquery name="AllProductsByDateLastReceived" dbtype="query" maxrows="200">
	Select
		*
	From 
		AllProductsQuery
	Where
		DateLastReceived IS NOT NULL
	Order By DateLastReceived DESC
</cfquery>
<cfset ProductIterator = application.Slat.productManager.getProductIterator(AllProductsByDateLastReceived) />
<cfoutput>
	<h3 class="tableheader">Products</h3>
	<table class="listtable">
		<tr>
			<th>Last Received</th>
			<th>Brand</th>
			<th>Year</th>
			<th>Product Name</th>
			<th>Product Code</th>
		</tr>
		<cfloop condition="#ProductIterator.hasNext()#">
			<cfset Product = ProductIterator.Next() />
			<tr>
				<td>#DateFormat(Product.getDateLastReceived(),"MM/DD")# - #TimeFormat(Product.getDateLastReceived(),"HH:MM")#</td>
				<td><a href="#buildURL(action='brand.detail', queryString='BrandID=#Product.getBrandID()#')#">#Product.getBrand()#</a></td>
				<td>#Product.getProductYear()#</td>
				<td><a href="#buildURL(action='product.detail', queryString='ProductID=#Product.getProductID()#')#">#Product.getProductName()#</a></td>
				<td><a href="#buildURL(action='product.detail', queryString='ProductID=#Product.getProductID()#')#">#Product.getProductCode()#</a></td>
			</tr>
		</cfloop>
	</table>
</cfoutput>