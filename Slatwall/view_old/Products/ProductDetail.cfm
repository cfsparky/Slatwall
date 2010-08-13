<cfoutput>
	<ul class="metadata">
		<li><strong>Brand:</strong>#Request.Slat.Product.getBrand()#</li>
		<li><strong>Name:</strong>#Request.Slat.Product.getProductName()#</li>
		<li><strong>Price:</strong>#Request.Slat.Product.getLivePrice()#</li>
	</ul>
	<div id="page_tabView">
		<div id="tabView0" class="page_aTab">
			<br />
			<br />
			<cfset DisplaySettings = structNew() />
			<cfset DisplaySettings.ProductID = Request.Slat.Product.getProductID() />
			#application.slat.dspManager.get(Display="ProductNewContentAssignment",DisplaySettings=DisplaySettings)#
			#application.slat.dspManager.get(Display="ProductExistingAssignments",DisplaySettings=DisplaySettings)#
		</div>
		<div id="tabView1" class="page_aTab">
			<br />
			<br />
			<cfinclude template="#application.slatsettings.getSetting('PluginPath')#/view/Products/Specifications.cfm" />
		</div>
		<div id="tabView2" class="page_aTab">
			<br />
			<br />
			<cfinclude template="#application.slatsettings.getSetting('PluginPath')#/view/Products/Misc.cfm" />
		</div>
		<div id="tabView3" class="page_aTab">
			AlternatImages
		</div>
		<div id="tabView4" class="page_aTab">
			<br />
			<br />
			<table class="stripe">
				<tbody>
					<tr>
						<th>Sku Description</th>
						<th>QOH</th>
						<th>QOO</th>
						<th>QC</th>
						<th>QIA</th>
						<th>QEA</th>
						<th>Next Arrival Date</th>
						<th>Live Price</th>
					</tr>
				</tbody>
				<cfset Request.Slat.Product.ProductSkus = Request.Slat.Product.getSkusIterator() />
				<cfloop condition="Request.Slat.Product.ProductSkus.hasNext()">
					<cfset Sku = Request.Slat.Product.ProductSkus.next() />
					<tr>
						<td>#Sku.getAttributesString()#</td>
						<td>#Sku.getQOH()#</td>
						<td>#Sku.getQOO()#</td>
						<td>#Sku.getQC()#</td>
						<td>#Sku.getQIA()#</td>
						<td>#Sku.getQEA()#</td>
						<td>#Sku.getNextArrivalDate()#</td>
						<td>#Sku.getLivePrice()#</td>
					</tr>
				</cfloop>
				
			</table>
		</div>
	</div>
	<script type="text/javascript">
		initTabs(Array('Display On', 'Specifications', 'Misc', 'Alternate Images', 'Inventory'),0,0,0);
	</script>
	
</cfoutput>