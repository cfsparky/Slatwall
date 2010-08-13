<cfoutput>
	<cfquery name="ReceiptDetail" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			a.comments as 'comments',
			c.store_receipt_num as 'receipt_num',
			c.store_id as 'store_id',
			b.lookup as 'lookup',
			f.siz as 'size',
			g.attr1 as 'color',
			h.attr2 as 'attr2',
			(select sum(qoh) from tb_sku_buckets where sku_id = d.sku_id) as QOH,
			(select sum(qc) from tb_sku_buckets where sku_id = d.sku_id) as QC,
			(select sum(qoo) from tb_sku_buckets where sku_id = d.sku_id) as QOO,
			e.sku_id as 'sku_id',
			i.description as 'description',
			i.style_id as 'style_id',
			a.date_time as 'order_dt',
			a.total as 'total',
			a.total_due as 'total_due',
			a.paid as 'paid',
			a.category3 as 'ordercat',
			a.machine_id as 'machine_id',
			a.current_state_id as 'current_state_id',
			b.quantity as 'quantity',
			b.shipped as 'shipped',
			j.first_name + ' ' + j.last_name as 'clerk',
			l.first_name + ' ' + l.last_name as 'salesperson',
			a.typ as 'receipt_type',
			i.of2 as 'year',
			i.brand as 'brand',
			b.notes as 'notes',
			i.non_invt as 'non_invt',
			a.ship_mode as 'ship_mode',
			m.first_name + ' ' + m.last_name as 'customer_name',
			o.email1 as 'customer_email'
		from
			tb_receipt a
		  inner join
		  	tb_receiptline b on a.receipt_num = b.receipt_num
		  inner join
		  	tb_store_receipts c on a .receipt_num = c.receipt_num
		  inner join
		  	tb_sku_buckets d on b.sku_bucket_id = d.sku_bucket_id
		  inner join
		  	tb_skus e on d.sku_id = e.sku_id
		  left join
		  	tb_size_entries f on e.scale_entry_id = f.scale_entry_id
		  left join
		  	tb_attr1_entries g on e.attr1_entry_id = g.attr1_entry_id
		  left join
		  	tb_attr2_entries h on e.attr2_entry_id = h.attr2_entry_id
		  inner join
		  	tb_styles i on e.style_id = i.style_id
		  left join
		  	tb_employee j on a.employee_id = j.employee_id
		  left join
		  	tb_receiptslsmn k on a.receipt_num = k.receipt_num
		  left join
		  	tb_employee l on k.employee_id = l.employee_id
		  inner join
		  	TB_CUSTOMERS m on a.customer_id = m.customer_id
		  inner join
		  	tb_cust_address n on m.customer_id = n.customer_id
		  inner join
		  	tb_address o on n.address_id = o.address_id
		where
			a.receipt_num = '#url.OrderID#'
		  and
		  	b.quantity > 0
	</cfquery>
	<div class="ItemDetailMain">
		<dl>
			<dt>Order Number</dt>
			<dd>#ReceiptDetail.receipt_num#</dd>
		</dl>
		<dl>
			<dt>Warehouse</dt>
			<dd>#ReceiptDetail.store_id#</dd>
		</dl>
		<dl>
			<dt>Date Placed</dt>
			<dd>#DateFormat(ReceiptDetail.order_dt, "mm/dd")# #TimeFormat(ReceiptDetail.order_dt, "hh:mm")#</dd>
		</dl>
		<dl>
			<dt>Customer</dt>
			<dd>#ReceiptDetail.customer_name# (<a href="mailto:#ReceiptDetail.customer_email#">email</a>)</dd>
		</dl>
		<dl>
			<dt>Salesperson</dt>
			<dd>#ReceiptDetail.salesperson#</dd>
		</dl>
		<dl>
			<dt>Last Mod By</dt>
			<dd>#ReceiptDetail.clerk#</dd>
		</dl>
		<dl>
			<dt>Order Type</dt>
			<dd>
				<cfif ReceiptDetail.ordercat eq "AMAZON ORDERS" or ReceiptDetail.machine_id eq "9906">
					Amazon
				<cfelseif ReceiptDetail.ordercat eq "RRS ORDERS">
					Road Runner Sports
				<cfelseif ReceiptDetail.machine_id eq "9907">
					Web
				<cfelseif ReceiptDetail.machine_id eq "9916" or ReceiptDetail.machine_id eq "9905">
					Mail Order
				<cfelseif ReceiptDetail.receipt_type eq "1">
					Service
				<cfelse>
					In Store
				</cfif>
			</dd>
		</dl>
	</div>
	<div>
		<cfset TempComments = Replace(ReceiptDetail.Comments, "#Chr(10)#", "<br />", "all") />
		#TempComments#
	</div>
	<div class="ItemDetailBar">
		<dl>
			<dt>Status</dt>
			<dd>
				<cfif ReceiptDetail.current_state_id eq 1>
					NEW
				<cfelseif ReceiptDetail.current_state_id eq 3>
					RTP
				<cfelseif ReceiptDetail.current_state_id eq 7>
					PP
				<cfelseif ReceiptDetail.current_state_id eq 2>
					BO
				<cfelseif ReceiptDetail.current_state_id eq 6>
					HOLD
				</cfif>
			</dd>
		</dl>
		<dl>
			<dt>Shipping</dt>
			<dd>
				<cfif ReceiptDetail.ship_mode eq 1>
					YES
				<cfelse>
					NO
				</cfif>
			</dd>
		</dl>
		<dl class="wide">
			<dt>Total Due</dt>
			<dd>#ReceiptDetail.total_due#</dd>
		</dl>
		<dl class="wide">
			<dt>Paid</dt>
			<dd>#ReceiptDetail.paid#</dd>
		</dl>
		<dl class="wide">
			<dt>Total</dt>
			<dd class="green">#ReceiptDetail.total#</dd>
		</dl>
	</div>

	
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th class="graybg">D Rcvd</th>
			<th class="graybg">Q Rcvd</th>
			<th>Barcode</th>
			<th>Year</th>
			<th>Brand</th>
			<th>Description</th>
			<th>Size</th>
			<th>Color</th>
			<th>ATTR 2</th>
			<th>Q</th>
			<th>S</th>
			<th>S Est</th>
			<th class="graybg">QOH</th>
			<th class="graybg">QC</th>
			<th class="graybg">I/ATS</th>
			<th class="graybg">QOO</th>
			<th class="graybg">Est AR</th>
			<th class="graybg">QE</th>
		</tr>
		<cfloop query="ReceiptDetail">
			<tr>
				<cfquery name="StyleReceived" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
					select
						min(f.dte) as dte,
						sum(e.quantity) as qreceived
					from
						tb_sku_buckets a
					inner join
						tb_transfer_sku e on e.sku_bucket_id = a.sku_bucket_id
					inner join
						tb_po_boxes f on e.po_box_id = f.po_box_id
					where
						a.sku_id = #ReceiptDetail.sku_id#
				</cfquery>
				
				<cfif StyleReceived.dte gt ReceiptDetail.order_dt>
					<td class="greenbg">#DateFormat(StyleReceived.dte, "MM/DD")# - #TimeFormat(StyleReceived.dte, "HH:MM")#</td>
					<td class="greenbg">#StyleReceived.qreceived#</td>
				<cfelse>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</cfif>
			
				<td>#ReceiptDetail.lookup#</td>
				<td>#ReceiptDetail.year#</td>
				<td><a href="#buildURL(action='brand.detail')#">#ReceiptDetail.brand#</td>
				<td><a href="#buildURL(action='product.detail',querystring='ProductID=#ReceiptDetail.style_id#')#">#ReceiptDetail.description#</a></td>
				<td>#ReceiptDetail.size#</td>
				<td>#ReceiptDetail.color#</td>
				<td>#ReceiptDetail.attr2#</td>
				<cfif ReceiptDetail.Quantity eq ReceiptDetail.Shipped><td class="greenbg"><cfelse><td></cfif>#ReceiptDetail.Quantity#</td>
				<cfif ReceiptDetail.Quantity eq ReceiptDetail.Shipped><td class="greenbg"><cfelse><td></cfif>#ReceiptDetail.Shipped#</td>
				
				<cfif ReceiptDetail.machine_id eq "9907" and ReceiptDetail.Quantity gt ReceiptDetail.Shipped>
					<cfset PotentialDate = #Replace(ReceiptDetail.notes,"ExpectedShipDate:", "", "all")# />
					<cfset PotentialDate = #Replace(PotentialDate,"[EXPECTEDSHIP=", "", "all")# />
					<cfset PotentialDate = #Replace(PotentialDate," ", "", "all")# />
					<cfset PotentialDate = #Replace(PotentialDate,"(", "", "all")# />
					<cfset PotentialDate = #Replace(PotentialDate,")", "", "all")# />
					<cfset PotentialDate = #Replace(PotentialDate,"Today", "", "all")# />
					<cfset PotentialDate = #Replace(PotentialDate,"Tomorrow", "", "all")# />	
					<cfset PotentialDate = #trim(left(PotentialDate,10))# />
					<cfif isDate(PotentialDate)>
						<cfif PotentialDate lt now()>
							<td class="yellowbg">#DateFormat(PotentialDate,"MM/DD")#</td>
						<cfelse>
							<td class="yellowbg">#DateFormat(PotentialDate,"MM/DD")#</td>
						</cfif>
					<cfelse>
						<td>#PotentialDate#</td>
					</cfif>
				<cfelse>
					<td></td>
				</cfif>
				
				<cfif ReceiptDetail.QOH lt 0>
					<td class="redbg">#ReceiptDetail.QOH#</td>
				<cfelse>
					<td>#ReceiptDetail.QOH#</td>
				</cfif>
				<td>#ReceiptDetail.QC#</td>
				<td>#ReceiptDetail.QOH + ReceiptDetail.QC#</td>
				<cfif ReceiptDetail.QOO gt 0>
					<td class="yellowbg">#ReceiptDetail.QOO#</td>
					<td class="yellowbg">
						<cfif #ReceiptDetail.qoo# gt 0>
							<cfquery name="SkuArrivalDate" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
								select
									max(e.ARRIVAL_DATE) as arrival_date
								from
									tb_sku_buckets a
								  inner join
									tb_skus b on a.sku_id = b.SKU_ID
								  inner join
									tb_styles c on b.STYLE_ID = c.style_id
								  inner join
									tb_po_skus d on a.sku_bucket_id = d.sku_bucket_id
								  inner join
									tb_purchase_orders e on d.purchase_order_id = e.purchase_order_id 
								where
									a.sku_id = #ReceiptDetail.sku_id#								
							</cfquery>
							#DateFormat(SkuArrivalDate.arrival_date,"MM/DD")#
						</cfif>
					</td>
				<cfelse>
					<td>#ReceiptDetail.qoo#</td>
					<td>&nbsp;</td>
				</cfif>
				
				<cfif ReceiptDetail.QOH lt 0>
					<cfset BuyerItemQOH = 0 />
				<cfelse>
					<cfset BuyerItemQOH = ReceiptDetail.QOH />
				</cfif>
				
				<cfif (BuyerItemQOH + ReceiptDetail.QC + ReceiptDetail.QOO) lt 0 and ReceiptDetail.non_invt eq 'N' and ReceiptDetail.QC lt 0>
					<td class="redbg">#ReceiptDetail.QOH + ReceiptDetail.QC + ReceiptDetail.QOO#</td>
				<cfelse>
					<td>#ReceiptDetail.QOH + ReceiptDetail.QC + ReceiptDetail.QOO#</td>
				</cfif>
			</tr>
		</cfloop>
	</table>
</cfoutput>