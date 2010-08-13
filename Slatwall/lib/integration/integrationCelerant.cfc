<cfcomponent output="false" name="integrationCelerant" hint="Database Connector for Celerant">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllProductsQuery" access="package" output="false" retruntype="Query">
		<cfset var AllProductsQuery = querynew('empty') />
		
		<cfif FileExists("#ExpandPath(application.slatsettings.getSetting('PluginPath'))#\lib\integration\customSQL\AllProductsQuery.SQL.cfm")>
			<cfinclude template="customSQL/AllProductsQuery.SQL.cfm">
		<cfelse>
			<cfquery name="AllProductsQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
				SELECT
					CONVERT(VARCHAR(max), max(tb_styles.style_id)) as				'ProductID',
					CASE
						WHEN max(tb_styles.web_product) = 'Y' THEN CONVERT(VARCHAR(max), 1)
						ELSE CONVERT(VARCHAR(max), 0)
					END as															'Active',
					CONVERT(VARCHAR(max), max(tb_styles.style)) as 					'ProductCode',
					CONVERT(VARCHAR(max), max(tb_styles.web_desc)) as 				'ProductName',
					CONVERT(VARCHAR(max), max(tb_styles.brand)) as					'BrandID',
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
					0 as 															'OnClearanceSale',
					CASE max(tb_styles.non_invt) 
						WHEN 'Y' THEN CONVERT(VARCHAR(max), 1)
						ELSE CONVERT(VARCHAR(max), 0) 
					END as 															'NonInventoryItem',
					0 as															'CallToOrder',
					0 as															'OnlyInStore',
					0 as															'AllowBackorder',
					0 as															'AllowPreorder',
					CONVERT(VARCHAR(max), max(tb_styles.weight)) as					'Weight',
					'' as															'ProductYear',
					'' as															'Gender',
					'' as															'SizeChart',
					'' as															'Ingredients',				
					'' as 															'Material',
					CASE
						WHEN min(tb_term_sale_entries.term_sale_id) IS NULL THEN min(tb_sku_buckets.price)
						ELSE 
							CASE
								WHEN max(tb_term_sale_entries.TYP) = 2 THEN max(tb_term_sale_entries.amount)
								ELSE
									CASE max(tb_term_sale_entries.rounding)
										WHEN 0 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.01
										WHEN 1 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)
										WHEN 3 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.02
										WHEN 4 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.03
										ELSE round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2)
									END
							END
					END as 															'LivePrice',
					min(tb_sku_buckets.Sugg_Price) as 								'ListPrice',
					min(tb_sku_buckets.price) as 									'OriginalPrice',
					min(tb_sku_buckets.first_price) as								'MiscPrice',
					sum(tb_sku_buckets.QOH) as										'QOH',
					sum(tb_sku_buckets.qc)*-1 as 									'QC',
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
					(tb_sku_buckets.qoh + tb_sku_buckets.qc + tb_sku_buckets.qoo) > 0
				GROUP BY
					tb_styles.style_id
			</cfquery>
		</cfif>
		
		<cfreturn AllProductsQuery />
		
	</cffunction>
	
	<cffunction name="getProductQuery" access="package" output="false" retruntype="Query">
		<cfargument name="ProductID" type="string" />
		
		<cfset var ProductQuery = querynew('empty') />
		
		<cfif FileExists("#ExpandPath(application.slatsettings.getSetting('PluginPath'))#\lib\integration\customSQL\ProductQuery.SQL.cfm")>
			<cfinclude template="customSQL/ProductQuery.SQL.cfm">
		<cfelse>
			<cfquery name="ProductQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
				SELECT
					CONVERT(VARCHAR(max), tb_styles.style_id) as					'ProductID',
					CASE
						WHEN max(tb_styles.web_product) = 'Y' THEN CONVERT(VARCHAR(max), 1)
						ELSE CONVERT(VARCHAR(max), 0)
					END as															'Active',
					CONVERT(VARCHAR(max), max(tb_styles.style)) as 					'ProductCode',
					CONVERT(VARCHAR(max), max(tb_styles.web_desc)) as 				'ProductName',
					CONVERT(VARCHAR(max), max(tb_styles.brand)) as					'BrandID',
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
					0 as															'CallToOrder',
					0 as															'OnlyInStore',
					0 as															'AllowBackorder',
					0 as															'AllowPreorder',
					CONVERT(VARCHAR(max), max(tb_styles.weight)) as					'Weight',
					'' as															'ProductYear',
					'' as															'Gender',
					'' as															'SizeChart',
					'' as															'Ingredients',				
					'' as 															'Material',
					CASE
						WHEN min(tb_term_sale_entries.term_sale_id) IS NULL THEN min(tb_sku_buckets.price)
						ELSE 
							CASE
								WHEN max(tb_term_sale_entries.TYP) = 2 THEN max(tb_term_sale_entries.amount)
								ELSE
									CASE max(tb_term_sale_entries.rounding)
										WHEN 0 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.01
										WHEN 1 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)
										WHEN 3 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.02
										WHEN 4 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.03
										ELSE round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2)
									END
							END
					END as 															'LivePrice',
					min(tb_sku_buckets.Sugg_Price) as 								'ListPrice',
					min(tb_sku_buckets.price) as 									'OriginalPrice',
					min(tb_sku_buckets.first_price) as								'MiscPrice',
					sum(tb_sku_buckets.QOH) as										'QOH',
					sum(tb_sku_buckets.qc)*-1 as 									'QC',
					sum(tb_sku_buckets.qoo) as 										'QOO'
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
		</cfif>
		
		<cfreturn ProductQuery />
	</cffunction>
	
	<cffunction name="getSkusByProductIDQuery" access="package" output="false" retruntype="query">
		<cfargument name="ProductID" type="string" />
		
		<cfset var SkusByProductIDQuery = querynew('empty') />

		<cfif FileExists("#ExpandPath(application.slatsettings.getSetting('PluginPath'))#\lib\integration\customSQL\SkusByProductIDQuery.SQL.cfm")>
			<cfinclude template="customSQL/SkusByProductIDQuery.SQL.cfm">
		<cfelse>
			<cfquery name="SkusByProductIDQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
				SELECT
					max(tb_skus.sku_id) as 					'SkuID',
					max(tb_skus.style_id) as 				'ProductID',
					CONVERT(VARCHAR(max), max(tb_styles.picture_id)) + '-' + CONVERT(VARCHAR(max), max(tb_attr1_entries.attr1)) as 								'ImageID',
					CASE
						WHEN min(tb_term_sale_entries.term_sale_id) IS NULL THEN min(tb_sku_buckets.price)
						ELSE 
							CASE
								WHEN max(tb_term_sale_entries.TYP) = 2 THEN max(tb_term_sale_entries.amount)
								ELSE
									CASE max(tb_term_sale_entries.rounding)
										WHEN 0 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.01
										WHEN 1 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)
										WHEN 3 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.02
										WHEN 4 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.03
										ELSE round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2)
									END
							END
					END as									'LivePrice',
					
					min(tb_sku_buckets.Sugg_Price) as 		'ListPrice',
					min(tb_sku_buckets.price) as 			'OriginalPrice',
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
					(
						Select top 1 
							tb_purchase_orders.vendor_po
						from
							tb_purchase_orders
						  inner join
							tb_po_skus on tb_po_skus.purchase_order_id = tb_purchase_orders.purchase_order_id
						  inner join
							tb_sku_buckets b on tb_po_skus.sku_bucket_id = b.sku_bucket_id
						where
							b.sku_id = tb_skus.sku_id
						  and
							tb_purchase_orders.closed='N'
					) as									'NextOrderID',
					(
						Select top 1 
							tb_purchase_orders.arrival_date
						from
							tb_purchase_orders
						  inner join
							tb_po_skus on tb_po_skus.purchase_order_id = tb_purchase_orders.purchase_order_id
						  inner join
							tb_sku_buckets b on tb_po_skus.sku_bucket_id = b.sku_bucket_id
						where
							b.sku_id = tb_skus.sku_id
						  and
							tb_purchase_orders.closed='N'
					) as									'NextArrivalDate',
					0 as									'DaysToOrder',
					0 as									'AdditionalDaysToShip',
					1 as									'isTaxable',
					1 as									'isDiscountable'
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
				WHERE
					tb_skus.style_id = '#arguments.ProductID#'
				GROUP By
					tb_skus.sku_id
			</cfquery>
		</cfif>
		
		
		<cfreturn SkusByProductIDQuery />
	</cffunction>
	
	<cffunction name="getSkuQuery" access="package" output="false" retruntype="Any">
		<cfargument name="SkuID" type="string" />
		
		<cfset var SkuQuery = querynew('empty') />

		<cfif FileExists("#ExpandPath(application.slatsettings.getSetting('PluginPath'))#\lib\integration\customSQL\SkuQuery.SQL.cfm")>
			<cfinclude template="customSQL/SkuQuery.SQL.cfm">
		<cfelse>
			<cfquery name="SkuQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
				SELECT
					tb_skus.sku_id as	 					'SkuID',
					max(tb_skus.style_id) as 				'ProductID',
					min(tb_styles.picture_id) as 			'ImageID',
					--CONVERT(VARCHAR(max), max(tb_styles.picture_id)) + '-' + CONVERT(VARCHAR(max), max(tb_attr1_entries.attr1)) as		'ImageID',
					CASE
						WHEN min(tb_term_sale_entries.term_sale_id) IS NULL THEN min(tb_sku_buckets.price)
						ELSE 
							CASE
								WHEN max(tb_term_sale_entries.TYP) = 2 THEN max(tb_term_sale_entries.amount)
								ELSE
									CASE max(tb_term_sale_entries.rounding)
										WHEN 0 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.01
										WHEN 1 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)
										WHEN 3 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.02
										WHEN 4 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.03
										ELSE round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2)
									END
							END
					END as 									'LivePrice',
					min(tb_sku_buckets.Sugg_Price) as 		'ListPrice',
					min(tb_sku_buckets.price) as	 		'OriginalPrice',
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
					(
						Select top 1 
							tb_purchase_orders.vendor_po
						from
							tb_purchase_orders
						  inner join
							tb_po_skus on tb_po_skus.purchase_order_id = tb_purchase_orders.purchase_order_id
						  inner join
							tb_sku_buckets b on tb_po_skus.sku_bucket_id = b.sku_bucket_id
						where
							b.sku_id = tb_skus.sku_id
						  and
							tb_purchase_orders.closed='N'
					) as									'NextOrderID',
					(
						Select top 1 
							tb_purchase_orders.arrival_date
						from
							tb_purchase_orders
						  inner join
							tb_po_skus on tb_po_skus.purchase_order_id = tb_purchase_orders.purchase_order_id
						  inner join
							tb_sku_buckets b on tb_po_skus.sku_bucket_id = b.sku_bucket_id
						where
							b.sku_id = tb_skus.sku_id
						  and
							tb_purchase_orders.closed='N'
					) as									'NextArrivalDate',
					0 as									'DaysToOrder',
					0 as									'AdditionalDaysToShip',
					1 as									'isTaxable',
					1 as									'isDiscountable'
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
				WHERE
					tb_skus.sku_id = '#arguments.SkuID#'
				GROUP By
					tb_skus.sku_id
			</cfquery>
		</cfif>
		
		<cfreturn SkuQuery />
	</cffunction>
	
	<cffunction name="getGiftCardBalanceQuery" access="package" output="false" retruntype="Any">
		<cfargument name="GiftCardID" type="string" />
		
		<cfset var GiftCardBalance = querynew('empty') />

		<cfquery name="GiftCardBalance" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
			SELECT
				tb_smart_card.available as		'CardValue'
			FROM
				tb_smart_card 
			WHERE
				tb_smart_card.smart_card_num = '#arguments.GiftCardID#'
		</cfquery>
		
		<cfreturn GiftCardBalance />
	</cffunction>
	
	<cffunction name="getCouponQuery" access="public" returntype="any" output="false">
		<cfargument name="CouponID" type="String" />
		
		<cfset var CouponQuery = querynew('empty') />
		
		<cfquery name="CouponQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				tb_coupon.coupon_id as		'CouponID',
				tb_coupon.lookup as			'CouponCode',
				tb_coupon.typ as			'CouponTypeID',
				tb_coupon.amount_off as		'Amount',
				tb_coupon.label as			'Description',
				tb_coupon.act_date as		'StartDate',				<!--- Deactivation Criteria --->
				tb_coupon.deact_date as		'EndDate',					<!--- Deactivation Criteria --->
				tb_coupon.active_days as	'ValidDays',				<!--- Deactivation Criteria --->
				tb_coupon.min_items as		'MinimumCartItemsQuantity',
				tb_coupon.min_spend as		'MinimumCartItemsValue',
				0 as						'SelectedProductsOnly',
				0 as						'OneUsePerCustomer',
				0 as						'OneUsePerSite'
			FROM
				tb_coupon
			WHERE
				tb_coupon.coupon_id = '#arguments.CouponID#'
		</cfquery>
		
		<cfreturn CouponQuery />
	</cffunction>
	
	<cffunction name="getCouponProductsQuery" access="public" returntype="any" output="false">
		<cfargument name="CouponID" type="String" />
		
		<cfset var CouponProducts = querynew('empty') />
		
		<cfquery name="CouponProducts" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT DISTINCT
				tb_couponitems.style_id as	'ProductID',
			FROM
				tb_couponitems
			WHERE
				tb_couponitems.coupon_id = '#arguments.CouponID#'
		</cfquery>
		
		<cfreturn CouponProducts />
	</cffunction>
	
	<cffunction name="getAllCouponsQuery" access="public" returntype="query" output="false">
	
		<cfset var AllCoupons = querynew('empty') />
		
		<cfquery name="AllCoupons" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				tb_coupon.coupon_id as		'CouponID',
				tb_coupon.lookup as			'CouponCode',
				tb_coupon.typ as			'CouponTypeID',
				tb_coupon.amount_off as		'Amount',
				tb_coupon.label as			'Description',
				tb_coupon.act_date as		'StartDate',
				tb_coupon.deact_date as		'EndDate',
				tb_coupon.active_days as	'ValidDays',
				tb_coupon.min_items as		'MinimumCartItemsQuantity',
				tb_coupon.min_spend as		'MinimumCartItemsValue',
				0 as						'SelectedProductsOnly',
				0 as						'OneUsePerCustomer',
				0 as						'OneUsePerSite'
			FROM
				tb_coupon
		</cfquery>
		
		<cfreturn AllCoupons />
	</cffunction>
	
	<cffunction name="getAllVendorsQuery" access="public" returntype="query" output="false">
		<cfset var AllVendorsQuery = querynew('empty') />
		
		<cfquery name="AllVendorsQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				tb_contacts.contact_id as 'VendorID',
				tb_contacts.Company as 'VendorName',
				'' as 'AccountNumber',
				tb_address.web_site as VendorWebsite,
				tb_address.phone1 as 'PrimaryPhone'
			FROM
				tb_contacts
			  INNER JOIN
			  	tb_contact_address on tb_contacts.contact_id = tb_contact_address.contact_id
			  INNER JOIN
			  	tb_address on tb_contact_address.address_id = tb_address.address_id
			WHERE
				tb_contacts.is_vendor = <cfqueryparam value="Y" />
		</cfquery>
		
		<cfreturn AllVendorsQuery />
	</cffunction>
	
	<cffunction name="getVendorQuery" access="public" returntype="query" output="false">
		<cfargument name="VendorID" required="true">
		<cfset var VendorQuery = querynew('empty') />
		
		<cfquery name="VendorQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				tb_contacts.contact_id as 'VendorID',
				tb_contacts.Company as 'VendorName',
				'' as 'AccountNumber',
				tb_address.web_site as VendorWebsite,
				tb_address.phone1 as 'PrimaryPhone'
			FROM
				tb_contacts
			  INNER JOIN
			  	tb_contact_address on tb_contacts.contact_id = tb_contact_address.contact_id
			  INNER JOIN
			  	tb_address on tb_contact_address.address_id = tb_address.address_id
			WHERE
				tb_contacts.contact_id = <cfqueryparam value="#arguments.VendorID#" />
		</cfquery>
		
		<cfreturn VendorQuery />
	</cffunction>
	
	<cffunction name="getAllBrandsQuery" access="public" returntype="query" output="false">
		<cfset var AllBrandsQuery = querynew('empty') />
		
		<cfquery name="AllBrandsQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				tb_contacts.contact_id as 'VendorID',
				tb_contacts.Company as 'VendorName',
				'' as 'AccountNumber',
				tb_address.web_site as VendorWebsite,
				tb_address.phone1 as 'PrimaryPhone'
			FROM
				tb_contacts
			  INNER JOIN
			  	tb_contact_address on tb_contacts.contact_id = tb_contact_address.contact_id
			  INNER JOIN
			  	tb_address on tb_contact_address.address_id = tb_address.address_id
			WHERE
				tb_contacts.is_vendor = <cfqueryparam value="Y" />
		</cfquery>
		
		<cfreturn AllBrandsQuery />
	</cffunction>
	
	
	<cffunction name="getAllContactsQuery" access="public" returntype="query" output="false">
		<cfset var AllContactsQuery = querynew('empty') />
		
		<cfquery name="AllContactsQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				tb_contacts.contact_id as 'ContactID',
				tb_contacts.Company as 'ContactName'
			FROM
				tb_contacts
			  INNER JOIN
			  	tb_contact_address on tb_contacts.contact_id = tb_contact_address.contact_id
			  INNER JOIN
			  	tb_address on tb_contact_address.address_id = tb_address.address_id
			WHERE
				tb_contacts.is_vendor <> <cfqueryparam value="Y" />
		</cfquery>
		
		<cfreturn AllContactsQuery />
	</cffunction>
	
	<cffunction name="insertNewOrder" access="package" output="false" retruntype="Any">
		<cfargument name="Order" type="struct" required="true" />
		
		<cfset variables.customer_id = "" />
		
		<cfif Order.GuestCheckout>
			<cfset variables.customer_id = getNewCustomerID(
				BillingAddress=arguments.Order.BillingAddress
			) />
		<cfelseif Order.CustomerID neq "">
			<cfset variables.customer_id = Order.CustomerID />
		<cfelseif Order.CustomerID eq "" and Session.Mura.isLoggedIn eq true>
			<cfset ThisUser = #application.userManager.read(userid='#Session.Mura.UserID#',siteid='default')# />
			<cfif ThisUser.getRemoteID() eq "">
				<cfset variables.customer_id = getNewCustomerID(
					BillingAddress=arguments.Order.BillingAddress
					) /> 
				<cfset ThisUser.setRemoteID(variables.customer_id) />
				<cfset ThisUser.save() />
			<cfelse>
				<cfset variables.customer_id = ThisUser.getRemoteID() />
			</cfif>
		<cfelse>
			<cfset application.slat.messageManager.addMessage(MessageCode='OR01') />
		</cfif>
		
		<cfset variables.cust_ship_id = getCustomerShippingAddressID(CustomerID="#variables.customer_id#",ShippingAddress=arguments.Order.ShippingAddress) />
		
		<cfset variables.receipt_num = getNewIDFromGenerator("receipt_num") />
		<cfset variables.store_receipt_num = getNewIDFromGenerator("store_receipt_num_99") />
		<cfset variables.receipt_ship_num = getNewIDFromGenerator("receipt_ship_id") />
		<cfset variables.ship_method_id = getShipMethodID("#arguments.Order.ShippingMethod.Carrier#","#arguments.Order.ShippingMethod.Method#") />
		
		<cfset variables.total_due = arguments.Order.Total>
		<cfset variables.paid = 0>
		<cfset MethodIndex="">
		<cfloop from="1" to="#arraylen(Arguments.Order.PaymentMethods)#" index="MethodIndex">
			<cfif Arguments.Order.PaymentMethods[MethodIndex].Type eq "GiftCard" or Arguments.Order.PaymentMethods[MethodIndex].Type eq "RRS" or Arguments.Order.PaymentMethods[MethodIndex].Type eq "Amazon">
				<cfset variables.total_due = variables.total_due - Arguments.Order.PaymentMethods[MethodIndex].Amount>
				<cfset variables.paid = variables.paid + Arguments.Order.PaymentMethods[MethodIndex].Amount>
			</cfif>
		</cfloop>
		
		<!--- Add Basic Receipt Info --->
		<cfquery name="InsertReceipt" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			insert into tb_receipt(
				machine_id,
				receipt_num,
				date_time,
				customer_id,
				store_id,
				shipping_charge,
				subtotal,
				line_disc_amount,
				after_disc_amnt,
				total,
				tax1,
				tax2,
				paid,
				typ,
				total_weight,
				ship_mode,
				total_due,
				total_credits,
				comments,
				OUR_NUM,
				WEB_STATUS,
				PICKUP_DATE,
				READY_TO_PICKUP,
				CLOSED,
				current_state_id,
				alteration_charge,
				category3)
			VALUES(
				'#arguments.Order.TerminalID#',
				#variables.receipt_num#,
				'#dateformat(now(),'m/d/yyyy')# #timeformat(now(),'HH:MM:SS')#',
				#variables.customer_id#,
				'#arguments.Order.WarehouseID#',
				#arguments.Order.ShippingMethod.Cost#,
				#arguments.Order.TotalItems#,
				#arguments.Order.TotalItemDiscounts#,
				#arguments.Order.Total#,
				#arguments.Order.Total#,
				#arguments.Order.TotalTaxByType[1].Amount#,
				#arguments.Order.TotalTaxByType[2].Amount#,
				#variables.paid#,
				2,
				#arguments.Order.TotalShippingWeight#,
				1,
				#variables.total_due#,
				0,
				'',
				'#arguments.Order.RemoteOrderID#',
				1,
				null,
				'N',
				'N',
				1,
				0,
				'#arguments.Order.OrderType#')
		</cfquery>
		<cfquery name="InsertStoreReceipt" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			insert into tb_store_receipts(
				store_receipt_num,
				receipt_num,
				store_id)
			values(
				#variables.store_receipt_num#,
				#variables.receipt_num#,
				'#arguments.Order.WarehouseID#')
		</cfquery>
		<cfquery name="InsertReceiptShip" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			insert into tb_receipt_ship(
				receipt_ship_id,
				receipt_num,
				customer_id,
				cust_ship_id,
				ship_method_id)
			values(
				#variables.receipt_ship_num#,
				#variables.receipt_num#,
				#variables.customer_id#,
				#variables.cust_ship_id#,
				#variables.ship_method_id#)
		</cfquery>
		
		<!--- Loop Over Credit Card Payments And Add To Celerant --->
		<cfloop array="#Arguments.Order.PaymentMethods#" index="Payment">
		
			<cfif Payment.Type eq "Visa" or Payment.Type eq "MasterCard" or Payment.Type eq "Discover" or Payment.Type eq "AMEX">
				
				<cfset variables.cust_card_id = getNewIDFromGenerator("cust_card_id") />
				<cfset variables.setup_tender_id = getSetupTenderID("#Payment.Type#") />
				<cfset variables.tender_num = getNewIDFromGenerator("tender_num") />
				
				<cfquery name="InsertCustCard" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
					insert into tb_cust_card (
						card_num,
						customer_id,
						cust_card_id,
						cvv2,
						DLU,
						exp_date,
						name_on_card,
						setup_tender_id)
					values(
						'#Payment.CardNumber#',
						#variables.customer_id#,
						#variables.cust_card_id#,
						'#Payment.SecurityCode#',
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />,
						'#Payment.ExpirationMonth##Right(Payment.ExpirationYear,2)#',
						'#left(Payment.CardHolderName,24)#',
						#variables.setup_tender_id#)
				</cfquery>
				
				<cfquery name="InsertTendered" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
					insert into tb_tendered(
						tender_num,
						receipt_num,
						date_time,
						amount,
						actual,
						setup_tender_id,
						sdte,
						machine_id)
					values(
						#variables.tender_num#,
						#variables.receipt_num#,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />,
						0,
						0,
						'#variables.setup_tender_id#',
						'#dateformat(now(),'yyyy-mm-dd')#',
						#arguments.Order.TerminalID#)
				</cfquery>
	
		
				<cfquery name="InsertCCDetails" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
					insert into tb_cc_details(
						tender_num,
						card_num,
						exp_date,
						auth_code,
						ref_num,
						name_on_card)
					values(
						#variables.tender_num#,
						'#Payment.CardNumber#',
						'#Payment.ExpirationMonth##Right(Payment.ExpirationYear,2)#',
						'#Payment.PreAuthorizationCode#',
						'#Payment.ReferenceNumber#',
						'#left(Payment.CardHolderName,24)#')
				</cfquery>
				
				<cfquery name="UpdateHouseAccount" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
					UPDATE
						tb_house_account
					SET
						card_num = '#Payment.CardNumber#',
						exp_date = '#Payment.ExpirationMonth##Right(Payment.ExpirationYear,2)#',
						name_on_card = '#Left(Payment.CardHolderName,25)#'
					WHERE
						customer_id = '#variables.customer_id#'
				</cfquery>
			<cfelseif Payment.Type eq "GiftCard">
				<cfset variables.smcd_used_id = getNewIDFromGenerator("smcd_used_id") />
				<cfset variables.smart_card_id = getSmartCardID("#Payment.CardNumber#") />
			
				<cfquery name="insertgiftcard" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
					INSERT INTO tb_smcd_used(
						smcd_used_id,
						smart_card_id,
						amount,
						receipt_num,
						dte,
						dlu)
					VALUES (
						#variables.smcd_used_id#,
						#variables.smart_card_id#,
						#Payment.Amount#,
						#variables.receipt_num#,
						'#dateformat(now(),'m/d/yyyy')#','#dateformat(now(),'m/d/yyyy')#')
				</cfquery>
			<cfelseif Payment.Type eq "RRS">
			
				<cfset variables.tender_num = getNewIDFromGenerator("tender_num") />
				
				<cfquery name="InsertTendered" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
					insert into tb_tendered(
						tender_num,
						receipt_num,
						date_time,
						amount,
						actual,
						setup_tender_id,
						sdte,
						machine_id)
					values(
						#variables.tender_num#,
						#variables.receipt_num#,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />,
						#Payment.Amount#,
						#Payment.Amount#,
						'18',
						'#dateformat(now(),'yyyy-mm-dd')#',
						#arguments.Order.TerminalID#)
				</cfquery>
			<cfelseif Payment.Type eq "Amazon">
			
				<cfset variables.tender_num = getNewIDFromGenerator("tender_num") />
				
				<cfquery name="InsertTendered" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
					insert into tb_tendered(
						tender_num,
						receipt_num,
						date_time,
						amount,
						actual,
						setup_tender_id,
						sdte,
						machine_id)
					values(
						#variables.tender_num#,
						#variables.receipt_num#,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />,
						#Payment.Amount#,
						#Payment.Amount#,
						'16',
						'#dateformat(now(),'yyyy-mm-dd')#',
						#arguments.Order.TerminalID#)
				</cfquery>
			</cfif>
		</cfloop>
		
		<!--- Loop Over Line Items and Add To DB --->
		<cfloop array="#arguments.Order.OrderItems#" index="OrderItem">
			
			<cfset variables.receiptline_id = getNewIDFromGenerator("receiptline_id") />
			<cfset variables.lookup = getSkuLookup("#OrderItem.SkuID#") />
			<cfset variables.avg_cost = getSkuAverageCost("#OrderItem.SkuID#", "#arguments.Order.WarehouseID#") />
			<cfset variables.sku_bucket_id = getSkuBucketID("#OrderItem.SkuID#", "#arguments.Order.WarehouseID#") />
			<cfset variables.sale_typ = 0>
			<cfset variables.off_from = 0>
			<cfset variables.term_sale_sav = 0>
			<cfset variables.man_reason_1 = "">+
			<cfset variables.item_notes = "[EXPECTEDSHIP=#OrderItem.ExpectedShipDate#][ORIGINALQTY=#OrderItem.Quantity#]#chr(13)##OrderItem.Notes#">
			<cfif OrderItem.PriceDetail.AdjustmentType eq "Coupon">
				<cfset variables.sale_typ = 2>
			<cfelseif OrderItem.PriceDetail.AdjustmentType eq "Sale">
				<cfset variables.sale_typ = 5>
				<cfset variables.off_from = 1>
				<cfset variables.term_sale_sav = round((OrderItem.PriceDetail.OriginalPrice - OrderItem.Price)*100)/100>
				<cfset variables.man_reason_1 = "#OrderItem.PriceDetail.AdjustmentDetail#">
			</cfif>
			<cfquery name="InsertReceiptline" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
				insert into tb_receiptline(
					receiptline_id,
					receipt_num,
					price,
					lookup,
					extended,
					orig_price,
					reg_markdown,
					cost,
					web_flag,
					sku_bucket_id,
					mkdn_reason,
					coupon_barcode,
					quantity,
					notes,
					off_from,
					sale_typ,
					term_sale_sav,
					tax1_per,
					tax1_amount,
					tax2_per,
					tax2_amount,
					man_reason_1
					)
				values(
					'#variables.receiptline_id#',
					'#variables.receipt_num#',
					'#OrderItem.Price#',
					'#variables.lookup#',
					'#OrderItem.PriceExtended#',
					'#OrderItem.PriceDetail.OriginalPrice#',
					'#OrderItem.Quantity * (OrderItem.PriceDetail.OriginalPrice - OrderItem.Price)#',
					'#variables.avg_cost#',
					null,
					'#variables.sku_bucket_id#',
					'#OrderItem.PriceDetail.AdjustmentDetail#',
					'#OrderItem.PriceDetail.AdjustmentDetail#',
					'#OrderItem.Quantity#',
					'#variables.item_notes#',
					'#variables.off_from#',
					'#variables.sale_typ#',
					'#variables.term_sale_sav#',
					'#(OrderItem.Taxes[1].Rate*100)#',
					'#OrderItem.Taxes[1].Amount#',
					'#(OrderItem.Taxes[2].Rate*100)#',
					'#OrderItem.Taxes[2].Amount#',
					'#variables.man_reason_1#'
				)
			</cfquery>
		</cfloop>
		<cfset arguments.Order.OrderID = "#variables.store_receipt_num#-#arguments.Order.WarehouseID#" />
		<cfset arguments.Order.CustomerID = "#variables.customer_id#" />
		<cfset arguments.Order.OrderDateTime = "#DateFormat(now(), 'MM/DD/YYYY')# #TimeFormat(now(), 'HH:MM')#" />
		
		<cfreturn arguments.Order />
	</cffunction>
	
	<!--- =========== PRIVATE HELPER FUNCTIONS ============== --->
	
	<cffunction name="getNewIDFromGenerator" access="private" output="false" returntype="String">
		<cfargument name="GeneratorID" required="true">
		
		<cfset var rs = querynew('empty') />
		
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			BEGIN transaction;
			INSERT INTO #arguments.GeneratorID#_gen (notused) VALUES (1)
			ROLLBACK transaction;
			SELECT celerant.dbo.get_new_#arguments.GeneratorID# (1) as 'NewID'
		</cfquery>
		<cfreturn rs.NewID>
	</cffunction>
	
	<cffunction name="getSetupTenderID" access="private" output="false" returntype="String">
		<cfargument name="PaymentType" required="true">
		
		<cfset var rs = querynew('empty') />
		
		<cfset variables.PaymentType = UCASE(arguments.PaymentType) />
		<cfif variables.PaymentType eq "MASTERCARD">
			<cfset variables.PaymentType = "MASTERC" />
		</cfif>
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			Select setup_tender_id from tb_setup_tenders where glyph_name ='#variables.PaymentType#'
		</cfquery>
		<cfreturn rs.setup_tender_id>
	</cffunction>
	
	<cffunction name="getShipMethodID" access="private" output="false" returntype="String">
		<cfargument name="Carrier" required="true">
		<cfargument name="Method" required="true">
		
		<cfset var rs = querynew('empty') />
		
		<cfset variables.ship_carrier = 0>
		<cfset variables.carrier_method = 0>
		
		<cfset variables.carrier_method = UCASE(replace(arguments.Method,"_"," ","all")) />
		
		<cfset variables.carrier_method = UCASE(replace(variables.carrier_method,"1 DAY","1DAY","all")) />
		<cfset variables.carrier_method = UCASE(replace(variables.carrier_method,"2 DAY","2DAY","all")) />
		<cfset variables.carrier_method = UCASE(replace(variables.carrier_method,"3 DAY","3DAY","all")) />
		
		<cfif arguments.Carrier eq "UPS">
			<cfset variables.ship_carrier = 1>
		<cfelseif arguments.Carrier eq "FedEx">
			<cfset variables.ship_carrier = 2>
		<cfelseif arguments.Carrier eq "USPS">
			<cfset variables.ship_carrier = 3>
		</cfif>
		
		<cfset application.Slat.logManager.addLog(LogType="getShipMethodID",SupportingInfo="#variables.ship_carrier#~#variables.carrier_method#") />
		
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			Select ship_method_id from tb_ship_methods where ship_carrier = '#variables.ship_carrier#' and carrier_method = '#carrier_method#'
		</cfquery>
		
		<cfif rs.recordcount lt 1>
			<cfset returnMethod = 25 />
		<cfelse>
			<cfset returnMethod = rs.ship_method_id />
		</cfif>
		
		<cfreturn returnMethod>
	</cffunction>
	
	<cffunction name="getSkuLookup" access="private" output="false" returntype="String">
		<cfargument name="SkuID" required="true">
		
		<cfset rs = "" />
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			Select lookup from tb_sku_lookups where sku_id='#arguments.SkuID#' and Prime='Y'
		</cfquery>
		
		<cfreturn rs.lookup>
	</cffunction>
	
	<cffunction name="getSkuBucketID" access="private" output="false" returntype="String">
		<cfargument name="SkuID" required="true">
		<cfargument name="WarehouseID" required="true">
		
		<cfset rs = "" />
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			Select sku_bucket_id from tb_sku_buckets where sku_id='#arguments.SkuID#' and store_id = '#arguments.WarehouseID#'
		</cfquery>
		
		<cfreturn rs.sku_bucket_id>
	</cffunction>
	
	<cffunction name="getSkuAverageCost" access="private" output="false" returntype="String">
		<cfargument name="SkuID" required="true">
		<cfargument name="WarehouseID" required="true">
		
		<cfset rs = "" />
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			Select avg_cost from tb_sku_buckets where sku_id='#arguments.SkuID#' and store_id = '#arguments.WarehouseID#'
		</cfquery>
		
		<cfreturn rs.avg_cost>
	</cffunction>
	
	<cffunction name="getSkuOriginalPrice" access="private" output="false" returntype="String">
		<cfargument name="SkuID" required="true">
		<cfargument name="WarehouseID" required="true">
		
		<cfset rs = "" />
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			Select price from tb_sku_buckets where sku_id='#arguments.SkuID#' and store_id = '#arguments.WarehouseID#'
		</cfquery>
		
		<cfreturn rs.price>
	</cffunction>
	
	<cffunction name="getSmartCardID" access="private" output="false" returntype="String">
		<cfargument name="CardNumber" required="true">
		
		<cfset rs = "" />
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			Select smart_card_id from tb_smart_card where smart_card_num='#arguments.CardNumber#'
		</cfquery>
		
		<cfreturn rs.smart_card_id>
	</cffunction>
	
	<cffunction name="getSmartCardAvailable" access="private" output="false" returntype="String">
		<cfargument name="SmartCardID" required="true">
		
		<cfset rs = "" />
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			Select available from tb_smart_card where smart_card_id='#arguments.SmartCardID#'
		</cfquery>
		
		<cfreturn rs.available>
	</cffunction>
	
	<cffunction name="getNewCustomerID" access="private" output="false" returntype="String">
		<cfargument name="BillingAddress" type="struct" required="true">
		
		<cfset variables.customer_id = getNewIDFromGenerator("customer_id") />
		<cfset variables.customer_billingaddress_id = getNewIDFromGenerator("address_id") />
		<cfquery name="InsertCustomer" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			INSERT INTO tb_customers(
				customer_id,
				last_name,
				first_name)
			VALUES(
				#variables.customer_id#,
				'#UCASE(arguments.BillingAddress.LastName)#',
				'#UCASE(arguments.BillingAddress.FirstName)#'
				)
		</cfquery>
		
		<cfquery name="InsertAddress" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			INSERT INTO tb_address(
				address_id,
				address1,
				address2,
				city,
				state,
				locality,
				zip,
				country,
				phone1,
				email1)
			VALUES(
				#variables.customer_billingaddress_id#,
				'#UCASE(arguments.BillingAddress.StreetAddress)#',
				'#UCASE(arguments.BillingAddress.Street2Address)#',
				'#UCASE(arguments.BillingAddress.City)#',
				'#UCASE(arguments.BillingAddress.State)#',
				'#UCASE(arguments.BillingAddress.Locality)#',
				'#UCASE(arguments.BillingAddress.PostalCode)#',	
				'#UCASE(arguments.BillingAddress.Country)#',
				'#UCASE(REReplace(arguments.BillingAddress.PhoneNumber, "[^0-9]","","all"))#',
				'#UCASE(arguments.BillingAddress.EMail)#'
			)
		</cfquery>
		
		<cfquery name="InsertCustomerAddress" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			INSERT INTO tb_cust_address(
				customer_id,
				address_id,
				dlu)
			VALUES(
				#variables.customer_id#,
				#variables.customer_billingaddress_id#,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />
			)
		</cfquery>
		<cfquery name="InsertHouseAccount" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			INSERT INTO tb_house_account(
				customer_id)
			VALUES(
				#variables.customer_id#)
		</cfquery>
		
		<cfreturn variables.customer_id>
	</cffunction>
	
	<cffunction name="getCustomerShippingAddressID" access="private" output="false" returntype="String">
		<cfargument name="CustomerID" type="string" required="true">
		<cfargument name="ShippingAddress" type="struct" required="true" />
		
		<cfset return = 0>

		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				cust_ship_id
			FROM
				tb_cust_ship
			  INNER JOIN
			  	tb_address on tb_cust_ship.address_id = tb_address.address_id
			WHERE
				tb_cust_ship.customer_id = '#arguments.CustomerID#'
			  AND
			  	tb_cust_ship.first_name = '#UCASE(arguments.ShippingAddress.FirstName)#'
			  AND
			  	tb_cust_ship.last_name = '#UCASE(arguments.ShippingAddress.LastName)#'
			  AND
			  	tb_address.address1 = '#UCASE(arguments.ShippingAddress.StreetAddress)#'
			  AND
			  	tb_address.address2 = '#UCASE(arguments.ShippingAddress.Street2Address)#'
			  AND
			  	tb_address.city = '#UCASE(arguments.ShippingAddress.City)#'
			  AND
			  	tb_address.state = '#UCASE(arguments.ShippingAddress.State)#'
			  AND
			  	tb_address.zip = '#UCASE(arguments.ShippingAddress.PostalCode)#'
			  AND
			  	tb_address.country = '#UCASE(arguments.ShippingAddress.Country)#'
		</cfquery>
		
		<cfif rs.RecordCount gt 0>
			<cfset return = rs.cust_ship_id />
		<cfelse>
			<cfset variables.customer_shipping_address_id = getNewIDFromGenerator("address_id") />
			<cfset variables.cust_ship_id = getNewIDFromGenerator("cust_ship_id") />
			<cfquery name="InsertAddress" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
				INSERT INTO tb_address(
					address_id,
					address1,
					address2,
					city,
					state,
					locality,
					zip,
					country,
					phone1,
					email1)
				VALUES(
					'#variables.customer_shipping_address_id#',
					'#UCASE(arguments.ShippingAddress.StreetAddress)#',
					'#UCASE(arguments.ShippingAddress.Street2Address)#',
					'#UCASE(arguments.ShippingAddress.City)#',
					'#UCASE(arguments.ShippingAddress.State)#',
					'#UCASE(arguments.ShippingAddress.Locality)#',
					'#UCASE(arguments.ShippingAddress.PostalCode)#',	
					'#UCASE(arguments.ShippingAddress.Country)#',
					'#UCASE(REReplace(arguments.ShippingAddress.PhoneNumber, "[^0-9]","","all"))#',
					'#UCASE(arguments.ShippingAddress.EMail)#'
				)
			</cfquery>
			<cfquery name="InsertCustomerShipAddress" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
				INSERT INTO tb_cust_ship(
					customer_id,
					cust_ship_id,
					address_id,
					last_name,
					first_name,
					dlu)
				VALUES(
					'#arguments.CustomerID#',
					'#variables.cust_ship_id#',
					'#variables.customer_shipping_address_id#',
					'#UCASE(arguments.ShippingAddress.LastName)#',
					'#UCASE(arguments.ShippingAddress.FirstName)#',
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />
				)
			</cfquery>
			<cfset return = cust_ship_id />
		</cfif>
		
		<cfreturn return>
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
	
</cfcomponent>
