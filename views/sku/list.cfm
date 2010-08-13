<cfif isDefined('va.Product')>
	<cfset SkusIterator = va.Product.getSkusIterator() />
<cfelse>
	<cfset SkusIterator = va.Product.getSkusIterator() />
</cfif>

<cfoutput>
	<h3 class="tableheader">Skus</h3>
	<table class="listtable">
		<tr>
			<th>Last Rec. Date</th>
			<th>Last QR</th>
			<th>Sku Code</th>
			<th>Attributes</th>
			<th>QOH</th>
			<th>QOO</th>
			<th>QC</th>
			<th>QC</th>
			<th>QIA</th>
			<th>QEA</th>
			<th>Next Arrival</th>
		</tr>
		<cfloop condition="#SkusIterator.hasNext()#">
			<cfset Sku = SkusIterator.Next() />
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td>#Sku.getAttributesString()#</td>
				<td>#Sku.getQOH()#</td>
				<td>#Sku.getQOO()#</td>
				<td>#Sku.getQC()#</td>
				<td>QS</td>
				<td class="bluebg">#Sku.getQIA()#</td>
				<td class="yellowbg">#Sku.getQEA()#</td>
				<td class="yellowbg">#DateFormat(Sku.getNextArrivalDate(),"MM/DD/YYYY")#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>