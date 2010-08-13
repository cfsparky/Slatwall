<cfset application.Slat.cartManager.updateCartBillingAddress(
	CartBillingAddressID = Form.BillingAddressID,
	FirstName = Form.BillingFirstName,
	LastName = Form.BillingLastName,
	EMail = Form.BillingEmail,
	PhoneNumber = Form.BillingPhoneNumber,
	Country = Form.BillingCountry,
	StreetAddress = Form.BillingStreetAddress,
	Street2Address = Form.BillingStreet2Address,
	City = Form.BillingCity,
	State = Form.BillingState,
	Locality = Form.BillingLocality,
	PostalCode = Form.BillingPostalCode
) />