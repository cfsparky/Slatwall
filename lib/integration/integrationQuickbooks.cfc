<cfcomponent output="false" name="integrationQuickbooks" hint="Database Connector for Celerant">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getCustomerShipToQuery" returntype="query" access="public" output="false" hint="">
		<cfargument name="customer_id" required="true" />
		
		<cfquery name="rs" datasource="celerantmura">
			select
				tb_cust_ship.cust_ship_id as						'ShipToID',
				tb_cust_ship.first_name as							'FirstName',
				tb_cust_ship.last_name as 							'LastName',
				tb_cust_ship.company as 							'Company',
				tb_address.state as 								'Country',
				tb_address.address1 + tb_address.address2 as 		'StreetAddress',
				tb_address.city as 									'City',
				tb_address.state as 								'State',
				tb_address.email1 as 								'Email',
				tb_address.phone1 as 								'PhoneNumber'
			from
				tb_cust_ship
			  inner join
				tb_address on tb_cust_ship.address_id = tb_address.address_id
			where
				tb_cust_ship.customer_id = '#arguments.customer_id#'
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getAllProductsQuery" access="package" output="false" retruntype="query">
		<cfquery name="rs" datasource="celerantmura" cachedwithin="#CreateTimeSpan(1,0,10,0)#">
			SELECT
				CONVERT(VARCHAR(max), max(tb_styles.style_id)) as				'ProductID',
				CONVERT(VARCHAR(max), max(tb_styles.style)) as 					'ProductCode',
				CONVERT(VARCHAR(max), max(tb_styles.web_desc)) as 				'ProductName',
				CONVERT(VARCHAR(max), max(tb_inet_names.web_text)) as			'Brand',
				CONVERT(VARCHAR(max), max(tb_styles.picture_id)) as				'DefaultImageID',
				CONVERT(VARCHAR(max), max(tb_styles.web_long_desc)) as			'ProductDescription',
				CONVERT(VARCHAR(max),'') as										'ProductExtendedDescription',
				CONVERT(VARCHAR(max), max(tb_styles.date_entered)) as			'DateCreated',
				CONVERT(VARCHAR(max),'') as 									'DateAddedToWeb',
				CONVERT(VARCHAR(max), max(tb_styles.dlu)) as					'DateLastUpdated',
				min(tb_sku_buckets.first_rcvd) as		 						'DateFirstReceived',
				CASE
					WHEN min(tb_term_sale_entries.term_sale_id) IS NULL THEN CONVERT(VARCHAR(max), 0)
					ELSE CONVERT(VARCHAR(max), 1)
				END as															'OnTermSale',
				CASE
					WHEN max(tb_term_sales.term_sale_label) LIKE 'CLEAR_%' THEN CONVERT(VARCHAR(max),1)
					ELSE CONVERT(VARCHAR(max), 0) 
				END as 															'OnClearanceSale',
				CASE max(tb_styles.non_invt) 
					WHEN 'Y' THEN CONVERT(VARCHAR(max), 1)
					ELSE CONVERT(VARCHAR(max), 0) 
				END as 															'NonInventoryItem',
				CASE max(tb_styles.of19)
					WHEN 'TELEPHONE' THEN CONVERT(VARCHAR(max), 1)
					ELSE CONVERT(VARCHAR(max), 0)
				END as															'CallToOrder',
				CASE max(tb_styles.of19)
					WHEN 'IN STORE ONLY' THEN CONVERT(VARCHAR(max), 1)
					ELSE CONVERT(VARCHAR(max), 0)
				END as															'OnlyInStore',
				CONVERT(VARCHAR(max), 0) as										'AllowBackorder',
				CONVERT(VARCHAR(max), 1) as										'AllowPreorder',
				CONVERT(VARCHAR(max), max(tb_styles.weight)) as					'Weight',
				CONVERT(VARCHAR(max), max(tb_styles.of2)) as					'ProductYear',
				CONVERT(VARCHAR(max), max(tb_styles.of1)) as					'Gender',
				CONVERT(VARCHAR(max), '') as										'SizeChart',
				'' as															'Ingredients',				
				CONVERT(VARCHAR(max), max(tb_styles.of4)) as 					'Material',
				CASE
					WHEN min(tb_term_sale_entries.term_sale_id) IS NULL THEN min(tb_sku_buckets.price)
					ELSE 
						CASE
							WHEN max(tb_term_sale_entries.TYP) = 2 THEN max(tb_term_sale_entries.amount)
							ELSE round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.01
						END
				END as 															'LivePrice',
				min(tb_sku_buckets.Sugg_Price) as 								'ListPrice',
				min(tb_sku_buckets.price) as 									'OurPrice',
				min(tb_sku_buckets.first_price) as								'MiscPrice',
				sum(tb_sku_buckets.QOH) as										'QOH',
				sum(tb_sku_buckets.qc) as 										'QC',
				sum(tb_sku_buckets.qoo) as 										'QOO'		
			FROM
				tb_styles
			  inner join
			  	tb_inet_names on tb_styles.brand = tb_inet_names.orig_text
			  		and tb_inet_names.field_name = 'BRAND'
			  inner join
			  	tb_skus on tb_styles.style_id = tb_skus.style_id
			  inner join
			  	tb_sku_buckets on tb_skus.sku_id = tb_sku_buckets.sku_id
			  left join
			  	tb_size_entries on tb_skus.scale_entry_id = tb_size_entries.scale_entry_id
			  left join
			  	tb_attr1_entries on tb_skus.attr1_entry_id = tb_attr1_entries.attr1_id
			  left join
			  	tb_attr2_entries on tb_skus.attr2_entry_id = tb_attr2_entries.attr2_id
			  left join
			  	tb_term_sale_entries on tb_styles.style_id = tb_term_sale_entries.style_id
			  		and tb_term_sale_entries.store_id = 99
					and tb_term_sale_entries.start_date < GetDate()
					and tb_term_sale_entries.end_date > GetDate()
					and exists (select tb_term_sales.approved from tb_term_sales where tb_term_sales.term_sale_id = tb_term_sale_entries.term_sale_id and tb_term_sales.approved = 'Y')
			  left join
			  	tb_term_sales on tb_term_sale_entries.term_sale_id = tb_term_sales.term_sale_id
			WHERE
				tb_styles.web_product = 'Y' and (tb_sku_buckets.qoh + tb_sku_buckets.qc > 0)
			GROUP BY
				tb_styles.style_id
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getProductQuery" access="package" output="false" retruntype="Any">
		<cfargument name="ProductID" type="string" />
		
		<cfquery name="rs" datasource="celerantmura">
			SELECT
				CONVERT(VARCHAR(max), tb_styles.style_id) as					'ProductID',
				CONVERT(VARCHAR(max), max(tb_styles.style)) as 					'ProductCode',
				CONVERT(VARCHAR(max), max(tb_styles.web_desc)) as 				'ProductName',
				CONVERT(VARCHAR(max), max(tb_inet_names.web_text)) as			'Brand',
				CONVERT(VARCHAR(max), max(tb_styles.picture_id)) as				'DefaultImageID',
				CONVERT(VARCHAR(max), max(tb_styles.web_long_desc)) as			'ProductDescription',
				'' as															'ProductExtendedDescription',
				CONVERT(VARCHAR(max), max(tb_styles.date_entered)) as			'DateCreated',
				'' as 															'DateAddedToWeb',
				CONVERT(VARCHAR(max), max(tb_styles.dlu)) as					'DateLastUpdated',
				min(tb_sku_buckets.first_rcvd) as		 						'DateFirstReceived',
				CASE
					WHEN min(tb_term_sale_entries.term_sale_id) IS NULL THEN 0
					ELSE 1
				END as															'OnTermSale',
				0 as															'OnClearanceSale',
				CASE max(tb_styles.non_invt) 
					WHEN 'Y' THEN 1
					WHEN 'N' THEN 0 
				END as 															'NonInventoryItem',
				CASE max(tb_styles.of19)
					WHEN 'TELEPHONE' THEN 1
					ELSE 0
				END as															'CallToOrder',
				CASE max(tb_styles.of19)
					WHEN 'IN STORE ONLY' THEN 1
					ELSE 0
				END as															'OnlyInStore',
				0 as															'AllowBackorder',
				1 as															'AllowPreorder',
				CONVERT(VARCHAR(max), max(tb_styles.weight)) as					'Weight',
				CONVERT(VARCHAR(max), max(tb_styles.of2)) as					'ProductYear',
				CONVERT(VARCHAR(max), max(tb_styles.of1)) as					'Gender',
				CONVERT(VARCHAR(max), max(tb_web_style_info.Size_Chart)) as		'SizeChart',
				CONVERT(VARCHAR(max), max(tb_web_style_info.Ingredients)) as	'Ingredients',				
				CONVERT(VARCHAR(max), max(tb_styles.of4)) as 					'Material',
				CASE
					WHEN min(tb_term_sale_entries.term_sale_id) IS NULL THEN min(tb_sku_buckets.price)
					ELSE 
						CASE
							WHEN max(tb_term_sale_entries.TYP) = 2 THEN max(tb_term_sale_entries.amount)
							ELSE round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.01
						END
				END as 															'LivePrice',
				min(tb_sku_buckets.Sugg_Price) as 								'ListPrice',
				min(tb_sku_buckets.price) as 									'OurPrice',
				min(tb_sku_buckets.first_price) as								'MiscPrice',
				sum(tb_sku_buckets.QOH) as										'QOH',
				sum(tb_sku_buckets.qc) as 										'QC',
				sum(tb_sku_buckets.qoo) as 										'QOO',
				'Geometry' as													'Attr1Name',
				CONVERT(VARCHAR(max), max(tb_web_style_info.geometry)) as		'Attr1Value',
				'Wheel Info' as													'Attr2Name',
				CONVERT(VARCHAR(max), max(tb_web_style_info.misc_1)) as			'Attr2Value',
				'Nutrition Info' as												'Attr3Name',
				CONVERT(VARCHAR(max), max(tb_web_style_info.misc_2)) as			'Attr3Value',
				'Frame' as														'Attr3Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.frame)) as				'Attr3Value',
				'Fork' as														'Attr4Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.fork)) as				'Attr4Value',
				'Wheels' as														'Attr5Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.wheels)) as			'Attr5Value',
				'Rims' as														'Attr6Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.rims)) as				'Attr6Value',
				'Hubs' as														'Attr7Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.hubs)) as				'Attr7Value',
				'Spokes' as														'Attr8Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.spokes)) as			'Attr8Value',
				'Tires' as														'Attr9Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.tires)) as				'Attr9Value',
				'Chain' as														'Attr10Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.chain)) as				'Attr10Value',
				'Stems' as														'Attr11Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.stem)) as				'Attr11Value',
				'Handlebar' as													'Attr12Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.handlebar)) as			'Attr12Value',
				'Front Derailleur' as											'Attr13Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.front_derailleur)) as	'Attr13Value',
				'Rear Derailleur' as											'Attr14Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.rear_derailleur)) as	'Attr14Value',
				'Shifters' as													'Attr15Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.shifters)) as			'Attr15Value',
				'Crank' as														'Attr16Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.crank)) as				'Attr16Value',
				'Bottom Bracket' as												'Attr17Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.bottom_bracket)) as	'Attr17Value',
				'Cassette' as													'Attr18Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.cassette)) as			'Attr18Value',
				'Saddle' as														'Attr19Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.saddle)) as			'Attr19Value',
				'Seat Post' as													'Attr20Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.seat_post)) as			'Attr20Value',
				'Headset' as													'Attr21Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.headset)) as			'Attr21Value',
				'Brake Callipers' as											'Attr22Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.brake_calipers)) as	'Attr22Value',
				'Brake Levers' as												'Attr23Name',
				CONVERT(VARCHAR(max), max(tb_web_compare.brake_levers)) as		'Attr23Value'
			FROM
				tb_sku_buckets
			  inner join
			  	tb_skus on tb_sku_buckets.sku_id = tb_skus.sku_id
			  inner join
				tb_styles on tb_skus.style_id = tb_styles.style_id
			  inner join
			  	tb_inet_names on tb_styles.brand = tb_inet_names.orig_text
			  left join
			  	tb_web_style_info on tb_styles.style_id = tb_web_style_info.style_id
			  left join
			  	tb_web_compare on tb_styles.style_id = tb_web_compare.style_id
			  left join
			  	tb_size_entries on tb_skus.scale_entry_id = tb_size_entries.scale_entry_id
			  left join
			  	tb_attr1_entries on tb_skus.attr1_entry_id = tb_attr1_entries.attr1_id
			  left join
			  	tb_attr2_entries on tb_skus.attr2_entry_id = tb_attr2_entries.attr2_id
			  left join
			  	tb_term_sale_entries on tb_styles.style_id = tb_term_sale_entries.style_id
			  		and tb_term_sale_entries.store_id = 99
					and tb_term_sale_entries.start_date < GetDate()
					and tb_term_sale_entries.end_date > GetDate()
					and exists (select tb_term_sales.approved from tb_term_sales where tb_term_sales.term_sale_id = tb_term_sale_entries.term_sale_id and tb_term_sales.approved = 'Y')
			WHERE
				tb_styles.style_id='#arguments.ProductID#'
			GROUP BY
				tb_styles.style_id
		</cfquery>

		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getSkusByProductIDQuery" access="package" output="false" retruntype="query">
		<cfargument name="ProductID" type="string" />

		<cfset var rs ="" />
		
		<cfquery name="rs" datasource="celerantmura">
		
			SELECT
				max(tb_skus.sku_id) as 					'SkuID',
				max(tb_skus.style_id) as 				'ProductID',
				CONVERT(VARCHAR(max), max(tb_styles.picture_id)) + '-' + CONVERT(VARCHAR(max), max(tb_attr1_entries.attr1)) as 								'ImageID',
				CASE
					WHEN min(tb_term_sale_entries.term_sale_id) IS NULL THEN min(tb_sku_buckets.price)
					ELSE 
						CASE
							WHEN max(tb_term_sale_entries.TYP) = 2 THEN max(tb_term_sale_entries.amount)
							ELSE round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2)
						END
				END as									'LivePrice',
				min(tb_sku_buckets.Sugg_Price) as 		'ListPrice',
				min(tb_sku_buckets.price) as 			'OurPrice',
				min(tb_sku_buckets.first_price) as 		'MiscPrice',
				'Size' as 								'Attr1Name',
				max(tb_size_entries.siz) as 			'Attr1Value',
				'Color' as 								'Attr2Name',
				max(tb_attr1_entries.attr1) as 			'Attr2Value',
				'Attr2' as 								'Attr3Name',
				max(tb_attr2_entries.attr2) as 			'Attr3Value',
				sum(tb_sku_buckets.qoh) as 				'QOH',
				sum(tb_sku_buckets.qc)*-1 as 			'QC',
				sum(tb_sku_buckets.qoo) as 				'QOO',
				max(tb_purchase_orders.vendor_po) as 	'NextOrderID',
				max(tb_purchase_orders.arrival_date) as 'NextArrivalDate'
			FROM
				tb_skus
			  inner join
			  	tb_sku_buckets on tb_skus.sku_id = tb_sku_buckets.sku_id
			  inner join
				tb_styles on tb_skus.style_id = tb_styles.style_id
			  left join
			  	tb_size_entries on tb_skus.scale_entry_id = tb_size_entries.scale_entry_id
			  left join
			  	tb_attr1_entries on tb_skus.attr1_entry_id = tb_attr1_entries.attr1_entry_id
			  left join
			  	tb_attr2_entries on tb_skus.attr2_entry_id = tb_attr2_entries.attr2_entry_id
			  left join
			  	tb_term_sale_entries on tb_styles.style_id = tb_term_sale_entries.style_id
			  		and tb_term_sale_entries.store_id = 99
					and tb_term_sale_entries.start_date < GetDate()
					and tb_term_sale_entries.end_date > GetDate()
					and exists (select tb_term_sales.approved from tb_term_sales where tb_term_sales.term_sale_id = tb_term_sale_entries.term_sale_id and tb_term_sales.approved = 'Y')
			  left join
				tb_po_skus on tb_sku_buckets.sku_bucket_id = tb_po_skus.sku_bucket_id
			  left join
				tb_purchase_orders on tb_po_skus.purchase_order_id = tb_purchase_orders.purchase_order_id 
			WHERE
				tb_skus.style_id = '#arguments.ProductID#'
			GROUP By
				tb_skus.sku_id
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getSkuQuery" access="package" output="false" retruntype="Any">
		<cfargument name="SkuID" type="string" />

		<cfset var rs ="" />
		
		<cfquery name="rs" datasource="celerantmura">
			SELECT
				tb_skus.sku_id as	 					'SkuID',
				max(tb_skus.style_id) as 				'ProductID',
				CONVERT(VARCHAR(max), max(tb_styles.picture_id)) + '-' + CONVERT(VARCHAR(max), max(tb_attr1_entries.attr1)) as		'ImageID',
				CASE
					WHEN min(tb_term_sale_entries.term_sale_id) IS NULL THEN min(tb_sku_buckets.price)
					ELSE 
						CASE
							WHEN max(tb_term_sale_entries.TYP) = 2 THEN max(tb_term_sale_entries.amount)
							ELSE round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.01
						END
				END as 									'LivePrice',
				min(tb_sku_buckets.Sugg_Price) as 		'ListPrice',
				min(tb_sku_buckets.price) as	 		'OurPrice',
				min(tb_sku_buckets.first_price) as 		'MiscPrice',
				'Size' as 								'Attr1Name',
				max(tb_size_entries.siz) as 			'Attr1Value',
				'Color' as 								'Attr2Name',
				max(tb_attr1_entries.attr1) as 			'Attr2Value',
				'Attr2' as 								'Attr3Name',
				max(tb_attr2_entries.attr2) as 			'Attr3Value',
				sum(tb_sku_buckets.qoh) as 				'QOH',
				sum(tb_sku_buckets.qc) as 				'QC',
				sum(tb_sku_buckets.qoo) as 				'QOO',
				max(tb_purchase_orders.vendor_po) as 	'NextOrderID',
				max(tb_purchase_orders.arrival_date) as 'NextArrivalDate'
			FROM
				tb_skus
			  inner join
			  	tb_sku_buckets on tb_skus.sku_id = tb_sku_buckets.sku_id
			  inner join
				tb_styles on tb_skus.style_id = tb_styles.style_id
			  left join
			  	tb_size_entries on tb_skus.scale_entry_id = tb_size_entries.scale_entry_id
			  left join
			  	tb_attr1_entries on tb_skus.attr1_entry_id = tb_attr1_entries.attr1_entry_id
			  left join
			  	tb_attr2_entries on tb_skus.attr2_entry_id = tb_attr2_entries.attr2_entry_id
			  left join
			  	tb_term_sale_entries on tb_styles.style_id = tb_term_sale_entries.style_id
			  		and tb_term_sale_entries.store_id = 99
					and tb_term_sale_entries.start_date < GetDate()
					and tb_term_sale_entries.end_date > GetDate()
					and exists (select tb_term_sales.approved from tb_term_sales where tb_term_sales.term_sale_id = tb_term_sale_entries.term_sale_id and tb_term_sales.approved = 'Y')
			  left join
				tb_po_skus on tb_sku_buckets.sku_bucket_id = tb_po_skus.sku_bucket_id
			  left join
				tb_purchase_orders on tb_po_skus.purchase_order_id = tb_purchase_orders.purchase_order_id 
			WHERE
				tb_skus.sku_id = '#arguments.SkuID#'
			GROUP By
				tb_skus.sku_id
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getGiftCardBalanceQuery" access="package" output="false" retruntype="Any">
		<cfargument name="GiftCardID" type="string" />

		<cfset var rs ="" />
		
		<cfquery name="rs" datasource="celerantmura">
			SELECT
				tb_smart_card.available as		'CardValue'
			FROM
				tb_smart_card 
			WHERE
				tb_smart_card.smart_card_num = '#arguments.GiftCardID#'
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
</cfcomponent>
