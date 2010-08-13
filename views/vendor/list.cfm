<cfset local.VendorsOrganized = request.slat.queryOrganizer.organizeQuery(application.Slat.vendorManager.getAllVendorsQuery()) />
<cfset local.vendorsIterator = application.Slat.vendorManager.getVendorIterator(local.VendorsOrganized) />
<cfoutput>
	<h3 class="tableheader">Vendors</h3>
	<table class="listtable">
		<tr>
			<th>Vendor Name</th>
			<th>Primary Phone</th>
			<th>Website</th>
		</tr>
		<cfloop condition="#local.vendorsIterator.hasNext()#">
			<cfset local.Vendor = local.vendorsIterator.Next() />
			<tr>
				<td><a href="#BuildURL(action='vendor.detail', querystring='VendorID=#local.Vendor.getVendorID()#')#">#local.Vendor.getVendorName()#</a></td>
				<td>#local.Vendor.getPrimaryPhone()#</td>
				<td><a href="#getExternalSiteLink(local.Vendor.getVendorWebsite())#">#local.Vendor.getVendorWebsite()#</a></td>
			</tr>
		</cfloop>
	</table>
</cfoutput>