<cfoutput>
	<cfquery name="NewItemsForWeb"  datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			max(c.style) as style,
			max(c.brand) as brand,
			max(c.of2) as year,
			max(c.description) as description,
			max(a.price) as price,
			sum(a.QOH) as QOH,
			sum(a.QC) as QC,
			sum(a.QOO) as QOO,
			sum(a.QOH) + sum(a.QC) + sum(a.QOO) as QP,
			max(a.price)*(sum(a.QOH) + sum(a.QC) + sum(a.QOO)) as PP,
			max(a.price) as price,
			max(f.DTE) as rcvd_dte,
			max(a.first_rcvd) as first_rcvd,
			max(c.web_long_desc) as web_long_desc,
			max(c.picture_id) as picture_id,
			(select max(styles_web_taxonomy_id) from tb_styles_web_taxonomy where style = max(c.style_id)) as web_tax
		from
			tb_sku_buckets a
		  inner join
			tb_skus b on a.sku_id = b.SKU_ID
		  inner join
			tb_styles c on b.STYLE_ID = c.style_id
		  left join
			tb_po_skus d on a.sku_bucket_id = d.sku_bucket_id
		  left join
			tb_transfer_sku e on d.po_sku_id = e.po_sku_id
		  left join
			tb_po_boxes f on e.po_box_id = f.po_box_id
		where
			c.prepare_for_web = 'Y'
		  and
		  	(select max(price) * (sum(QOH) + sum(QC) + sum(QOO)) from tb_sku_buckets where tb_sku_buckets.sku_id = b.sku_id) > 100
		  and
			c.status_finish <> 'Y'
		  and
			(select max(dte) from tb_po_boxes inner join tb_transfer_sku on tb_po_boxes.po_box_id = tb_transfer_sku.po_box_id inner join tb_po_skus on tb_transfer_sku.po_sku_id = tb_po_skus.po_sku_id inner join tb_sku_buckets on tb_po_skus.sku_bucket_id = tb_sku_buckets.sku_bucket_id where tb_sku_buckets.sku_id = b.sku_id) is not null
		group by
			c.style
		order by
			max(f.DTE) desc, c.style desc
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th>Received</th>
			<th>Style Number</th>
			<th>Brand</th>
			<th>Year</th>
			<th>Description</th>
			<th>Price</th>
			<th>QOH</th>
			<th>QC</th>
			<th>QOO</th>
			<th>QP</th>
			<th>PP</th>
			<th>WD</th>
			<th>PIC</th>
			<th>TAX</th>
		</tr>
		<cfloop query="NewItemsForWeb">
			<cfif #NewItemsForWeb.rcvd_dte# eq #NewItemsForWeb.first_rcvd#>
				<tr class="rowgreen">
			<cfelse>
				<tr>
			</cfif>
				<td>#DateFormat(NewItemsForWeb.rcvd_dte, "mm/dd")# - #TimeFormat(NewItemsForWeb.rcvd_dte, "hh:mm")#</td>
				<td>#NewItemsForWeb.style#</td>
				<td>#NewItemsForWeb.brand#</td>
				<td>#NewItemsForWeb.year#</td>
				<td>#NewItemsForWeb.description#</td>
				<td>#NewItemsForWeb.price#</td>
				<td>#NewItemsForWeb.QOH#</td>
				<td>#NewItemsForWeb.QC#</td>
				<td>#NewItemsForWeb.QOO#</td>
				<td>#NewItemsForWeb.QP#</td>
				<td>#NewItemsForWeb.PP#</td>
				<td><cfif #NewItemsForWeb.web_long_desc# gt ''>X</cfif></td>
				<td><cfif #NewItemsForWeb.picture_id# gt ''>X</cfif></td>
				<td><cfif #NewItemsForWeb.web_tax# gt ''>X</cfif></td>
			</tr>
		</cfloop>
	</table>
</cfoutput>