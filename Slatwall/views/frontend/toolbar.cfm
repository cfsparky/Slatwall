<cfoutput>

<div id="SlatwallToolbar">
	<ul class="MainMenu">
		<li class="MenuTop"></li>
		<li><a href="#buildURL(action='main.default')#">Dashboard</a></li>
		<li><a href="">Custom Reports</a>
			<div class="MenuSubOne">
				<ul>
					<li><a href="#buildURL(action='creport.atsbikes')#">Available Bikes</a></li>
					<li><a href="#buildURL(action='creport.bikeorders')#">Bike Build</a></li>
					<li><a href="#buildURL(action='creport.customerdiscounts')#">Customer Discounts</a></li>
					<li><a href="#buildURL(action='creport.invsuggestions')#">Inventory Suggestions</a></li>
					<li><a href="#buildURL(action='creport.lastreceived')#">Last Received</a></li>
					<li><a href="#buildURL(action='creport.lastreceivedonspecialorder')#">Last Received On Open Order</a></li>
					<li><a href="#buildURL(action='creport.atwprimary')#">Web Add Primary</a></li>
					<li><a href="#buildURL(action='creport.atwfuture')#">Web Add Future</a></li>
					<li><a href="#buildURL(action='creport.atwsecondary')#">Web Add Secondary</a></li>
					<li><a href="#buildURL(action='creport.noserialnumber')#">Closed Without Serial Number</a></li>
					<li><a href="#buildURL(action='creport.openpo')#">Open POs</a></li>
					<li><a href="#buildURL(action='creport.ordersshipping')#">Open Orders Shipping</a></li>
					<li><a href="#buildURL(action='creport.popastcancel')#">PO Past Cancel</a></li>
					<li><a href="#buildURL(action='creport.preordersales')#">Pre Order Sales</a></li>
					<li><a href="#buildURL(action='creport.qbreconcile')#">OB Reconcile</a></li>
				</ul>
			</div>
		</li>
		<li>
			<a href="#buildURL(action='product.list')#">Products</a>
			<div class="MenuSubOne">
				<ul>
					<li><a href="#buildURL(action='product.list')#">Product Listing</a></li>
					<li><a href="#buildURL(action='product.create')#">Create New Product</a></li>
					<li><a href="#buildURL(action='product.list', queryString='O_LastReceived=A')#">Order: Last Received</a></li>
				</ul>
			</div>
		</li>
		<li>
			<a href="#buildURL(action='order.list', queryString='F_IsOpen=1')#">Orders</a>
			<div class="MenuSubOne">
				<ul>
					<li><a href="#buildURL(action='order.list', queryString='F_IsOpen=1')#">Open Orders</a></li>
					<li><a href="#buildURL(action='order.list')#">All Orders</a></li>
					<li><a href="#buildURL(action='order.create')#">Create New Order</a></li>
				</ul>
			</div>
		</li>
		<li>
			<a href="#buildURL(action='customer.list')#">Customers</a>
			<div class="MenuSubOne">
				<ul>
					<li><a href="#buildURL(action='customer.list')#">Customer Finder</a></li>
					<li><a href="#buildURL(action='customer.create')#">Create New Customer</a></li>
				</ul>
			</div>
		</li>
		<li><a href="#buildURL(action='brand.list')#">Brands</a></li>
		<li><a href="#buildURL(action='po.list')#">Purchase Orders</a></li>
		<li><a href="#buildURL(action='vendor.list')#">Vendors</a></li>
		<li><a href="#buildURL(action='contact.list')#">Contacts</a></li>
		<li class="MenuBottom"></li>
	</ul>
	<ul class="MainToolbar">
		<li class="LogoSearch">
			<img src="#application.SlatSettings.getSetting('PluginPath')#/images/toolbar/toolbar_logo.png" />
			<input type="text" />
		</li>
		<li><a href="http://#cgi.http_host#/">Website</a></li>
		<li><a href="#getExternalSiteLink('http://remote.nytro.com/exchange')#">Company E-Mail</a></li>
		<cfif isDefined('url.ProductID')>
			<li><a href="#buildURL(action='product.detail', querystring='ProductID=#url.ProductID#')#">Product Detail</a></li>
		</cfif>
		
		<!---
		<li><a href="">Create Campain Link</a></li>
		<li><a href="">Create New Order</a></li>
		<li><a href="">Company IM</a></li>
		<li><a href="">Alerts</a></li>
		--->
	</ul>	
</div>
</cfoutput>