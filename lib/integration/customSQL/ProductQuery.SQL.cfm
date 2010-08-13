<cfoutput>
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
			min(tb_sku_buckets.last_rcvd) as		 						'DateLastReceived',
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
			CASE max(tb_styles.of19)
				WHEN 'DROP SHIP' THEN CONVERT(VARCHAR(max), 1)
				ELSE CONVERT(VARCHAR(max), 0)
			END as															'DropShips',
			CASE max(tb_styles.of19)
				WHEN 'SPECIAL ORDER' THEN CONVERT(VARCHAR(max), 1)
				ELSE CONVERT(VARCHAR(max), 0)
			END as															'AllowBackorder',
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
			sum(tb_sku_buckets.qoo) as 										'QOO',
			'Geometry' as													'Attr1Name',
			CONVERT(VARCHAR(max), max(tb_web_style_info.geometry)) as		'Attr1Value',
			'Wheel Info' as													'Attr2Name',
			CONVERT(VARCHAR(max), max(tb_web_style_info.misc_1)) as			'Attr2Value',
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
			CONVERT(VARCHAR(max), max(tb_web_compare.brake_levers)) as		'Attr23Value',
			'Nutrition Info' as												'Attr24Name',
			CONVERT(VARCHAR(max), max(tb_web_style_info.misc_2)) as			'Attr24Value'
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
</cfoutput>