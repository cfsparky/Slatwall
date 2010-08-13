<cfcomponent name="skuBean" output="false" hint="">
	
	<cfset variables.instance = structNew() />
	<cfset variables.instance.SkuID=""/>
	<cfset variables.instance.ProductID=""/>
	<cfset variables.instance.ImageID=""/>
	<cfset variables.instance.LivePrice= 0 />
	<cfset variables.instance.ListPrice= 0 />
	<cfset variables.instance.OriginalPrice= 0 />
	<cfset variables.instance.MiscPrice= 0 />
	<cfset variables.instance.SkuAttributes=arraynew(1) />
	<cfset variables.instance.QOH=0 />
	<cfset variables.instance.QC=0 />
	<cfset variables.instance.QOO=0 />
	<cfset variables.instance.QIA=0 />
	<cfset variables.instance.QEA=0 />
	<cfset variables.instance.NextOrderID="" />
	<cfset variables.instance.NextArrivalDate = "" />
	<cfset variables.instance.DaysToOrder = 0 />
	<cfset variables.instance.AdditionalDaysToShip = 0 />
	<cfset variables.instance.isTaxable = 0 />
	<cfset variables.instance.isDiscountable = 1 />
	
	<cffunction name="init" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSkuID" returntype="string" access="public" output="false">
		<cfreturn variables.instance.SkuID />
	</cffunction>
	<cffunction name="setSkuID" access="public" output="false">
		<cfargument name="SkuID" type="string" required="true" />
		<cfset variables.instance.SkuID = trim(arguments.SkuID) />
	</cffunction>

	<cffunction name="getProductID" returntype="string" access="public" output="false">
		<cfreturn variables.instance.ProductID />
	</cffunction>
	<cffunction name="setProductID" access="public" output="false">
		<cfargument name="ProductID" type="string" required="true" />
		<cfset variables.instance.ProductID = trim(arguments.ProductID) />
	</cffunction>
	
	<cffunction name="getImageID" returntype="string" access="public" output="false">
		<cfreturn variables.instance.ImageID />
	</cffunction>
	<cffunction name="setImageID" access="public" output="false">
		<cfargument name="ImageID" type="string" required="true" />
		<cfset variables.instance.ImageID = trim(arguments.ImageID) />
	</cffunction>
	
	<cffunction name="getLivePrice" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.LivePrice />
	</cffunction>
	<cffunction name="setLivePrice" access="public" output="false">
		<cfargument name="LivePrice" type="numeric" required="true" />
		<cfset variables.instance.LivePrice = arguments.LivePrice />
	</cffunction>
	
	<cffunction name="getListPrice" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.ListPrice />
	</cffunction>
	<cffunction name="setListPrice" access="public" output="false">
		<cfargument name="ListPrice" type="numeric" required="true" />
		<cfset variables.instance.ListPrice = arguments.ListPrice />
	</cffunction>
	
	<cffunction name="getOriginalPrice" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.OriginalPrice />
	</cffunction>
	<cffunction name="setOriginalPrice" access="public" output="false">
		<cfargument name="OriginalPrice" type="numeric" required="true" />
		<cfset variables.instance.OriginalPrice = arguments.OriginalPrice />
	</cffunction>
	
	<cffunction name="getMiscPrice" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.MiscPrice />
	</cffunction>
	<cffunction name="setMiscPrice" access="public" output="false">
		<cfargument name="MiscPrice" type="numeric" required="true" />
		<cfset variables.instance.MiscPrice = arguments.MiscPrice />
	</cffunction>
	
	<cffunction name="getAttributes" returntype="array" access="public" output="false">
		<cfreturn variables.instance.SkuAttributes />
	</cffunction>
	<cffunction name="setAttributes" access="public" output="false">
		<cfargument name="Attributes" type="array" required="true" />
		<cfset variables.instance.SkuAttributes = arguments.Attributes />
	</cffunction>

	<cffunction name="getQOH" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.QOH />
	</cffunction>
	<cffunction name="setQOH" access="public" output="false">
		<cfargument name="QOH" type="numeric" required="true" />
		<cfset variables.instance.QOH = trim(arguments.QOH) />
	</cffunction>
	
	<cffunction name="getQC" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.QC />
	</cffunction>
	<cffunction name="setQC" access="public" output="false">
		<cfargument name="QC" type="numeric" required="true" />
		<cfset variables.instance.QC = trim(arguments.QC) />
	</cffunction>
	
	<cffunction name="getQOO" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.QOO />
	</cffunction>
	<cffunction name="setQOO" access="public" output="false">
		<cfargument name="QOO" type="numeric" required="true" />
		<cfset variables.instance.QOO = trim(arguments.QOO) />
	</cffunction>
	
	<cffunction name="getQIA" returntype="numeric" access="public" output="false">
		<cfset return = getQOH() - getQC() />
		<cfreturn return />
	</cffunction>
	
	<cffunction name="getQEA" returntype="numeric" access="public" output="false">
		<cfset return = getQIA() + getQOO() />
		<cfreturn return />
	</cffunction>
	
	<cffunction name="getNextOrderID" returntype="string" access="public" output="false">
		<cfreturn variables.instance.NextOrderID />
	</cffunction>
	<cffunction name="setNextOrderID" access="public" output="false">
		<cfargument name="NextOrderID" type="string" required="true" />
		<cfset variables.instance.NextOrderID = trim(arguments.NextOrderID) />
	</cffunction>
	
	<cffunction name="getNextArrivalDate" returntype="string" access="public" output="false">
		<cfreturn variables.instance.NextArrivalDate />
	</cffunction>
	<cffunction name="setNextArrivalDate" access="public" output="false">
		<cfargument name="NextArrivalDate" type="string" required="true" />
		<cfset variables.instance.NextArrivalDate = trim(arguments.NextArrivalDate) />
	</cffunction>
	
	<cffunction name="getDaysToOrder" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.DaysToOrder />
	</cffunction>
	<cffunction name="setDaysToOrder" access="public" output="false">
		<cfargument name="DaysToOrder" type="numeric" required="true" />
		<cfset variables.instance.DaysToOrder = arguments.DaysToOrder />
	</cffunction>
	
	<cffunction name="getAdditionalDaysToShip" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.AdditionalDaysToShip />
	</cffunction>
	<cffunction name="setAdditionalDaysToShip" access="public" output="false">
		<cfargument name="AdditionalDaysToShip" type="numeric" required="true" />
		<cfset variables.instance.AdditionalDaysToShip = arguments.AdditionalDaysToShip />
	</cffunction>
	
	<cffunction name="getisTaxable" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.isTaxable />
	</cffunction>
	<cffunction name="setisTaxable" access="public" output="false">
		<cfargument name="isTaxable" type="numeric" required="true" />
		<cfset variables.instance.isTaxable = arguments.isTaxable />
	</cffunction>
	
	<cffunction name="getisDiscountable" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.isDiscountable />
	</cffunction>
	<cffunction name="setisDiscountable" access="public" output="false">
		<cfargument name="isDiscountable" type="numeric" required="true" />
		<cfset variables.instance.isDiscountable = arguments.isDiscountable />
	</cffunction>
	
	<cffunction name="set" returnType="void" output="false" access="public">
		<cfargument name="record" type="any" required="true">
		
		<cfset columnexists=1 />
		<cfset currentcolumn=1 />
		<cfset AttributeName="" />
		<cfset AttributeValue="" />
		<cfset RecordAttributes=arrayNew(1) />
		

		<cfif isquery(arguments.record)>
		
			<!--- Turn Attribute Columns Into Array --->
			<cfloop condition="columnexists eq 1">
				<cfif ListFindNoCase(record.ColumnList, "Attr#currentcolumn#Name")>
					<cfset AttributePair = structnew() />
					<cfset AttributePair.Name = evaluate("arguments.record.Attr#currentcolumn#Name") />
					<cfset AttributePair.Value = evaluate("arguments.record.Attr#currentcolumn#Value") />
					<cfset RecordAttributes[#currentcolumn#] = #AttributePair# />
					<cfset currentcolumn = currentcolumn + 1>
				<cfelse>
					<cfset columnexists = 0>
				</cfif>
			</cfloop>
			
			<cfset setAttributes(RecordAttributes) />
			
			<cfset setSkuID(arguments.record.SkuID) />
			<cfset setImageID(arguments.record.ImageID) />
			<cfset setLivePrice(arguments.record.LivePrice) />
			<cfset setListPrice(arguments.record.ListPrice) />
			<cfset setOriginalPrice(arguments.record.OriginalPrice) />
			<cfset setMiscPrice(arguments.record.MiscPrice)/>
			<cfset setAttributes(RecordAttributes) />
			<cfset setQOH(arguments.record.QOH) />
			<cfset setQC(arguments.record.QC) />
			<cfset setQOO(arguments.record.QOO)/>
			<cfset setNextOrderID(arguments.record.NextOrderID)/>
			<cfset setNextArrivalDate(arguments.record.NextArrivalDate)/>
			<cfset setDaysToOrder(arguments.record.DaysToOrder)/>
			<cfset setAdditionalDaysToShip(arguments.record.AdditionalDaysToShip)/>
			<cfset setisTaxable(arguments.record.isTaxable)/>
			<cfset setisDiscountable(arguments.record.isDiscountable)/>
		<cfelseif isStruct(arguments.record)>
			<cfloop collection="#arguments.record#" item="prop">

				<!--- Turn Attribute Columns Into Array --->
				<cfloop condition="columnexists eq 1">
					<cfif StructKeyExists(arguments.record,"Attr#currentcolumn#Name")>
						<cfset AttributePair = structnew() />
						<cfset AttributePair.Name = evaluate("arguments.record.Attr#currentcolumn#Name") />
						<cfset AttributePair.Value = evaluate("arguments.record.Attr#currentcolumn#Value") />
						<cfset RecordAttributes[#currentcolumn#] = #AttributePair# />
						<cfset currentcolumn = currentcolumn + 1>
					<cfelse>
						<cfset columnexists = 0>
					</cfif>
				</cfloop>
				
				<cfset setAttributes(RecordAttributes) />
				
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.record[prop])") />
				</cfif>
				
			</cfloop>
		</cfif>

	</cffunction>

	<cffunction name="getAttributesString" returntype="string" access="public" output="false">
		<cfargument name="ValueSeperator" default=": " />
		<cfargument name="AttributeSeperator" default=", " />
		<cfargument name="NoHTML" default=0 />
		<cfset AttributesString = "" />
		<cfset isFirst = 1 />
		
		<cfloop array="#variables.instance.SkuAttributes#" index="I">
			<cfif I.Value neq "">
				<cfif not isFirst>
					<cfset AttributesString = "#AttributesString##arguments.AttributeSeperator#" />
				</cfif>
				<cfif NoHTML>
					<cfset AttributesString = '#AttributesString##I.Name##arguments.ValueSeperator##I.Value#' />
				<cfelse>
					<cfset AttributesString = '#AttributesString#<span class="attributename">#I.Name#</span>#arguments.ValueSeperator#<span class="attributevalue">#I.Value#</span>' />
				</cfif>
				<cfset isFirst = 0 />
			</cfif>
		</cfloop>
		
		<cfreturn AttributesString />
	</cffunction>

	<cffunction name="getEstimatedShipDate" access="public" output="false" retruntype="string">
		<cfset DaysToAdd = 0>
		
		<cfif getQIA() gt 0>
			<cfset ShipDate = DateFormat(now(),"MM/DD/YYYY") />
		<cfelseif getQEA() gt 0>
			<cfset ShipDate = DateFormat(getNextArrivalDate(), "MM/DD/YYYY") />
			<cfif ShipDate lt DateFormat(now(), "MM/DD/YYYY")>
				<cfset ShipDate =  DateFormat(now(), "MM/DD/YYYY") />
			</cfif>
			<cfset DaysToAdd = 3>
		<cfelse>
			<cfset ShipDate = DateFormat(now()+getDaysToOrder(),"MM/DD/YYYY") />
		</cfif>
		
		<cfset DaysToAdd = DaysToAdd + getAdditionalDaysToShip()>
		<cfset DaysAdded = 0 />
		
		<cfif ShipDate eq DateFormat(now(),"MM/DD/YYYY") and TimeFormat(now(),"HH:MM") gt "13:00" and DaysToAdd eq 0>
			<cfset ShipDate = DateFormat(ShipDate+1,"MM/DD/YYYY") />
		<cfelse>
			<cfset ShipDate = DateFormat(ShipDate,"MM/DD/YYYY") />
		</cfif>
		
		<cfloop condition="#DaysToAdd# gt #DaysAdded# or #application.slat.ShippingManager.isShippingDate(ShipDate)# neq 1">
			<cfset ShipDate = DateFormat(ShipDate+1,"MM/DD/YYYY") />
			<cfif application.slat.ShippingManager.isShippingDate(ShipDate)>
				<cfset DaysAdded = DaysAdded + 1>
			</cfif>
		</cfloop>
		
		<cfreturn ShipDate />
	</cffunction>
	
	<cffunction name="getEstimatedShipDateTest" access="public" output="false" retruntype="string">
		<cfset DaysToAdd = 0>
		
		<cfif getQIA() gt 0>
			<cfdump var="#getQIA()#" />
			<cfabort />
			<cfset ShipDate = DateFormat(now(),"MM/DD/YYYY") />
		<cfelseif getQEA() gt 0>
			<cfdump var="#getQEA()#" />
			<cfdump var="#getNextArrivalDate()#" />
			<cfabort />
			<cfset ShipDate = DateFormat(getNextArrivalDate(), "MM/DD/YYYY") />
			<cfif ShipDate lt DateFormat(now(), "MM/DD/YYYY")>
				<cfset ShipDate =  DateFormat(now(), "MM/DD/YYYY") />
			</cfif>
			<cfset DaysToAdd = 3>
		<cfelse>
			<cfset ShipDate = DateFormat(now()+getDaysToOrder(),"MM/DD/YYYY") />
		</cfif>
		
		<cfset DaysToAdd = DaysToAdd + getAdditionalDaysToShip()>
		<cfset DaysAdded = 0 />
		
		<cfif ShipDate eq DateFormat(now(),"MM/DD/YYYY") and TimeFormat(now(),"HH:MM") gt "13:00" and DaysToAdd eq 0>
			<cfset ShipDate = DateFormat(ShipDate+1,"MM/DD/YYYY") />
		<cfelse>
			<cfset ShipDate = DateFormat(ShipDate,"MM/DD/YYYY") />
		</cfif>
		
		<cfloop condition="#DaysToAdd# gt #DaysAdded# or #application.slat.ShippingManager.isShippingDate(ShipDate)# neq 1">
			<cfset ShipDate = DateFormat(ShipDate+1,"MM/DD/YYYY") />
			<cfif application.slat.ShippingManager.isShippingDate(ShipDate)>
				<cfset DaysAdded = DaysAdded + 1>
			</cfif>
		</cfloop>
		
		<cfreturn ShipDate />
	</cffunction>
	
	<cffunction name="getSkuImage" returnType="string" output="false" access="public">
		<cfargument name="Size" default="L" />
		
		<cfset ThisImageSource = "" />
		
		<cfif arrayLen(variables.instance.SkuAttributes) gt 1>
			<cfset ColorCode = "" />
			<cfset ColorCode = Replace(variables.instance.SkuAttributes[2].Value, "/", "", "all") />
			<cfif fileExists(UCASE(ExpandPath("/prodimages/#getImageID()#-#ColorCode#-#arguments.Size#.jpg"))) and ThisImageSource eq "">
				<cfset ThisImageSource = "/prodimages/#getImageID()#-#ColorCode#-#arguments.Size#.jpg" />
			</cfif>
		</cfif>
		<cfif ThisImageSource eq "" and fileExists(UCASE(ExpandPath("/prodimages/#getImageID()#-DEFAULT-#arguments.Size#.jpg")))>
			<cfset ThisImageSource = "/prodimages/#getImageID()#-DEFAULT-#arguments.Size#.jpg" />
		</cfif>
		<cfif ThisImageSource eq "">
			<cfset ThisImageSource = "/prodimages/NoProductImage-#arguments.Size#.gif" />
		</cfif>
		<cfreturn ThisImageSource />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
	
</cfcomponent>
