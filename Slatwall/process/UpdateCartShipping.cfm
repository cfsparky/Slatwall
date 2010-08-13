<cfset application.Slat.cartManager.updateCartShippingAddress(
	CartShippingAddressID = Form.ShippingAddressID,
	FirstName = Form.ShippingFirstName, 
	LastName = Form.ShippingLastName, 
	EMail = Form.ShippingEmail, 
	PhoneNumber = Form.ShippingPhoneNumber,
	Country = Form.ShippingCountry,
	Locality = Form.ShippingLocality,
	State = Form.ShippingState,
	City = Form.ShippingCity, State = Form.ShippingState,
	PostalCode = Form.ShippingPostalCode,
	StreetAddress = Form.ShippingStreetAddress,
	Street2Address = Form.ShippingStreet2Address
) />