<cfoutput>
	<cfset Vendor = application.slat.vendorManager.read(VendorID=rc.VendorID) />
	<div class="ItemDetailMain">
		<dl>
			<dt>Vendor Name</dt>
			<dd>#Vendor.getVendorName()#</dd>
		</dl>
	</div>
	<div class="ItemDetailBar">
		<dl>
			<dt>Items On Order</dt>
			<dd>##</dd>
		</dl>
	</div>
</cfoutput>