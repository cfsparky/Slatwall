
<cfparam name="url.LogID" default="">
<cfparam name="url.StartRow" default="1">
<cfparam name="url.EndRow" default="250">
<cfoutput>
	<cfif url.LogID neq "">
		<style type="text/css">
			.cfdump_struct {width:650px !Important;}
			.cfdump_struct td {white-space: normal !Important; text-align:left;}
		</style>
		<cfset LogDetail = application.slat.logManager.getLogDetail(LogID=url.LogID) />
		#LogDetail.LogID#<br />
		#LogDetail.RequestStart#<br />
		#LogDetail.RequestEnd#<br />
		#LogDetail.LogType#<br />
		<cfdump var="#LogDetail.SessionValues#" /><br />
		<cfdump var="#LogDetail.FormValues#" /><br />
		<cfdump var="#LogDetail.CGIValues#" /><br />
		<cfdump var="#LogDetail.SupportingInfo#" /><br />
	<cfelse>
		<cfset AllLogs = application.slat.logManager.getAllLogs() />
		<table class="stripe">
			<tbody>
				<tr>
					<th>LogID</th>
					<th>Request Start</th>
					<th>Request End</th>
					<th>Load Time</th>
					<th>Log Type</th>
					<th>Details</th>
				</tr>
			</tbody>
			<cfloop query="AllLogs" startrow="#url.StartRow#" endrow="#url.EndRow#"> 
				<tr>
					<td>#AllLogs.LogID#</td>
					<td>#AllLogs.RequestStart#</td>
					<td>#AllLogs.RequestEnd#</td>
					<td>
						<cfif AllLogs.RequestEnd neq "" and AllLogs.RequestStart neq "">
							#TimeFormat(AllLogs.RequestEnd-AllLogs.RequestStart,'m:s')#
						</cfif>	
					</td>
					<td>#AllLogs.LogType#</td>
					<td><a href="?slatView=DebugLog&LogID=#AllLogs.LogID#">Details</a></td>
				</tr>
			</cfloop>
		</table>
	</cfif>
</cfoutput>