<cfquery name="ApprovedReviews" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Select
		Count(*) as 'ApprovedReviews'
	from
		tcontentcomments
	where
		isApproved=1
</cfquery>
<cfquery name="NotApprovedReviews" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Select
		Count(*) as 'NotApprovedReviews'
	from
		tcontentcomments
	where
		isApproved=0
</cfquery>
<cfquery name="TotalRatings" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Select
		Count(*) as 'TotalRatings'
	from
		tcontentratings
</cfquery>
<cfoutput>
	<dl>
		<dt>Total Reviews</dt>
		<dd>#ApprovedReviews.ApprovedReviews + NotApprovedReviews.NotApprovedReviews#</dd>
	</dl>
	<dl>
		<dt>Approved Reviews</dt>
		<dd>#ApprovedReviews.ApprovedReviews#</dd>
	</dl>
	<dl>
		<dt>Pending Reviews</dt>
		<dd>#NotApprovedReviews.NotApprovedReviews#</dd>
	</dl>
	<dl>
		<dt>Total Ratings</dt>
		<dd>#TotalRatings.TotalRatings#</dd>
	</dl>
</cfoutput>