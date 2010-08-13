<cfcomponent output="false" name="queryOrganizer" hint="">

	<cfset variables.instance.Filter = structNew() />
	<cfset variables.instance.Range = structNew() />
	<cfset variables.instance.Order = structNew() />
	<cfset variables.instance.KeywordWeight = structNew() />
	<cfset variables.instance.Keyword = "" />

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getFilter" returntype="struct" access="public" output="false" hint="">
    	<cfreturn variables.instance.Filter />
    </cffunction>
    <cffunction name="setFilter" access="private" output="false" hint="">
    	<cfargument name="Filter" type="struct" required="true" />
    	<cfset variables.instance.Filter = trim(arguments.Filter) />
    </cffunction>
    
	<cffunction name="getRange" returntype="struct" access="public" output="false" hint="">
    	<cfreturn variables.instance.Range />
    </cffunction>
    <cffunction name="setRange" access="private" output="false" hint="">
    	<cfargument name="Range" type="struct" required="true" />
    	<cfset variables.instance.Range = trim(arguments.Range) />
    </cffunction>
	
	<cffunction name="getOrder" returntype="struct" access="public" output="false" hint="">
    	<cfreturn variables.instance.Order />
    </cffunction>
    <cffunction name="setOrder" access="private" output="false" hint="">
    	<cfargument name="Order" type="struct" required="true" />
    	<cfset variables.instance.Order = trim(arguments.Order) />
    </cffunction>
    
	<cffunction name="getKeywordWeight" returntype="struct" access="public" output="false" hint="">
    	<cfreturn variables.instance.KeywordWeight />
    </cffunction>
    <cffunction name="setKeywordWeight" access="private" output="false" hint="">
    	<cfargument name="KeywordWeight" type="struct" required="true" />
    	<cfset variables.instance.KeywordWeight = trim(arguments.KeywordWeight) />
    </cffunction>
    
    <cffunction name="getKeyword" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Keyword />
    </cffunction>
    <cffunction name="setKeyword" access="private" output="false" hint="">
    	<cfargument name="Keyword" type="string" required="true" />
    	<cfset variables.instance.Keyword = trim(arguments.Keyword) />
    </cffunction>
    
	<cffunction name="setFromCollection" access="public" output="false">
		<cfargument name="Collection" type="struct" required="true">
		
		<cfset var ValuePair = "" />
		<cfset var OrderDirection = "" />
		
		<cfloop collection="#arguments.Collection#" item="ValuePair">
			<cfif find("F_",ValuePair)>
				<cfset FilterProperty = Replace(ValuePair,"F_", "") />
				<cfif JavaCast("string", StructFind(arguments.Collection,ValuePair)) neq "">
					<cfset "variables.instance.Filter.#FilterProperty#" = JavaCast("string", StructFind(arguments.Collection,ValuePair)) />
				</cfif>
			</cfif>
			<cfif find("R_",ValuePair)>
				<cfset RangeProperty = Replace(ValuePair,"R_", "") />
				<cfif JavaCast("string", StructFind(arguments.Collection,ValuePair)) neq "">
					<cfset "variables.instance.Range.#RangeProperty#" = JavaCast("string", StructFind(arguments.Collection,ValuePair)) />
				</cfif>
			</cfif>
			<cfif find("O_",ValuePair)>
				<cfset OrderProperty = Replace(ValuePair,"O_", "") />
				<cfif JavaCast("string", StructFind(arguments.Collection,ValuePair)) neq "">
					<cfset OrderDirection = JavaCast("string", StructFind(arguments.Collection,ValuePair)) />
					<cfif OrderDirection eq "A">
						<cfset OrderDirection = "ASC" />
					<cfelseif OrderDirection eq "D">
						<cfset OrderDirection = "DESC" />
					</cfif>
					<cfset "variables.instance.Order.#OrderProperty#" = #OrderDirection# />
				</cfif>
			</cfif>
		</cfloop>
	
		<cfif isDefined("Collection.Keyword")>
			<cfset variables.instance.Keyword = Replace(Collection.Keyword," ","^","all") />
			<cfset variables.instance.Keyword = Replace(variables.instance.Keyword,"%20","^","all") />
			<cfset variables.instance.Keyword = Replace(variables.instance.Keyword,"+","^","all") />
		</cfif>
	</cffunction>
	
	<cffunction name="OrganizeQuery" access="public" returntype="Query" output="false">
		<cfargument name="Query" type="query" required="true" />
		
		<cfset var ThisFilter = "" />
		<cfset var FilterValue = "" />
		<cfset var ThisRange = "" />
		<cfset var RangeValue = "" />
		<cfset var ThisOrder = "" />
		<cfset var OrderValue = "" />
		<cfset var CurrentLoop = 0 />
		<cfset var OriginalQuery = queryNew('empty') />
		<cfset var FilteredQuery = queryNew('empty') />
		<cfset var FinishedQuery = queryNew('empty') />
		
		<cfquery dbtype="query" name="FilteredQuery">
			SELECT
				*,
				.01 as QOKScore
			FROM
				arguments.Query
			<cfif ListLen(structKeyList(variables.instance.Filter)) or ListLen(structKeyList(variables.instance.Range))>
				WHERE
				<cfloop collection="#variables.instance.Filter#" item="ThisFilter">
					<cfset FilterValue = variables.instance.Filter[#ThisFilter#] />
					(
					<cfset CurrentLoop = 0 />
			  		<cfloop list="#FilterValue#" delimiters="^" index="I">
			  			<cfset CurrentLoop = CurrentLoop+1 />
			  			#UCASE(ThisFilter)# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(I)#"><cfif ListLen(FilterValue,"^") gt CurrentLoop> or </cfif>
					</cfloop>
					) 
				</cfloop>
				<cfif ListLen(structKeyList(variables.instance.Filter)) and ListLen(structKeyList(variables.instance.Range))> AND </cfif>
				<cfloop collection="#variables.instance.Range#" item="ThisRange">
					<cfset RangeValue = variables.instance.Range[#ThisRange#] />
					<cfset lower= 1>
					<cfloop list="#RangeValue#" delimiters="^" index="i">
						<cfif lower>
							<cfset lower=0>
							#ThisRange# > <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#i#"> AND			
						<cfelse>
							#ThisRange# < <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#i#">	
						</cfif>
				  	</cfloop>
				</cfloop>
			</cfif>
			<cfif ListLen(structKeyList(variables.instance.Order))>
				ORDER BY
				<cfset CurrentLoop = 0 />
				<cfloop collection="#variables.instance.Order#" item="ThisOrder">
					<cfset CurrentLoop = CurrentLoop+1 />
					<cfset OrderValue = variables.instance.Order[#ThisOrder#] />
					
					#ThisOrder# #OrderValue# <cfif ListLen(structKeyList(variables.instance.Order)) gt CurrentLoop>, </cfif>
				</cfloop>
			</cfif>
		</cfquery>
		
		<cfif len(variables.instance.Keyword) gt 1 and ProductDataAfterFilter.recordcount gt 1>
			<cfloop query="ProductDataAfterFilter">
				<cfset TotalScore = 0 />
				<cfset CountProductCode = 0/>
				<cfset CountBrand = 0/>
				<cfset CountProductName = 0/>
				<cfset CountProductYear = 0/>
				<cfset CountGender = 0/>
				<cfset CountProductDescription = 0 />
				
				<cfset TempGender = REReplace(Replace(UCASE(ProductDataAfterFilter.Gender),"S",""), "[^0-9a-zA-Z_]", "", "ALL") />

				<cfloop list="#variables.instance.Keyword#" index="I">
					<cfif I eq ProductDataAfterFilter.ProductCode>
						<cfset CountProductCode = 1 />
					</cfif>
					<cfif I eq ProductDataAfterFilter.ProductYear>
						<cfset CountProductYear = 1 />
					</cfif>
					<cfset TempGenderKeyword = REReplace(Replace(UCASE(I),"S",""), "[^0-9a-zA-Z_]", "", "ALL") />
					<cfif TempGenderKeyword eq TempGender>
						<cfset CountGender = 1 />
					</cfif>
					
					<cfset FindBrand = FindNoCase(I,ProductDataAfterFilter.Brand,0) />
					<cfset FindProductName = FindNoCase(I,ProductDataAfterFilter.ProductName,0) />
					<cfset FindProductDescription = FindNoCase(I,ProductDataAfterFilter.ProductDescription,0) />
					<cfloop condition="#FindBrand# gt 0 or #FindProductName# gt 0 or #FindProductDescription# gt 0">
						<cfif FindBrand gt 0>
							<cfset CountBrand = CountBrand+1 />
							<cfset FindBrand = FindNoCase(I,ProductDataAfterFilter.Brand,#FindBrand#+1) />
						</cfif>
						<cfif FindProductName gt 0>
							<cfset FindProductName = FindNoCase(I,ProductDataAfterFilter.ProductName,#FindProductName#+1) />
							<cfset CountProductName = CountProductName+1 />
						</cfif>
						<cfif FindProductDescription gt 0>
							<cfset CountProductDescription = CountProductDescription+1 />
							<cfset FindProductDescription = FindNoCase(I,ProductDataAfterFilter.ProductDescription,#FindProductDescription#+1) />
						</cfif>
					</cfloop>
					
				</cfloop>

				<cfset TotalScore = TotalScore + (CountProductCode * .9) + (CountBrand * .5) + (CountProductName * .2) + (CountProductYear * .4) + (CountGender * .4) + (CountProductDescription * .05) />
				<cfset QuerySetCell(ProductDataAfterFilter, 'SearchScore', '#TotalScore#', #ProductDataAfterFilter.currentRow#) />
				
			</cfloop>
			
			<cfquery dbtype="query" name="ProductDataFilteredAndScored">
				Select
					*
				From
					ProductDataAfterFilter
				Where
					ProductDataAfterFilter.SearchScore > 0.01
				Order By
					ProductDataAfterFilter.SearchScore Desc
			</cfquery>
			
			<cfset FinishedProductData = ProductDataFilteredAndScored />
		<cfelse>
			<cfset FinishedQuery = FilteredQuery />
		</cfif>
		
		<cfreturn FinishedQuery />
	</cffunction>
</cfcomponent>
