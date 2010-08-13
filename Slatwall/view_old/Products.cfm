<cfoutput>
	<form name="ProductSearch" action="" class="search" method="GET">
		<h3>Product Search</h3>
		<input type="text" class="text" name="Keyword" value="#request.slat.Keyword#" />
		<input type="hidden" name="slatView" value="Products" />
		<a onclick="$('form[name=ProductSearch]').submit();" href="javascript:;" class="submit"><span>Search</span></a>
	</form>
	<cfif url.slatDetail eq "" and request.slat.Keyword neq "">
		<table class="stripe">
			<tbody>
				<tr>
					<th style="width:120px;text-align:left;">Brand</th>
					<th style="width:300px;text-align:left;">Product Name</th>
					<th>Product Code</th>
					<th>Live Price</th>
					<th></th>
				</tr>
			</tbody>
			<cfloop condition="request.Slat.Content.ProductsIterator.hasNext()"> 
				<cfset Product = request.Slat.Content.ProductsIterator.Next() />
				<tr>
					<td style="width:120px;text-align:left;">#Product.getBrand()#</td>
					<td style="width:300px;text-align:left;">#Product.getProductName()#</td>
					<td>#Product.getProductCode()#</td>
					<td>#Product.getLivePrice()#</td>
					<td class="administration">
						<ul class="siteSummart" style="width:38px;">
							<li class="edit"><a href="?slatView=Products&slatDetail=ProductDetail&ProductID=#Product.getProductID()#" title="Edit">Edit</a></li>
							<li class="preview"><a href="/index.cfm/product/?ProductID=#Product.getProductID()#" title="Preview" target="Preview">Preview</a></li>
						</ul>
					</td>
				</tr>
			</cfloop>
		</table>
	<cfelseif url.slatDetail neq "">
		<cfinclude template="#application.slatsettings.getSetting('PluginPath')#/view/Products/#url.slatDetail#.cfm" />
	</cfif>
</cfoutput>