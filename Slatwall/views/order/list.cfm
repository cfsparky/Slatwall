<!--- <cfset OpenOrdersIterator = application.slat.orderManager.getOrdersIterator(application.slat.orderManager.getOpenOrdersQuery()) /> --->
<cfoutput>
	<cfquery name="OpenOrders" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			a.receipt_num as 'actual_receipt_num',
			b.store_receipt_num,
			a.store_id as 'store_id',
			a.date_time as 'date_time',
			c.last_name as 'last_name',
			c.first_name as 'first_name',
			a.current_state_id as 'current_state_id',
			a.category3 as 'ordercat',
			a.machine_id as 'machine_id',
			a.typ as 'receipt_type',
			a.pickup_date as 'pickup_date'
		from
			TB_RECEIPT a
		  inner join
			TB_STORE_RECEIPTS b on a.receipt_num = b.receipt_num
		  inner join
		  	TB_CUSTOMERS c on a.customer_id = c.customer_id
		where
			a.DATE_CLOSED IS NULL
		order by
			a.RECEIPT_NUM asc
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th>Receipt</th>
			<th>Order Date</th>
			<th>Customer</th>
			<th>Type</th>
			<th>Status</th>
			<th>Issue</th>
			<th>B</th>
			<th>IM</th>
			<th>CS</th>
			<th>P</th>
		</tr>
		<cfset TotalB = 0 />
		<cfset TotalIM = 0 />
		<cfset TotalCS = 0 />
		<cfset TotalP = 0 />
		<cfloop query="OpenOrders">
			<cfset orderstate = "">
			<cfif OpenOrders.current_state_id eq 1>
				<cfset orderstate = "New Order">
			<cfelseif OpenOrders.current_state_id eq 3>
				<cfset orderstate = "Ready To Pick">
			<cfelseif OpenOrders.current_state_id eq 7>
				<cfset orderstate = "Picks Printed">
			<cfelseif OpenOrders.current_state_id eq 2>
				<cfset orderstate = "Backorder">
			<cfelseif OpenOrders.current_state_id eq 6>
				<cfset orderstate = "On Hold">
			</cfif>
			
			<cfquery name="OpenLineItems" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
				select
					a.notes as 'notes',
					(select sum(qoh) from tb_sku_buckets where sku_id = b.sku_id) as 'QOH',
					(select sum(qoo) from tb_sku_buckets where sku_id = b.sku_id) as 'QOO',
					(select sum(qc) from tb_sku_buckets where sku_id = b.sku_id) as 'QC',
					d.non_invt as 'non_invt',
					a.quantity as 'quantity',
					a.shipped as 'shipped'
				from
					tb_receiptline a
				  inner join
				  	tb_sku_buckets b on a.sku_bucket_id = b.sku_bucket_id
				  inner join
				  	tb_skus c on b.sku_id = c.sku_id
				  inner join
				  	tb_styles d on c.style_id = d.style_id
				where
					a.receipt_num = '#OpenOrders.actual_receipt_num#'
			</cfquery>
			
			<cfset Issues = "" >
			<cfset RowColor = "rowwhite" />
			<cfset NewOrdersNotProcessedCount = 0 />
			<cfset PastExpectedShipDateCount = 0 />
			<cfset InventoryLessThanZeroCount = 0 />
			<cfset ItemsNotOnOrderCount = 0 />
			
			<cfloop query="OpenLineItems">
				<cfif OpenLineItems.Quantity gt OpenLineItems.Shipped>
					<cfset PotentialDate = #Replace(OpenLineItems.Notes,"ExpectedShipDate:", "", "all")# />
					<cfset PotentialDate = #Replace(PotentialDate," ", "", "all")# />
					<cfset PotentialDate = #Replace(PotentialDate,"(", "", "all")# />
					<cfset PotentialDate = #Replace(PotentialDate,")", "", "all")# />
					<cfset PotentialDate = #Replace(PotentialDate,"Today", "", "all")# />
					<cfset PotentialDate = #Replace(PotentialDate,"Tomorrow", "", "all")# />	
					<cfset PotentialDate = #trim(PotentialDate)# />
					<cfif isDate(PotentialDate)>
						<cfif PotentialDate lt now()>
							<cfset PastExpectedShipDateCount = PastExpectedShipDateCount + 1>
						</cfif>
					<!---
					<cfelseif isDate(OpenOrders.pickup_date)>
						<cfif OpenOrders.pickup_date lt now()>
							<cfset PastExpectedShipDateCount = PastExpectedShipDateCount + 1>
						</cfif>
					--->
					</cfif>
				</cfif>
				
				<cfif OpenLineItems.QOH lt 0 and OpenLineItems.quantity gt OpenLineItems.shipped>
					<cfset InventoryLessThanZeroCount = InventoryLessThanZeroCount + 1>
				</cfif>
				
				<cfif OpenLineItems.QOH lt 0>
					<cfset BuyerItemQOH = 0 />
				<cfelse>
					<cfset BuyerItemQOH = OpenLineItems.QOH />
				</cfif>
				
				<cfif (BuyerItemQOH + OpenLineItems.QC + OpenLineItems.QOO) lt 0 and OpenLineItems.non_invt eq 'N' and OpenLineItems.QC lt 0 and OpenLineItems.quantity gt OpenLineItems.shipped>
					<cfset ItemsNotOnOrderCount = ItemsNotOnOrderCount + 1 />
				</cfif>
			</cfloop>
			
			<cfif DateFormat(OpenOrders.date_time, "MM/DD") lt DateFormat(now()-5, "MM/DD") and orderstate eq "New Order" >
				<cfset NewOrdersNotProcessedCount = 1>
				<cfset Issues = "#Issues#Order still set as New after 5 days<br />" />
				<cfset RowColor = "yellowbg" />
			</cfif>
			<!--- Add Past Expected Ship Date Count --->
			<cfif PastExpectedShipDateCount gt 0>
				<cfset Issues = "#Issues##PastExpectedShipDateCount# Item(s) Past the Expected Ship Date<br />" />
				<cfset RowColor = "yellowbg" />
			</cfif>
			<!--- Add Inventory Less Than Zero Errors --->
			<cfif InventoryLessThanZeroCount gt 0>
				<cfset Issues = "#Issues##InventoryLessThanZeroCount# Item(s) Have QOH Less that Zero<br />" />
				<cfset RowColor = "redbg" />
			</cfif>
			<!--- Add Not on Order Errors --->
			<cfif ItemsNotOnOrderCount gt 0>
				<cfset Issues = "#Issues##ItemsNotOnOrderCount# Item(s) Not On Open PO, when they should be<br />" />
				<cfset RowColor = "redbg" />
			</cfif>
			
			<tr class="#RowColor#">
				<td><a href="#buildURL(action='order.detail',querystring='OrderID=#OpenOrders.actual_receipt_num#')#">#OpenOrders.store_receipt_num#-#OpenOrders.store_id#</a></td>
				<td>#DateFormat(OpenOrders.date_time, "MM/DD")# - #TimeFormat(OpenOrders.date_time, "HH:MM")#</td>
				<td><a href="#buildURL(action='customer.detail',querystring='CustomerID=#OpenOrders.actual_receipt_num#')#">#OpenOrders.first_name# #OpenOrders.last_name#</a></td>
				<td>
					<cfif OpenOrders.ordercat eq "AMAZON ORDERS" or OpenOrders.machine_id eq "9906">
						Amazon
					<cfelseif OpenOrders.ordercat eq "RRS ORDERS">
						Road Runner Sports
					<cfelseif OpenOrders.machine_id eq "9907">
						Web
					<cfelseif OpenOrders.machine_id eq "9916" or OpenOrders.machine_id eq "9905">
						Mail Order
					<cfelseif OpenOrders.receipt_type eq "1">
						Service
					<cfelse>
						In Store
					</cfif>
				</td>
				<td>#orderstate#</td>
				<td>#Issues#</td>
				<td>#ItemsNotOnOrderCount#</td>
				<td>#InventoryLessThanZeroCount#</td>
				<td>#PastExpectedShipDateCount#</td>
				<td>#NewOrdersNotProcessedCount#</td>
				<cfset TotalB = TotalB + ItemsNotOnOrderCount />
				<cfset TotalIM = TotalIM + InventoryLessThanZeroCount />
				<cfset TotalCS = TotalCS + PastExpectedShipDateCount />
				<cfset TotalP = TotalP + NewOrdersNotProcessedCount />
			</tr>
		</cfloop>
		<tr>
			<td colspan="6"><strong>Total: #OpenOrders.recordcount# Open Orders</strong></td>
			<td><strong>#TotalB#</strong></td>
			<td><strong>#TotalIM#</strong></td>
			<td><strong>#TotalCS#</strong></td>
			<td><strong>#TotalP#</strong></td>
		</tr>
	</table>
</cfoutput>