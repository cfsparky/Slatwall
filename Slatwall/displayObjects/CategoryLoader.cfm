<!--- Set Requst.Slat.Filter & Request.Slat.Range & Request.Slat.Order --->	
<cfset request.Slat.Filter = structNew() />
<cfset request.Slat.Range = structNew() />
<cfset request.Slat.Order = structNew() />
<cfset request.Slat.Order.Column = "DateFirstReceived" />
<cfset request.Slat.Order.Direction = "D" />
<cfloop collection="#url#" item="ValuePair">
	<cfif find("F_",ValuePair)>
		<cfset FilterProperty = Replace(ValuePair,"F_", "") />
		<cfif JavaCast("string", StructFind(url,ValuePair)) neq "">
			<cfset "request.Slat.Filter.#FilterProperty#" = JavaCast("string", StructFind(url,ValuePair)) />
		</cfif>
	</cfif>
	<cfif find("R_",ValuePair)>
		<cfset RangeProperty = Replace(ValuePair,"R_", "") />
		<cfif JavaCast("string", StructFind(url,ValuePair)) neq "">
			<cfset "request.Slat.Range.#RangeProperty#" = JavaCast("string", StructFind(url,ValuePair)) />
		</cfif>
	</cfif>
	<cfif find("O_",ValuePair)>
		<cfif ValuePair neq "O_Column" and ValuePair neq "O_Direction">
			<cfset request.Slat.Order.Column = Replace(ValuePair,"O_", "") />
			<cfset request.Slat.Order.Direction = JavaCast("string", StructFind(url,ValuePair)) />
		</cfif>
	</cfif>
</cfloop>

<!--- Set Request.Slat.Keyword --->
<cfset request.Slat.Keyword = "">
<cfif isDefined("url.Keyword")>
	<cfset request.Slat.Keyword = url.Keyword />
</cfif>

<!--- Set Request.Slat.Product --->
<cfset request.Slat.Product = "">
<cfif isDefined("url.ProductID")>
	<cfset request.Slat.Product = application.Slat.productManager.read('#url.ProductID#') />
</cfif>

<!--- Set Requst.Slat.Content --->
<cfset request.Slat.Content = structNew() />
<cfset request.Slat.Content.ActiveProductsOnly = 1 />
<cfset request.Slat.Content.UseContentFilter = 1 />
<cfset request.Slat.Content.ContentID = "" />
<cfset request.Slat.Content.ContentPath = "" />

<cfif isAdminPage>
	<cfset request.Slat.Content.ActiveProductsOnly = 0 />
<cfelse>
	<cfset request.Slat.Content.ContentID = request.contentBean.getContentID() />
	<cfset request.Slat.Content.ContentPath = request.contentBean.getPath() />	
</cfif>

<cfif request.Slat.Content.ContentID eq "97A5D66F-237D-9C1A-03A8773481B6E59D" or isAdminPage>
	<cfset request.Slat.Content.UseContentFilter = 0 />
</cfif>

<cfif request.Slat.Content.UseContentFilter>
	<cfset request.Slat.Content.ProductsQuery = application.Slat.productManager.getProductsInCategory(request.Slat.Content.ContentID, request.Slat.Content.ContentPath, 1, request.Slat.Order.Column, request.Slat.Order.Direction) />
<cfelse>
	<cfset request.Slat.Content.ProductsQuery = application.slat.integrationManager.getAllProductsQuery() />
</cfif>

<cfset request.Slat.Content.ProductsByFilterQuery = application.Slat.productManager.getProductsByFilter(request.Slat.Content.ProductsQuery, request.Slat.Filter, request.Slat.Range, request.Slat.Keyword, request.Slat.Order.Column, request.Slat.Order.Direction, request.Slat.Content.ActiveProductsOnly) />

<cfset request.Slat.Content.ProductsIterator = application.Slat.productManager.getProductIterator(request.Slat.Content.ProductsByFilterQuery) />

<!--- Set Request.Slat.Pager --->
<cfset request.Slat.Pager = structnew() />
<cfset request.Slat.Pager.StartingProduct = 1 />
<cfset request.Slat.Pager.EndingProduct = 1 />
<cfset request.Slat.Pager.TotalProducts = 1 />
<cfset request.Slat.Pager.ProductsPerPage = 16 />
<cfset request.Slat.Pager.TotalPages = 1 />
<cfif isDefined("url.P_Start")>
	<cfset request.Slat.Pager.StartingProduct = "#url.P_Start#" />
</cfif>
<cfif isDefined("url.P_Show")>
	<cfset request.Slat.Pager.ProductsPerPage = "#url.P_Show#" />
</cfif>
<cfset request.Slat.Pager.TotalProducts = request.Slat.Content.ProductsByFilterQuery.recordCount />
<cfif request.Slat.Pager.TotalProducts gt 0>
	<cfset request.Slat.Pager.EndingProduct = request.Slat.Pager.StartingProduct + request.Slat.Pager.ProductsPerPage - 1 />
	<cfif request.Slat.Pager.EndingProduct gt request.Slat.Pager.TotalProducts>
		<cfset request.Slat.Pager.EndingProduct = request.Slat.Pager.TotalProducts />
	</cfif>
	<cfset request.Slat.Pager.TotalPages = round((request.Slat.Pager.TotalProducts/request.Slat.Pager.ProductsPerPage) + .4999) />
	
	<cfif request.Slat.Pager.TotalPages lt 1>
		<cfset request.Slat.Pager.TotalPages = 1>
	</cfif>
	<cfset request.Slat.Pager.CurrentPage = round(request.Slat.Pager.StartingProduct/request.Slat.Pager.ProductsPerPage)+1>
	<cfif request.Slat.Pager.CurrentPage lt 1>
		<cfset request.Slat.Pager.CurrentPage = 1>
	</cfif>
</cfif>
<cfset request.Slat.Content.ProductsIterator.setNextN(request.Slat.Pager.ProductsPerPage) />
<cfset request.Slat.Content.ProductsIterator.setStartRow(request.Slat.Pager.StartingProduct) />
