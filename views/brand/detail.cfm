<cfoutput>
	<cfset Product = application.slat.ProductManager.read(ProductID=rc.ProductID) />
	<div class="ItemDetailImage"><img src="http://www.nytro.com/prodimages/#Product.getDefaultImageID()#-DEFAULT-s.jpg"></div>
	<div class="ItemDetailMain">
		<dl>
			<dt>Product Name</dt>
			<dd>#Product.getProductName()#</dd>
		</dl>
		<dl>
			<dt>Product Code</dt>
			<dd>#Product.getProductCode()#</dd>
		</dl>
		<dl>
			<dt>Brand</dt>
			<dd>#Product.getBrand()#</dd>
		</dl>
		<dl>
			<dt>Product Year</dt>
			<dd>#Product.getProductYear()#</dd>
		</dl>
		<dl>
			<dt>Gender</dt>
			<dd>#Product.getGender()#</dd>
		</dl>
	</dl>
	</div>
	<div class="ItemDetailBar">
		<dl>
			<dt>On Web</dt>
			<dd>
				<cfif Product.getActive()>
					<a href="#Product.getProductLink()#">YES</a>
				<cfelse>
					NO
				</cfif>
			</dd>
		</dl>
		<dl>
			<dt>Total QOH</dt>
			<dd>#Product.getQOH()#</dd>
		</dl>
		<dl>
			<dt>Total QOO</dt>
			<dd>#Product.getQOO()#</dd>
		</dl>
		<dl>
			<dt>Total QC</dt>
			<dd>#Product.getQC()#</dd>
		</dl>
		<dl>
			<dt></dt>
			<dd></dd>
		</dl>
		<dl class="wide">
			<dt>Original Price</dt>
			<dd>#Product.getOriginalPrice()#</dd>
		</dl>
		<dl class="wide">
			<dt>List Price</dt>
			<dd>#Product.getListPrice()#</dd>
		</dl>
		<dl class="wide">
			<dt>Price</dt>
			<dd class="green">#Product.getLivePrice()#</dd>
		</dl>
	</div>
	<div class="TCLeftTQuarter">
		#view('product/list')#
	</div>
</cfoutput>