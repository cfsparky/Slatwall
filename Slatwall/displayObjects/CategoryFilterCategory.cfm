<cfoutput>
<cfset DisplaySettings = StructNew() />
<cfset DisplaySettings.ContentID = request.contentBean.getContentID() />
<cfset DisplaySettings.Title = request.contentBean.getMenuTitle() />
#application.Slat.dspManager.get(Display="ProductContentSubNav", DisplaySettings=DisplaySettings)#
</cfoutput>
<!---
<cfset categoryIT = request.contentBean.getKidsIterator()>
<cfset categoryIT.setNextN(categoryIT.getRecordCount())>

<cfif categoryIT.hasNext()>
	<cfoutput>
		<h3>#request.contentBean.getTitle()#</h3>
		<ul class="navSecondary">
		
			<cfloop condition="categoryIT.hasNext()"> 
				<cfset Category=categoryIT.next()>
				<cfoutput>
					<li><a href="#Category.getURLtitle()#/">#Category.getMenuTitle()#</a></li>
				</cfoutput>
			</cfloop>
		</ul>
	</cfoutput>
</cfif>
--->