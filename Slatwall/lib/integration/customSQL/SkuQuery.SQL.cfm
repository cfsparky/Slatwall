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
		max(tb_styles.days_to_restock) as			'DaysToOrder',
		0 as									'AdditionalDaysToShip',
		1 as									'isTaxable',
		CASE max(tb_styles.of17)
			WHEN 'NEVER' THEN 0
			ELSE 1
		END as									'isDiscountable'
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