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
		CONVERT(VARCHAR(max), max(brandtext.web_text)) as				'Brand',
		CONVERT(VARCHAR(max), max(tb_styles.picture_id)) as				'DefaultImageID',
		CONVERT(VARCHAR(max), max(tb_styles.web_long_desc)) as			'ProductDescription',
		CONVERT(VARCHAR(max),'') as										'ProductExtendedDescription',
		CONVERT(VARCHAR(max), max(tb_styles.date_entered)) as			'DateCreated',
		CONVERT(VARCHAR(max),'') as 									'DateAddedToWeb',
		CONVERT(VARCHAR(max), max(tb_styles.dlu)) as					'DateLastUpdated',
		min(tb_sku_buckets.first_rcvd) as		 						'DateFirstReceived',
		min(tb_sku_buckets.last_rcvd) as		 						'DateLastReceived',
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
		CASE max(tb_styles.of19)
			WHEN 'DROP SHIP' THEN CONVERT(VARCHAR(max), 1)
			ELSE CONVERT(VARCHAR(max), 0)
		END as															'DropShips',
		CASE max(tb_styles.of19)
			WHEN 'SPECIAL ORDER' THEN CONVERT(VARCHAR(max), 1)
			ELSE CONVERT(VARCHAR(max), 0)
		END as															'AllowBackorder',
		CONVERT(VARCHAR(max), 1) as										'AllowPreorder',
		CONVERT(VARCHAR(max), max(tb_styles.weight)) as					'Weight',
		CONVERT(VARCHAR(max), max(tb_styles.of2)) as					'ProductYear',
		CONVERT(VARCHAR(max), max(gendertext.web_text)) as				'Gender',
		CONVERT(VARCHAR(max), '') as									'SizeChart',
		'' as															'Ingredients',				
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
		sum(tb_sku_buckets.qoo) as 										'QOO'		
	FROM
		tb_styles
	  inner join
	  	tb_inet_names brandtext on tb_styles.brand = brandtext.orig_text
	  		and brandtext.field_name = 'BRAND'
	  left join
	  	tb_inet_names gendertext on tb_styles.of1 = gendertext.orig_text
	  		and gendertext.field_name = 'OF1'
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
	  or
	  	tb_styles.of19 = 'DROP SHIP'
	  or
	  	tb_styles.of10 = 'SPECIAL ORDER' 
	GROUP BY
		tb_styles.style_id
</cfquery>