<plugin>
<name>Slatwall Plugin</name>
<package>Slat</package>
<version>1.2</version>
<provider>Greg Moser</provider>
<providerURL>http://www.gregmoser.com</providerURL>
<category>Application</category>
<settings></settings>
<eventHandlers>
	<eventHandler event="onApplicationLoad" component="fw1Adapter" persist="false"/>	
</eventHandlers>
<displayobjects location="global">
		<displayobject name="Account Sign In"					displaymethod="AccountSignIn"				displayobjectfile="displayObjects/AccountSignIn.cfm" />
		<displayobject name="Cart Order Summary"				displaymethod="CartOrderSummary"			displayobjectfile="displayObjects/CartOrderSummary.cfm" />
		<displayobject name="Category Filter Brand"				displaymethod="CategoryFilterBrand"			displayobjectfile="displayObjects/CategoryFilterBrand.cfm" />
		<displayobject name="Category Filter Category"			displaymethod="CategoryFilterCategory"		displayobjectfile="displayObjects/CategoryFilterCategory.cfm" />
		<displayobject name="Category Filter Gender"			displaymethod="CategoryFilterGender"		displayobjectfile="displayObjects/CategoryFilterGender.cfm" />
		<displayobject name="Category Filter Material"			displaymethod="CategoryFilterMaterial"		displayobjectfile="displayObjects/CategoryFilterMaterial.cfm" />
		<displayobject name="Category Filter Year"				displaymethod="CategoryFilterYear"			displayobjectfile="displayObjects/CategoryFilterYear.cfm" />
		<displayobject name="Category Products"					displaymethod="CategoryProducts"			displayobjectfile="displayObjects/CategoryProducts.cfm" />
		<displayobject name="Category Sort Navigation"			displaymethod="CategorySortNavigation"		displayobjectfile="displayObjects/CategorySortNavigation.cfm" />
		<displayobject name="Category Sub Navigation"			displaymethod="CategorySubNavigation"		displayobjectfile="displayObjects/CategorySubNavigation.cfm" />
		<displayobject name="Checkout Sign In"					displaymethod="CheckoutSignIn"				displayobjectfile="displayObjects/CheckoutSignIn.cfm" />
		<displayobject name="Order Complete" 					displaymethod="OrderComplete"				displayobjectfile="displayObjects/OrderComplete.cfm" />
		<displayobject name="Shopping Cart" 					displaymethod="ShoppingCart"				displayobjectfile="displayObjects/ShoppingCart.cfm" />
		<displayobject name="Three Step Checkout - Confirm"		displaymethod="ThreeStepCheckoutConfirm"	displayobjectfile="displayObjects/ThreeStepCheckout_Confirm.cfm" />
		<displayobject name="Three Step Checkout - Payment"		displaymethod="ThreeStepCheckoutPayment"	displayobjectfile="displayObjects/ThreeStepCheckout_Payment.cfm" />
		<displayobject name="Three Step Checkout - Shipping"	displaymethod="ThreeStepCheckoutShipping"	displayobjectfile="displayObjects/ThreeStepCheckout_Shipping.cfm" />
</displayobjects>
</plugin>